import SwiftUI

enum Theme {
    // 颜色
    struct Colors {
        static let primary = Color("Primary")
        static let secondary = Color("Secondary")
        static let background = Color("Background")
        
        // UIKit 颜色
        static let primaryUIColor = UIColor(named: "Primary")!
        static let secondaryUIColor = UIColor(named: "Secondary")!
        static let backgroundUIColor = UIColor(named: "Background")!
    }
    
    // 字体
    struct Fonts {
        static let title = Font.system(size: 28, weight: .bold)
        static let headline = Font.system(size: 18, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let caption = Font.system(size: 14, weight: .regular)
        static let button = Font.system(size: 16, weight: .semibold)
        
        // UIKit 字体
        static let titleUIFont = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let headlineUIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        static let bodyUIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let captionUIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let buttonUIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    // 布局尺寸
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
    }
    
    // 动画
    struct Animation {
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let fast = SwiftUI.Animation.easeInOut(duration: 0.15)
    }
} 