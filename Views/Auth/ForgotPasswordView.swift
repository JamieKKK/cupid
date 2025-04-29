import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var emailError: String? = nil
    @State private var showSuccess: Bool = false
    
    var body: some View {
        VStack(spacing: Theme.Layout.largePadding) {
            // 标题
            VStack(spacing: Theme.Layout.smallPadding) {
                Text("重置密码")
                    .font(Theme.Fonts.title)
                    .fontWeight(.bold)
                
                Text("请输入您的电子邮件地址以重置密码")
                    .font(Theme.Fonts.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 50)
            
            // 输入框
            CustomTextField(
                text: $email,
                placeholder: "电子邮件",
                icon: "envelope",
                keyboardType: .emailAddress,
                errorMessage: emailError
            )
            
            // 发送按钮
            CustomButton(
                title: "发送重置链接",
                action: resetPassword,
                isLoading: viewModel.isLoading,
                disabled: email.isEmpty
            )
            
            // 返回按钮
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回登录")
                    .font(Theme.Fonts.body)
                    .foregroundColor(Theme.Colors.primary)
            }
            .padding(.top, Theme.Layout.padding)
            
            Spacer()
        }
        .padding(.horizontal, Theme.Layout.padding)
        .alert(item: Binding<AuthAlert?>(
            get: { viewModel.errorMessage != nil ? AuthAlert(message: viewModel.errorMessage!) : nil },
            set: { _ in viewModel.errorMessage = nil }
        )) { alert in
            Alert(title: Text("错误"), message: Text(alert.message), dismissButton: .default(Text("确定")))
        }
        .alert(isPresented: $showSuccess) {
            Alert(
                title: Text("重置链接已发送"),
                message: Text("请检查您的电子邮件以获取密码重置说明"),
                dismissButton: .default(Text("确定")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func resetPassword() {
        // 验证输入
        validateEmail()
        
        // 检查错误
        if emailError != nil {
            return
        }
        
        // 重置密码
        viewModel.resetPassword(email: email) { success in
            if success {
                showSuccess = true
            }
        }
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = "请输入电子邮件地址"
            return
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            emailError = "请输入有效的电子邮件地址"
        } else {
            emailError = nil
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(viewModel: AuthViewModel())
    }
} 