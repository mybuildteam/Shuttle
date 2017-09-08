import Foundation
import Moya
import Result

extension MoyaProvider {
    @discardableResult
    func request<T: Decodable>(_ target: Target, completion: @escaping (T) -> Void) -> Cancellable {
        return self.request(target) { (response: Moya.Response) in
            do {
                let object: T = try response.mapObject()
                completion(object)
            } catch {
                print("Unable to decode object of type: \(type(of: T.self))")
            }
        }
    }

    @discardableResult
    func request(_ target: Target, completion: @escaping (Moya.Response) -> Void) -> Cancellable {
        return self.request(target) { (result: Result) in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("Network request failed: \(error.failureReason ?? "???")")
            }
        }
    }
}
