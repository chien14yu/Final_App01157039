//
//  RegistrationView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/18.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("註冊")
                    .font(.largeTitle)
                
                TextField("用戶名", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disableAutocorrection(true) // 關閉自動修正
                    .autocapitalization(.none) // 關閉自動大寫
                
                SecureField("密碼", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disableAutocorrection(true) // 關閉自動修正
                    .autocapitalization(.none) // 關閉自動大寫
                
                SecureField("確認密碼", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disableAutocorrection(true) // 關閉自動修正
                    .autocapitalization(.none) // 關閉自動大寫
                
                Button(action: register) {
                    Text("註冊")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
            
        }
    }
    
    private func register() {
        guard !username.isEmpty, password == confirmPassword else {
            errorMessage = "密碼不匹配或用戶名為空"
            showError = true
            return
        }
        
        let users = UserManager.shared.getUsers()
        if users.keys.contains(username) {
            errorMessage = "用戶名已存在"
            showError = true
            return
        }
        
        let user = User(username: username, password: password)
        UserManager.shared.saveUser(user)
        print("註冊成功！用戶名：\(username)，密碼：\(password)")
        dismiss() // 返回登入頁面
    }
}
