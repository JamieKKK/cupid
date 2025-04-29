import Foundation
import UIKit

// 这个文件可以用来生成应用图标

// 创建一个简单的应用图标
func createAppIcon() {
    let size = CGSize(width: 1024, height: 1024)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    
    // 获取上下文
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    // 绘制背景
    let primaryColor = UIColor(red: 0.706, green: 0.392, blue: 0.902, alpha: 1.0)
    primaryColor.setFill()
    context.fill(CGRect(origin: .zero, size: size))
    
    // 绘制心形图标
    let heartPath = UIBezierPath()
    let heartCenter = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
    let heartSize: CGFloat = 600
    
    // 左半部分
    heartPath.move(to: CGPoint(x: heartCenter.x, y: heartCenter.y + heartSize / 4))
    heartPath.addCurve(
        to: CGPoint(x: heartCenter.x - heartSize / 2, y: heartCenter.y - heartSize / 4),
        controlPoint1: CGPoint(x: heartCenter.x - heartSize / 8, y: heartCenter.y),
        controlPoint2: CGPoint(x: heartCenter.x - heartSize / 4, y: heartCenter.y - heartSize / 8)
    )
    heartPath.addArc(
        withCenter: CGPoint(x: heartCenter.x - heartSize / 4 - heartSize / 8, y: heartCenter.y - heartSize / 4),
        radius: heartSize / 4,
        startAngle: CGFloat.pi,
        endAngle: 0,
        clockwise: true
    )
    
    // 右半部分
    heartPath.addArc(
        withCenter: CGPoint(x: heartCenter.x + heartSize / 4 + heartSize / 8, y: heartCenter.y - heartSize / 4),
        radius: heartSize / 4,
        startAngle: CGFloat.pi,
        endAngle: 0,
        clockwise: true
    )
    heartPath.addCurve(
        to: CGPoint(x: heartCenter.x, y: heartCenter.y + heartSize / 4),
        controlPoint1: CGPoint(x: heartCenter.x + heartSize / 4, y: heartCenter.y - heartSize / 8),
        controlPoint2: CGPoint(x: heartCenter.x + heartSize / 8, y: heartCenter.y)
    )
    
    UIColor.white.setFill()
    heartPath.fill()
    
    // 获取图像
    guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
    UIGraphicsEndImageContext()
    
    // 保存图像
    if let data = image.pngData() {
        let filename = "AppIcon-1024.png"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try? data.write(to: fileURL)
        
        print("App icon saved to: \(fileURL.path)")
    }
}

// 这个文件只是参考，需要在真实的iOS项目中运行才能生成图标
// 然后将生成的图标添加到Xcode项目中 