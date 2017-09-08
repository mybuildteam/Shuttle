import Foundation
import Moya
import MoyaSugar

extension SugarTargetType {
    var params: Parameters? {
        return nil
    }
    
    var task: Task {
        return .request
    }

    var sampleData: Data {
        return Data()
    }
}
