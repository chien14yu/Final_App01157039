//
//  PushNotificationManager.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/22.
//

import UserNotifications
import UIKit

class PushNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = PushNotificationManager()

    @Published var notificationInterval: Int? // 以分鐘為單位的通知間隔（nil 表示不發送通知）

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // 請求通知授權
    func requestAuthorization(options: UNAuthorizationOptions = [.alert, .sound, .badge], completionHandler: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("通知授權失敗: \(error.localizedDescription)")
                }
                completionHandler(granted, error)
            }
        }
    }

    // 設置通知間隔並開始排程
    func setNotificationInterval(minutes: Int?) {
        notificationInterval = minutes
        print("設定的通知間隔為: \(String(describing: minutes)) 分鐘") // 調試打印
        scheduleRepeatingNotifications()
    }

    // 排程重複通知
    private func scheduleRepeatingNotifications() {
        clearNotifications()

        guard let interval = notificationInterval, interval > 0 else {
            print("通知間隔未設置或為 0，無需排程")
            return
        }

        print("開始排程通知，間隔時間為 \(interval) 分鐘") // 調試打印

        checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                print("通知未授權，無法排程")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "運動提醒"
            content.body = "您似乎還有未完成的目標呢！來看看您還有什麼未達成的目標吧！"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval * 60), repeats: true)
            let request = UNNotificationRequest(identifier: "repeatingNotification", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("通知排程失敗: \(error.localizedDescription)")
                } else {
                    print("通知排程成功，間隔: \(interval) 分鐘")
                }
            }
        }
    }

    // 清除所有排程的通知
    private func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("所有通知已清除")
    }

    // 檢查授權狀態
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    // 排程本地通知（單次通知）
    func scheduleLocalNotification(title: String, body: String, timeInterval: TimeInterval) {
        checkAuthorizationStatus { isAuthorized in
            guard isAuthorized else {
                print("通知未授權，無法排程")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("通知排程失敗: \(error.localizedDescription)")
                } else {
                    print("通知排程成功，將在 \(timeInterval / 60) 分鐘後觸發")
                }
            }
        }
    }

    // 在應用內顯示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // 確保在前台顯示通知
    }
}
