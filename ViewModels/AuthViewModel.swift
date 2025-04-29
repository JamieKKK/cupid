import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isAuthenticated = AuthService.shared.isLoggedIn()
        
        if isAuthenticated, let userId = AuthService.shared.getUserId() {
            // 这里应该从本地或远程获取用户信息
            // 为了演示，我们创建一个假用户
            let mockUser = User(
                id: userId,
                name: "测试用户",
                age: 25,
                gender: "男",
                bio: "喜欢旅行和音乐",
                location: "上海",
                photoURLs: ["https://example.com/photo.jpg"],
                interests: ["音乐", "旅行", "美食"]
            )
            currentUser = mockUser
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        let mockUser = User(
            id: "123",
            name: "测试用户",
            age: 25,
            gender: "男",
            bio: "喜欢旅行和音乐",
            location: "上海",
            photoURLs: ["https://example.com/photo.jpg"],
            interests: ["音乐", "旅行", "美食"]
        )
        self.isLoading = false
        self.isAuthenticated = true
        self.currentUser = mockUser
        
//        AuthService.shared.signInWithEmail(email: email, password: password) { [weak self] result in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.isLoading = false
//                
//                switch result {
//                case .success(let user):
//                    self.isAuthenticated = true
//                    self.currentUser = user
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//        }
    }
    
    func register(email: String, password: String, name: String, age: Int, gender: String) {
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.signUpWithEmail(email: email, password: password, name: name, age: age, gender: gender) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let user):
                    self.isAuthenticated = true
                    self.currentUser = user
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func logout() {
        if AuthService.shared.signOut() {
            isAuthenticated = false
            currentUser = nil
        } else {
            errorMessage = "登出失败，请重试"
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.resetPassword(email: email) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
} 
