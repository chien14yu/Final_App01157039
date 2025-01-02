//
//  AppContainerView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/18.
//

import SwiftUI
import SwiftData
import TipKit

struct AppContainerView: View {
    @AppStorage("currentUsername") private var currentUsername: String?
    @AppStorage("isLoggedIn") private var isLoggedIn = false // 使用 AppStorage 保存狀態
    @State private var circlePosition: CGPoint = .zero // 圓形按鈕初始位置
    @State private var isSettingsMenuPresented = false // 控制詳細頁面顯示

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if isLoggedIn, let username = currentUsername {
                // 已登入狀態：顯示主視圖
                ContentView()
                    .environment(\.currentUser, username) // 傳遞用戶名到子視圖
            } else {
                // 未登入狀態：顯示登入頁面
                LoginView(isLoggedIn: $isLoggedIn)
            }
            
            // 可拖動的半透明圓形按鈕
            GeometryReader { geometry in
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.blue)
                    }
                    .shadow(radius: 5)
                    .position(circlePosition == .zero ? initialButtonPosition(geometry: geometry) : circlePosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                circlePosition = value.location
                            }
                            .onEnded { value in
                                animateToClosestBoundary(value: value.location, geometry: geometry)
                            }
                    )
                    .onTapGesture {
                        isSettingsMenuPresented = true
                    }
                    .sheet(isPresented: $isSettingsMenuPresented) {
                        SettingsMenuView(
                            isLoggedIn: $isLoggedIn,
                            currentUser: currentUsername ?? "未知使用者"
                        )
                        .presentationDragIndicator(.visible) // 顯示拖動指示器
                    }
            }
        }
    }

    /// 計算右下角的初始按鈕位置
    private func initialButtonPosition(geometry: GeometryProxy) -> CGPoint {
        CGPoint(x: geometry.size.width - 60, y: geometry.size.height - 90)
    }

    /// 動畫將按鈕移動到最近的邊界
    private func animateToClosestBoundary(value: CGPoint, geometry: GeometryProxy) {
        let minX = 30.0
        let maxX = geometry.size.width - 30
        let minY = 30.0
        let maxY = geometry.size.height - 30

        let distances: [(CGPoint, Double)] = [
            (CGPoint(x: minX, y: value.y), abs(value.x - minX)), // 左邊
            (CGPoint(x: maxX, y: value.y), abs(value.x - maxX)), // 右邊
            (CGPoint(x: value.x, y: minY), abs(value.y - minY)), // 上邊
            (CGPoint(x: value.x, y: maxY), abs(value.y - maxY))  // 下邊
        ]

        let clampedX = max(minX, min(value.x, maxX))
        let clampedY = max(minY, min(value.y, maxY))

        let closestBoundary = distances.min(by: { $0.1 < $1.1 })?.0 ?? CGPoint(x: clampedX, y: clampedY)

        // 動畫將按鈕移動到最近的邊界
        withAnimation(.easeOut) {
            circlePosition = closestBoundary
        }
    }
}

// 環境鍵來提供當前用戶
struct CurrentUserKey: EnvironmentKey {
    static let defaultValue: String = "未知使用者"
}

extension EnvironmentValues {
    var currentUser: String {
        get { self[CurrentUserKey.self] }
        set { self[CurrentUserKey.self] = newValue }
    }
}

#Preview {
    AppContainerView().modelContainer(for: [ExerciseRecord.self, ToDo.self])
        .task {
            try? Tips.resetDatastore()
            
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
