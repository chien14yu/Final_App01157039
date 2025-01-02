import SwiftUI
import Lottie

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var isPasswordVisible = false // 控制密碼是否顯示
    @State private var showRegistrationView = false // 控制註冊頁面顯示
    @State private var showForgotPasswordView = false // 控制忘記密碼頁面顯示
    @State private var showSuccessAnimation = false // 控制成功動畫顯示

    var body: some View {
        VStack(spacing: 20) {
            if showSuccessAnimation {
                // 成功動畫
                LottieView(name: "login_animation", loopMode: .playOnce)
                    .frame(width: 100, height: 100)
                    .onAppear {
                        // 延遲切換到主畫面
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoggedIn = true
                        }
                    }
            } else {
                // 登入介面
                VStack(spacing: 20) {
                    Text("登入")
                        .font(.largeTitle)
                    
                    // 用戶名輸入框
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white) // 設置背景為白色
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

                        TextField("用戶名", text: $username)
                            .padding()
                            .disableAutocorrection(true) // 關閉自動修正
                            .autocapitalization(.none) // 關閉自動大寫
                    }
                    .frame(height: 50) // 設置輸入框高度
                    .padding(.horizontal)

                    // 密碼輸入框
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white) // 設置背景為白色
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

                        HStack {
                            if isPasswordVisible {
                                TextField("密碼", text: $password)
                                    .disableAutocorrection(true) // 關閉自動修正
                                    .autocapitalization(.none) // 關閉自動大寫
                            } else {
                                SecureField("密碼", text: $password)
                                    .disableAutocorrection(true) // 關閉自動修正
                                    .autocapitalization(.none) // 關閉自動大寫
                            }

                            Button(action: {
                                isPasswordVisible.toggle() // 切換密碼可見性
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 10) // 內部文字與框線的間距
                    }
                    .frame(height: 50) // 設置輸入框高度
                    .padding(.horizontal)

                    // 登入按鈕
                    Button(action: login) {
                        Text("登入")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    if showError {
                        Text("登入失敗！請檢查用戶名和密碼")
                            .foregroundColor(.red)
                    }
                    
                    // 註冊與忘記密碼按鈕
                    HStack {
                        Button(action: { showRegistrationView = true }) {
                            Text("還沒有帳號？立即註冊")
                                .foregroundColor(.blue)
                                .font(.footnote)
                        }
                        .sheet(isPresented: $showRegistrationView) {
                            RegistrationView()
                        }
                        
                        Spacer()
                        
                        Button(action: { showForgotPasswordView = true }) {
                            Text("忘記密碼？")
                                .foregroundColor(.blue)
                                .font(.footnote)
                        }
                        .sheet(isPresented: $showForgotPasswordView) {
                            ForgotPasswordView()
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
    }

    private func login() {
        if UserManager.shared.validateUser(username: username, password: password) {
            // 顯示成功動畫
            showSuccessAnimation = true
        } else {
            showError = true
        }
    }
}
