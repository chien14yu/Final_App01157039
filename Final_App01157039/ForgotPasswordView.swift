//
//  ForgotPasswordView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/18.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("忘記密碼")
                .font(.largeTitle)
            
            TextField("輸入您的電子郵件", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .disableAutocorrection(true) // 關閉自動修正
                .autocapitalization(.none) // 關閉自動大寫
            
            Button(action: sendResetEmail) {
                Text("發送重置郵件")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            if showSuccessMessage {
                Text("重置密碼郵件已發送到 \(email)")
                    .foregroundColor(.green)
                    .font(.footnote)
            }
        }
        .padding()
    }
    
    private func sendResetEmail() {
        guard !email.isEmpty else { return }
        showSuccessMessage = true
    }
}
