import SwiftUI
import Firebase
import IQKeyboardManagerSwift
import RealmSwift

@main
struct CupidApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    MainView(authViewModel: authViewModel)
                } else {
                    LoginView(viewModel: authViewModel)
                }
            }
            .onAppear {
                authViewModel.checkAuthStatus()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 配置Firebase
        FirebaseApp.configure()
        
        // 配置键盘管理器
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // 配置Realm数据库
        initializeRealm()
        
        return true
    }
    
    private func initializeRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // 在这里添加迁移逻辑
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
} 