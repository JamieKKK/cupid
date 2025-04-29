import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var gender: String = "男"
    
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var nameError: String? = nil
    @State private var ageError: String? = nil
    
    private let genderOptions = ["男", "女", "其他"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Layout.largePadding) {
                // 标题
                VStack(spacing: Theme.Layout.smallPadding) {
                    Text("创建账号")
                        .font(Theme.Fonts.title)
                        .fontWeight(.bold)
                    
                    Text("注册以开始寻找您的理想伴侣")
                        .font(Theme.Fonts.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 50)
                
                // 输入框
                VStack(spacing: Theme.Layout.padding) {
                    CustomTextField(
                        text: $name,
                        placeholder: "姓名",
                        icon: "person",
                        errorMessage: nameError
                    )
                    
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
                    
                    CustomTextField(
                        text: $confirmPassword,
                        placeholder: "确认密码",
                        icon: "lock",
                        isSecure: true,
                        errorMessage: confirmPasswordError
                    )
                    
                    CustomTextField(
                        text: $age,
                        placeholder: "年龄",
                        icon: "calendar",
                        keyboardType: .numberPad,
                        errorMessage: ageError
                    )
                    
                    // 性别选择
                    VStack(alignment: .leading, spacing: 8) {
                        Text("性别")
                            .font(Theme.Fonts.body)
                            .foregroundColor(.gray)
                        
                        Picker("性别", selection: $gender) {
                            ForEach(genderOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                // 注册按钮
                CustomButton(
                    title: "注册",
                    action: register,
                    isLoading: viewModel.isLoading,
                    disabled: email.isEmpty || password.isEmpty || name.isEmpty || age.isEmpty
                )
                
                // 返回按钮
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("已有账号? 返回登录")
                        .font(Theme.Fonts.body)
                        .foregroundColor(Theme.Colors.primary)
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
    }
    
    private func register() {
        // 验证输入
        validateName()
        validateEmail()
        validatePassword()
        validateConfirmPassword()
        validateAge()
        
        // 检查错误
        if nameError != nil || emailError != nil || passwordError != nil || confirmPasswordError != nil || ageError != nil {
            return
        }
        
        // 注册
        let ageValue = Int(age) ?? 18
        viewModel.register(email: email, password: password, name: name, age: ageValue, gender: gender)
    }
    
    private func validateName() {
        if name.isEmpty {
            nameError = "请输入姓名"
        } else if name.count < 2 {
            nameError = "姓名至少需要2个字符"
        } else {
            nameError = nil
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
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "请输入密码"
        } else if password.count < 6 {
            passwordError = "密码长度至少为6位"
        } else {
            passwordError = nil
        }
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "请确认密码"
        } else if confirmPassword != password {
            confirmPasswordError = "两次输入的密码不一致"
        } else {
            confirmPasswordError = nil
        }
    }
    
    private func validateAge() {
        if age.isEmpty {
            ageError = "请输入年龄"
            return
        }
        
        if let ageValue = Int(age) {
            if ageValue < 18 {
                ageError = "您必须年满18岁才能使用此应用"
            } else if ageValue > 120 {
                ageError = "请输入有效的年龄"
            } else {
                ageError = nil
            }
        } else {
            ageError = "请输入有效的年龄"
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: AuthViewModel())
    }
} 