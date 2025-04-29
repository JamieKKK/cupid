import Foundation
import RealmSwift

class Match: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var userId: String
    @Persisted var matchedUserId: String
    @Persisted var matchDate: Date
    @Persisted var lastMessageDate: Date?
    @Persisted var hasUnreadMessages: Bool = false
    @Persisted var matchStatus: String = "active" // active, archived, blocked
    
    convenience init(id: String, userId: String, matchedUserId: String) {
        self.init()
        self.id = id
        self.userId = userId
        self.matchedUserId = matchedUserId
        self.matchDate = Date()
    }
    
    func isRecent() -> Bool {
        // 过去24小时内的匹配被视为"新的"
        let twentyFourHoursAgo = Date().addingTimeInterval(-24 * 60 * 60)
        return matchDate > twentyFourHoursAgo
    }
    
    func daysSinceLastMessage() -> Int? {
        guard let lastMessageDate = lastMessageDate else {
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastMessageDate, to: Date())
        return components.day
    }
    
    func isActive() -> Bool {
        return matchStatus == "active"
    }
    
    func isBlocked() -> Bool {
        return matchStatus == "blocked"
    }
}

// MARK: - 用于远程API的扩展
extension Match {
    func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            "id": id,
            "user_id": userId,
            "matched_user_id": matchedUserId,
            "match_date": matchDate.timeIntervalSince1970,
            "has_unread_messages": hasUnreadMessages,
            "match_status": matchStatus
        ]
        
        if let lastMessageDate = lastMessageDate {
            json["last_message_date"] = lastMessageDate.timeIntervalSince1970
        }
        
        return json
    }
    
    static func fromJSON(_ json: [String: Any]) -> Match? {
        guard let id = json["id"] as? String,
              let userId = json["user_id"] as? String,
              let matchedUserId = json["matched_user_id"] as? String else {
            return nil
        }
        
        let match = Match(id: id, userId: userId, matchedUserId: matchedUserId)
        
        if let matchDateTimestamp = json["match_date"] as? TimeInterval {
            match.matchDate = Date(timeIntervalSince1970: matchDateTimestamp)
        }
        
        if let lastMessageDateTimestamp = json["last_message_date"] as? TimeInterval {
            match.lastMessageDate = Date(timeIntervalSince1970: lastMessageDateTimestamp)
        }
        
        if let hasUnreadMessages = json["has_unread_messages"] as? Bool {
            match.hasUnreadMessages = hasUnreadMessages
        }
        
        if let matchStatus = json["match_status"] as? String {
            match.matchStatus = matchStatus
        }
        
        return match
    }
} 