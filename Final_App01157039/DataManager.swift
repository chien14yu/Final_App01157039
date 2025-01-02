//
//  DataManager.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/18.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let userDefaults = UserDefaults.standard

    // 儲存數據
    func saveRecords<T: Codable>(_ records: [T], for user: String, key: String) {
        guard !user.isEmpty else {
            print("用戶名不可為空")
            return
        }
        let userKey = "\(user)_\(key)"
        do {
            let encoded = try JSONEncoder().encode(records)
            userDefaults.set(encoded, forKey: userKey)
            print("保存成功: \(records) 到鍵值 \(userKey)")
        } catch {
            print("保存數據失敗: \(error.localizedDescription)")
        }
    }

    func getRecords<T: Codable>(for user: String, key: String, type: T.Type) -> [T] {
        guard !user.isEmpty else {
            print("用戶名不可為空")
            return []
        }
        let userKey = "\(user)_\(key)"
        guard let data = userDefaults.data(forKey: userKey) else {
            print("沒有找到數據，鍵值: \(userKey)")
            return []
        }
        do {
            let decoded = try JSONDecoder().decode([T].self, from: data)
            print("讀取成功: \(decoded) 從鍵值 \(userKey)")
            return decoded
        } catch {
            print("讀取數據失敗: \(error.localizedDescription)")
            return []
        }
    }

}
