import SwiftUI

struct MainView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首页 - 匹配
            Text("匹配页面")
                .font(Theme.Fonts.title)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("匹配")
                }
                .tag(0)
            
            // 消息
            Text("消息页面")
                .font(Theme.Fonts.title)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("消息")
                }
                .tag(1)
            
            // 个人资料
            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(2)
        }
        .accentColor(Theme.Colors.primary)
    }
}

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = authViewModel.currentUser {
                    // 用户头像
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(Theme.Colors.primary)
                            .padding()
                        
                        Text(user.name)
                            .font(Theme.Fonts.title)
                        
                        Text("\(user.age)岁, \(user.gender)")
                            .font(Theme.Fonts.body)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    // 设置列表
                    List {
                        Section(header: Text("账号")) {
                            NavigationLink(destination: Text("编辑个人资料")) {
                                HStack {
                                    Image(systemName: "person")
                                    Text("编辑个人资料")
                                }
                            }
                            
                            NavigationLink(destination: Text("隐私设置")) {
                                HStack {
                                    Image(systemName: "lock")
                                    Text("隐私设置")
                                }
                            }
                        }
                        
                        Section(header: Text("应用")) {
                            NavigationLink(destination: Text("通知设置")) {
                                HStack {
                                    Image(systemName: "bell")
                                    Text("通知设置")
                                }
                            }
                            
                            NavigationLink(destination: Text("帮助与支持")) {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                    Text("帮助与支持")
                                }
                            }
                        }
                        
                        Section {
                            Button(action: {
                                authViewModel.logout()
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("退出登录")
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    // 如果未加载用户信息，显示加载中
                    ProgressView()
                }
            }
            .navigationTitle("个人资料")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authViewModel: AuthViewModel())
    }
} 