//
//  MainView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/18.
//

import SwiftUI

struct MainView: View {
    @State private var showMenu = false // 控制選單顯示
    @State private var isLoggedIn = true // 模擬登入狀態
    @State private var currentUser = UserDefaults.standard.string(forKey: "currentUsername") ?? "未知使用者"

    var body: some View {
        ZStack {
            VStack {
                // 主內容
                Text("歡迎！已成功登入")
                    .font(.largeTitle)
                    .padding()
            }

            // 右下角浮動設定按鈕
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showMenu.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                    .sheet(isPresented: $showMenu) {
                        SettingsMenuView(isLoggedIn: $isLoggedIn, currentUser: currentUser)
                    }
                }
            }
        }
    }
}
