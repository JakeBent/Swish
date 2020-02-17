import UIKit
import Alamofire

class FirebaseService: NSObject {

    static let shared = FirebaseService()
    
    func getGames(dayOffset: Int, done: @escaping (Error?, [[String: Any]]) -> Void) {
        guard let start = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) else {
            done(Errors.badData, [])
            return
        }
        
        let startDay = Calendar.current.startOfDay(for: start)
        
        guard let endDay = Calendar.current.date(byAdding: .day, value: 1, to: startDay) else {
            done(Errors.badData, [])
            return
        }
        

        let params: [String: Any] = [
            "orderBy": "\"timeUtc\"",
            "startAt": startDay.timeIntervalSince1970,
            "endAt": endDay.timeIntervalSince1970
        ]
        
        request("\(Constants.urls.firebase)/games/2017-18/.json", parameters: params).responseJSON { response in
            guard let resultDict = response.value as? [String: [String: Any]],
                response.error == nil else {
                done(response.error ?? Errors.badData, [])
                return
            }
            
            var results: [[String: Any]]  = []
            for (_, value) in resultDict {
                results.append(value)
            }
            
            done(nil, results)
        }
    }
}
