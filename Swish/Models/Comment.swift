import UIKit

class Comment: NSObject {
    let id: String
    let created: Date
    let author: String
    let body: String
    let html: String
    let score: Int?
    let upvotes: Int
    let downvotes: Int
    let isEdited: Bool
    let flair: String?
    let isSubmitter: Bool
    let permalink: String
    var isCollapsed: Bool
    let isStickied: Bool
    let isScoreHidden: Bool
    let isGilded: Int
    let replies: [Comment]
    
    init(id: String, created: Date, author: String, body: String, html: String, score: Int?, upvotes: Int, downvotes: Int, isEdited: Bool, flair: String?, isSubmitter: Bool, permalink: String, isCollapsed: Bool, isStickied: Bool, isScoreHidden: Bool, isGilded: Int, replies: [Comment]) {
        
        self.id = id
        self.created = created
        self.author = author
        self.body = body
        self.html = html
        self.score = score
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.isEdited = isEdited
        self.flair = flair
        self.isSubmitter = isSubmitter
        self.permalink = permalink
        self.isCollapsed = isCollapsed
        self.isStickied = isStickied
        self.isScoreHidden = isScoreHidden
        self.isGilded = isGilded
        self.replies = replies
        super.init()
    }
    
    static func createComments(fromJson json: [[String: Any]]?) -> [Comment] {
        guard let json = json,
            let commentsData = json[1]["data"] as? [String: Any],
            let commentsJson = commentsData["children"] as? [[String: Any]]
            else { return [] }
        
        return commentsJson.compactMap { create(fromJson: $0) }
    }
    
    static func create(fromJson json: [String: Any?]?) -> Comment? {
        guard let data = json?["data"] as? [String: Any?],
            let id = data["id"] as? String,
            let createdTimeInterval = data["created"] as? TimeInterval,
            let author = data["author"] as? String,
            let body = data["body"] as? String,
            let html = data["body_html"] as? String,
            let permalink = data["permalink"] as? String
            else { return nil }
        
        var replies: [Comment] = []
        if let repliesObj = data["replies"] as? [String: Any?],
            let repliesData = repliesObj["data"] as? [String: Any?],
            let repliesArr = repliesData["children"] as? [[String: Any?]] {
        
            replies = repliesArr.compactMap { create(fromJson: $0) }
        }
        
        return Comment(
            id: id,
            created: Date(timeIntervalSince1970: createdTimeInterval),
            author: author,
            body: body,
            html: html,
            score: data["score"] as? Int,
            upvotes: data["ups"] as? Int ?? 0,
            downvotes: data["downs"] as? Int ?? 0,
            isEdited: data["edited"] as? Bool ?? false,
            flair: data["author_flair_text"] as? String,
            isSubmitter: data["is_submitter"] as? Bool ?? false,
            permalink: permalink,
            isCollapsed: data["collapsed"] as? Bool ?? false,
            isStickied: data["stickied"] as? Bool ?? false,
            isScoreHidden: data["score_hidden"] as? Bool ?? false,
            isGilded: data["gilded"] as? Int ?? 0,
            replies: replies
        )
    }
}
