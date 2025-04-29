import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var age: Int
    @Persisted var gender: String
    @Persisted var bio: String
    @Persisted var location: String
    @Persisted var photoURLs: List<String>
    @Persisted var interests: List<String>
    @Persisted var isVerified: Bool = false
    @Persisted var createdAt: Date
    @Persisted var lastActive: Date
    @Persisted var membershipType: String = "free"
    
    convenience init(id: String, name: String, age: Int, gender: String, bio: String, location: String, photoURLs: [String], interests: [String], isVerified: Bool = false, membershipType: String = "free") {
        self.init()
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        self.bio = bio
        self.location = location
        
        let photoList = List<String>()
        photoList.append(objectsIn: photoURLs)
        self.photoURLs = photoList
        
        let interestList = List<String>()
        interestList.append(objectsIn: interests)
        self.interests = interestList
        
        self.isVerified = isVerified
        self.createdAt = Date()
        self.lastActive = Date()
        self.membershipType = membershipType
    }
    
    func isOnline() -> Bool {
        // 如果用户在过去15分钟活跃，则认为他们在线
        let fifteenMinutesAgo = Date().addingTimeInterval(-15 * 60)
        return lastActive > fifteenMinutesAgo
    }
    
    func isPremium() -> Bool {
        return membershipType != "free"
    }
}

// MARK: - 用于远程API的扩展
extension User {
    func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            "id": id,
            "name": name,
            "age": age,
            "gender": gender,
            "bio": bio,
            "location": location,
            "photo_urls": Array(photoURLs),
            "interests": Array(interests),
            "is_verified": isVerified,
            "created_at": createdAt.timeIntervalSince1970,
            "last_active": lastActive.timeIntervalSince1970,
            "membership_type": membershipType
        ]
        return json
    }
    
    static func fromJSON(_ json: [String: Any]) -> User? {
        guard let id = json["id"] as? String,
              let name = json["name"] as? String,
              let age = json["age"] as? Int,
              let gender = json["gender"] as? String,
              let bio = json["bio"] as? String,
              let location = json["location"] as? String,
              let photoURLs = json["photo_urls"] as? [String],
              let interests = json["interests"] as? [String] else {
            return nil
        }
        
        let user = User(
            id: id,
            name: name,
            age: age,
            gender: gender,
            bio: bio,
            location: location,
            photoURLs: photoURLs,
            interests: interests
        )
        
        if let isVerified = json["is_verified"] as? Bool {
            user.isVerified = isVerified
        }
        
        if let createdAtTimestamp = json["created_at"] as? TimeInterval {
            user.createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        }
        
        if let lastActiveTimestamp = json["last_active"] as? TimeInterval {
            user.lastActive = Date(timeIntervalSince1970: lastActiveTimestamp)
        }
        
        if let membershipType = json["membership_type"] as? String {
            user.membershipType = membershipType
        }
        
        return user
    }
} 