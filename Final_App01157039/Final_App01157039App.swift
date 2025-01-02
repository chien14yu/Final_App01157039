//
//  Final_App01157039App.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/28.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct Final_App01157039App: App {
    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .onAppear {
                    PushNotificationManager.shared.requestAuthorization { granted, error in
                        if granted {
                            print("通知授權成功")
                        } else {
                            print("通知授權失敗: \(String(describing: error?.localizedDescription))")
                        }
                    }
                }
                .task {
                    try? Tips.resetDatastore()
                    
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
