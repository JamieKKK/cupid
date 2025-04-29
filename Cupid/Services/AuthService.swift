import Foundation
import Firebase
import KeychainSwift

class AuthService {
    static let shared = AuthService()
    private let keychain = KeychainSwift()
    private let authTokenKey = "auth_token"
    private let userIdKey = "user_id"
    
    private init() {}
    
    // MARK: - Firebase认证方法
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                completion(.failure(AuthError.authFailed))
                return
            }
            
            // 保存认证令牌和用户ID
            self.saveAuthToken(token: authResult.user.uid)
            self.saveUserId(userId: authResult.user.uid)
            
            // 创建基本用户对象
            let mockUser = User(
                id: authResult.user.uid,
                name: authResult.user.displayName ?? "用户",
                age: 18,
                gender: "未知",
                bio: "",
                location: "",
                photoURLs: [],
                interests: []
            )
            
            completion(.success(mockUser))
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String, age: Int, gender: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                completion(.failure(AuthError.authFailed))
                return
            }
            
            // 保存认证令牌和用户ID
            self.saveAuthToken(token: authResult.user.uid)
            self.saveUserId(userId: authResult.user.uid)
            
            // 创建用户个人资料
            let user = User(
                id: authResult.user.uid,
                name: name,
                age: age,
                gender: gender,
                bio: "",
                location: "",
                photoURLs: [],
                interests: []
            )
            
            completion(.success(user))
        }
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            // 清除本地存储的令牌和用户ID
            keychain.delete(authTokenKey)
            keychain.delete(userIdKey)
            return true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            return false
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Token和用户ID管理
    
    func saveAuthToken(token: String) {
        keychain.set(token, forKey: authTokenKey)
    }
    
    func getAuthToken() -> String? {
        return keychain.get(authTokenKey)
    }
    
    func saveUserId(userId: String) {
        keychain.set(userId, forKey: userIdKey)
    }
    
    func getUserId() -> String? {
        return keychain.get(userIdKey)
    }
    
    func isLoggedIn() -> Bool {
        return getAuthToken() != nil && getUserId() != nil
    }
}

// MARK: - 错误类型

enum AuthError: Error {
    case authFailed
    case verificationFailed
    case verificationIDNotFound
    case networkError
    case userNotFound
    
    var localizedDescription: String {
        switch self {
        case .authFailed:
            return "认证失败，请重试"
        case .verificationFailed:
            return "验证码发送失败，请重试"
        case .verificationIDNotFound:
            return "验证ID丢失，请重新获取验证码"
        case .networkError:
            return "网络连接错误"
        case .userNotFound:
            return "用户不存在"
        }
    }
} 