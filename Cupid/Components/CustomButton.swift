import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let isLoading: Bool
    let disabled: Bool
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary, outline
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return Theme.Colors.primary
            case .secondary:
                return Theme.Colors.secondary
            case .outline:
                return Color.clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .secondary:
                return .white
            case .outline:
                return Theme.Colors.primary
            }
        }
        
        var borderColor: Color {
            switch self {
            case .outline:
                return Theme.Colors.primary
            default:
                return Color.clear
            }
        }
    }
    
    init(
        title: String,
        action: @escaping () -> Void,
        isLoading: Bool = false,
        disabled: Bool = false,
        style: ButtonStyle = .primary
    ) {
        self.title = title
        self.action = action
        self.isLoading = isLoading
        self.disabled = disabled
        self.style = style
    }
    
    var body: some View {
        Button(action: {
            if !isLoading && !disabled {
                action()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .padding(.trailing, 5)
                }
                
                Text(title)
                    .font(Theme.Fonts.button)
                    .foregroundColor(style.foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Theme.Layout.buttonHeight)
            .background(style.backgroundColor)
            .cornerRadius(Theme.Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style == .outline ? 1 : 0)
            )
            .opacity(disabled || isLoading ? 0.7 : 1.0)
        }
        .disabled(disabled || isLoading)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomButton(title: "主要按钮", action: {})
            
            CustomButton(title: "次要按钮", action: {}, style: .secondary)
            
            CustomButton(title: "轮廓按钮", action: {}, style: .outline)
            
            CustomButton(title: "禁用按钮", action: {}, disabled: true)
            
            CustomButton(title: "加载中", action: {}, isLoading: true)
        }
        .padding()
    }
} 