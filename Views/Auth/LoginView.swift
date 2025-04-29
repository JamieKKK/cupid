import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var showForgotPassword: Bool = false
    @State private var showRegistration: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Layout.largePadding) {
                // 标题
                VStack(spacing: Theme.Layout.smallPadding) {
                    Text("欢迎回来")
                        .font(Theme.Fonts.title)
                        .fontWeight(.bold)
                    
                    Text("登录以继续使用Cupid")
                        .font(Theme.Fonts.body)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                
                // 输入框
                VStack(spacing: Theme.Layout.padding) {
                    CustomTextField(
                        text: $email,
                        placeholder: "电子邮件",
                        icon: "envelope",
                        keyboardType: .emailAddress,
                        errorMessage: emailError
                    )
                    
                    CustomTextField(
                        text: $password,
                        placeholder: "密码",
                        icon: "lock",
                        isSecure: true,
                        errorMessage: passwordError
                    )
                    
                    // 忘记密码按钮
                    HStack {
                        Spacer()
                        Button(action: {
                            showForgotPassword = true
                        }) {
                            Text("忘记密码?")
                                .font(Theme.Fonts.caption)
                                .foregroundColor(Theme.Colors.primary)
                        }
                    }
                }
                
                // 登录按钮
                CustomButton(
                    title: "登录",
                    action: login,
                    isLoading: viewModel.isLoading,
                    disabled: email.isEmpty || password.isEmpty
                )
                
                // 分隔线
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("或者")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                
                // 社交登录
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "applelogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                
                // 注册
                HStack {
                    Text("还没有账号?")
                        .font(Theme.Fonts.body)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        showRegistration = true
                    }) {
                        Text("立即注册")
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.primary)
                    }
                }
                .padding(.top, Theme.Layout.padding)
                
                Spacer()
            }
            .padding(.horizontal, Theme.Layout.padding)
        }
        .alert(item: Binding<AuthAlert?>(
            get: { viewModel.errorMessage != nil ? AuthAlert(message: viewModel.errorMessage!) : nil },
            set: { _ in viewModel.errorMessage = nil }
        )) { alert in
            Alert(title: Text("错误"), message: Text(alert.message), dismissButton: .default(Text("确定")))
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $showRegistration) {
            RegisterView(viewModel: viewModel)
        }
    }
    
    private func login() {
        // 验证输入
        validateEmail()
        validatePassword()
        
        // 检查错误
        if emailError != nil || passwordError != nil {
            return
        }
        
        // 登录
        viewModel.login(email: email, password: password)
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
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "请输入密码"
        } else if password.count < 6 {
            passwordError = "密码长度至少为6位"
        } else {
            passwordError = nil
        }
    }
}

struct AuthAlert: Identifiable {
    var id: String { message }
    let message: String
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
    }
} 