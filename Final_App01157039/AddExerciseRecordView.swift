//
//  AddExerciseRecordView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/29.
//

import SwiftUI
import SwiftData

struct AddExerciseRecordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var timeSlot = "上午"
    @State private var selectedActivity = "跑步"
    @State private var duration: Double = 30.0

    let activities = ["跑步", "游泳", "瑜伽", "健身", "散步", "籃球", "足球", "排球", "登山", "跳繩"]

    let onSave: (ExerciseRecord) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("運動資訊")) {
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                    Picker("時段", selection: $timeSlot) {
                        Text("上午").tag("上午")
                        Text("下午").tag("下午")
                        Text("晚上").tag("晚上")
                    }
                    Picker("運動項目", selection: $selectedActivity) {
                        ForEach(activities, id: \.self) { activity in
                            Text(activity)
                        }
                    }
                    Stepper(value: $duration, in: 0...300, step: 5) {
                        Text("時長: \(duration, specifier: "%.0f") 分鐘")
                    }
                }
            }
            .navigationTitle("新增運動記錄")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        let newRecord = ExerciseRecord(
                            date: date,
                            timeSlot: timeSlot,
                            activity: selectedActivity,
                            duration: duration
                        )
                        print("準備新增運動記錄: 日期=\(date), 時段=\(timeSlot), 項目=\(selectedActivity), 時長=\(duration)") // 檢查表單輸入
                        onSave(newRecord)
                        dismiss()
                    }
                }

            }
        }
    }
}
