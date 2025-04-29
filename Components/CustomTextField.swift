import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String?
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let errorMessage: String?
    
    @State private var isShowingPassword: Bool = false
    
    init(
        text: Binding<String>,
        placeholder: String,
        icon: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        errorMessage: String? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(errorMessage == nil ? .gray : .red)
                        .frame(width: 20, height: 20)
                }
                
                Group {
                    if isSecure && !isShowingPassword {
                        SecureField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                    }
                }
                .font(Theme.Fonts.body)
                
                if isSecure {
                    Button(action: {
                        isShowingPassword.toggle()
                    }) {
                        Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(Theme.Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Layout.cornerRadius)
                    .stroke(errorMessage == nil ? Color.clear : .red, lineWidth: 1)
            )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomTextField(
                text: .constant(""),
                placeholder: "电子邮件",
                icon: "envelope"
            )
            
            CustomTextField(
                text: .constant("test@example.com"),
                placeholder: "电子邮件",
                icon: "envelope",
                keyboardType: .emailAddress,
                errorMessage: "请输入有效的电子邮件地址"
            )
            
            CustomTextField(
                text: .constant(""),
                placeholder: "密码",
                icon: "lock",
                isSecure: true
            )
        }
        .padding()
    }
} 