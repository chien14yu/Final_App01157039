//
//  NotificationSettingsView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/22.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var selectedInterval: Int? = PushNotificationManager.shared.notificationInterval
    @State private var isAuthorized = false // 授權狀態
    private let intervals = [30, 60, 90, 120, 150, 180, nil] // nil 表示不發送通知

    var body: some View {
        NavigationView {
            Form {
                // 通知間隔設置
                Section(header: Text("通知間隔")) {
                    Picker("間隔時間", selection: $selectedInterval) {
                        ForEach(intervals, id: \.self) { interval in
                            if let interval = interval {
                                Text("\(interval) 分鐘").tag(interval as Int?)
                            } else {
                                Text("不要發送通知").tag(nil as Int?)
                            }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedInterval) { newValue in
                        print("選擇的通知間隔: \(String(describing: newValue)) 分鐘") // 調試打印
                        PushNotificationManager.shared.setNotificationInterval(minutes: newValue)
                    }
                }

                // 授權狀態顯示
                Section(header: Text("授權狀態")) {
                    if isAuthorized {
                        HStack {
                            Text("通知已授權")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("通知未授權，請到系統設置中啟用通知。")
                                .foregroundColor(.red)
                                .font(.footnote)
                            Button("開啟通知權限") {
                                openAppSettings()
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }

                // 測試通知功能
                Section {
                    Button("測試通知") {
                        guard let interval = selectedInterval else {
                            print("無法測試，通知間隔未設置")
                            return
                        }
                        testNotification(interval: interval)
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("推送通知設定")
            .onAppear(perform: checkAuthorizationStatus)
        }
    }

    private func checkAuthorizationStatus() {
        PushNotificationManager.shared.checkAuthorizationStatus { isAuthorized in
            self.isAuthorized = isAuthorized
        }
    }

    private func testNotification(interval: Int) {
        print("開始測試通知，間隔設定為 \(interval) 分鐘")

        PushNotificationManager.shared.checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                print("通知未授權，無法測試")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "運動提醒 (測試)"
            content.body = "這是一條測試通知，將模擬每 \(interval) 分鐘的通知樣式。"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 固定 5 秒觸發
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("測試通知排程失敗: \(error.localizedDescription)")
                } else {
                    print("測試通知已成功排程，將在 5 秒後觸發")
                }
            }
        }
    }


    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
