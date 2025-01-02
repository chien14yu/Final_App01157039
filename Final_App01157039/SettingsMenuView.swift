import SwiftUI

struct SettingsMenuView: View {
    @Binding var isLoggedIn: Bool
    @State private var showLoginView = false
    @State private var showForgotPasswordView = false

    let currentUser: String

    var body: some View {
        NavigationView {
            List {
                // 當前使用者
                if isLoggedIn {
                    Section(header: Text("當前使用者")) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                            Text("登入者：\(currentUser)")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }

                // 登入/登出按鈕
                if isLoggedIn {
                    Button(action: logout) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.backward")
                            Text("登出")
                        }
                    }
                } else {
                    Button(action: { showLoginView = true }) {
                        HStack {
                            Image(systemName: "person")
                            Text("登入")
                        }
                    }
                }

                // 忘記密碼
                Button(action: { showForgotPasswordView = true }) {
                    HStack {
                        Image(systemName: "key")
                        Text("忘記密碼")
                    }
                }

                // 更多設定
                NavigationLink(destination: NotificationSettingsView()) {
                    HStack {
                        Image(systemName: "gear")
                        Text("更多設定")
                    }
                }
            }
            .navigationTitle("設定選單")
            .sheet(isPresented: $showLoginView) {
                LoginView(isLoggedIn: $isLoggedIn)
            }
            .sheet(isPresented: $showForgotPasswordView) {
                ForgotPasswordView()
            }
        }
    }

    private func logout() {
        isLoggedIn = false // 登出
    }

    private func testLocalNotification() {
        PushNotificationManager.shared.scheduleLocalNotification(
            title: "測試通知",
            body: "這是一個測試通知，5秒後觸發。",
            timeInterval: 5
        )
    }
}
