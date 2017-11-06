import UIKit

class RedditService: NSObject {

    static let shared = RedditService()
    
    func fetchComments(path: String, done: @escaping (Error?, [Comment]) -> Void) {
        let filePath = Bundle.main.path(forResource: "reddit_comments", ofType: "json")!
        let data = FileManager.default.contents(atPath: filePath)!
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { done(Errors.jsonError, []); return }
        
        done(nil, Comment.createComments(fromJson: json))
    }
}
