//
//  AddToDoView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/29.
//

import SwiftUI
import SwiftData

struct AddToDoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.currentUser) private var currentUser
    @State private var date = Date()
    @State private var selectedActivity = "跑步"
    @State private var targetDuration: Double = 30.0

    let activities = ["跑步", "游泳", "瑜伽", "健身", "散步", "籃球", "足球", "排球", "登山", "跳繩"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("目標資訊")) {
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                    Picker("運動項目", selection: $selectedActivity) {
                        ForEach(activities, id: \.self) { activity in
                            Text(activity)
                        }
                    }
                    Stepper(value: $targetDuration, in: 0...300, step: 5) {
                        Text("目標時長: \(targetDuration, specifier: "%.0f") 分鐘")
                    }
                }
            }
            .navigationTitle("新增目標")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newToDo = ToDo(
                            date: date,
                            activity: selectedActivity,
                            targetDuration: targetDuration,
                            isCompleted: false
                        )
                        print("新增的目標: \(newToDo)")

                        // 加載現有目標
                        var todos = DataManager.shared.getRecords(for: currentUser, key: "todos", type: ToDo.self)
                        todos.append(newToDo)

                        // 保存更新後的目標
                        DataManager.shared.saveRecords(todos, for: currentUser, key: "todos")
                        dismiss()
                    }
                }
            }
        }
    }
}
