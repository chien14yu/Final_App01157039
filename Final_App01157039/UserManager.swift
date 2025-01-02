//
//  UserManager.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/18.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
}

class UserManager {
    static let shared = UserManager()
    private let userDefaults = UserDefaults.standard
    private let userKey = "users"

    // 保存用戶數據
    func saveUser(_ user: User) {
        var users = getUsers()
        users[user.username] = user.password
        do {
            let encoded = try JSONEncoder().encode(users)
            userDefaults.set(encoded, forKey: userKey)
        } catch {
            print("保存用戶失敗: \(error.localizedDescription)")
        }
    }

    // 驗證用戶
    func validateUser(username: String, password: String) -> Bool {
        let users = getUsers()
        print("當前用戶數據: \(users)") // 調試用，確認數據是否正確
        return users[username] == password
    }

    // 獲取所有用戶
    func getUsers() -> [String: String] {
        guard let data = userDefaults.data(forKey: userKey) else { return [:] }
        do {
            let decoded = try JSONDecoder().decode([String: String].self, from: data)
            return decoded
        } catch {
            print("讀取用戶數據失敗: \(error.localizedDescription)")
            return [:]
        }
    }
}
