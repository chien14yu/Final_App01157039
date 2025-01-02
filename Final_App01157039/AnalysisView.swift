//
//  AnalysisView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/29.
//

import SwiftUI
import Charts
import SwiftData
import TipKit

struct AnalysisView: View {
    @Environment(\.currentUser) private var currentUser
    @State private var exerciseRecords: [ExerciseRecord] = []
    @State private var todos: [ToDo] = []
    @State private var selectedDate = Date()
    @State private var isCalendarExpanded = false

    private let analysisTip = AnalysisTip()

    var body: some View {
        NavigationView {
            ZStack {
                // 背景視圖
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        calendarView
                        
                        if filteredTodos(for: selectedDate).isEmpty && filteredRecords(for: selectedDate).isEmpty {
                            Text("該日期沒有目標或運動紀錄")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            VStack(spacing: 20) {
                                Text("分析日期: \(formattedDate(selectedDate))")
                                    .font(.headline)
                                    .padding()
                                
                                Chart {
                                    ForEach(filteredTodos(for: selectedDate), id: \.id) { todo in
                                        BarMark(
                                            x: .value("運動項目", todo.activity),
                                            y: .value("完成時間", completedTime(for: todo))
                                        )
                                        .foregroundStyle(Color.green)
                                        
                                        if remainingTime(for: todo) > 0 {
                                            BarMark(
                                                x: .value("運動項目", todo.activity),
                                                y: .value("剩餘時間", remainingTime(for: todo))
                                            )
                                            .foregroundStyle(Color.red.opacity(0.7))
                                        }
                                    }
                                }
                                .frame(height: 300)
                                .padding()
                                
                                let unfinishedTodos = filteredTodos(for: selectedDate).filter { remainingTime(for: $0) > 0 }
                                if !unfinishedTodos.isEmpty {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("未完成的目標：")
                                            .font(.headline)
                                        
                                        ForEach(unfinishedTodos, id: \.id) { todo in
                                            HStack {
                                                Text("運動項目：\(todo.activity)")
                                                    .font(.subheadline)
                                                Spacer()
                                                Text("剩餘時間：\(remainingTime(for: todo), specifier: "%.1f") 分鐘")
                                                    .font(.footnote)
                                                    .foregroundColor(.red)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .background(Color(.secondarySystemBackground))
                                            .cornerRadius(8)
                                        }
                                    }
                                } else {
                                    Text("恭喜！所有目標達成")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                        .padding()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("分析")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { /* Action for additional info */ }) {
                            Image(systemName: "info.circle")
                        }
                        .popoverTip(analysisTip, arrowEdge: .top)
                    }
                }
                .onAppear {
                    refreshData()
                }
            }
        }
    }
    
    private func refreshData() {
        exerciseRecords = DataManager.shared.getRecords(for: currentUser, key: "exerciseRecords", type: ExerciseRecord.self)
        todos = DataManager.shared.getRecords(for: currentUser, key: "todos", type: ToDo.self)
    }
    
    private func filteredRecords(for date: Date) -> [ExerciseRecord] {
        exerciseRecords.filter { isSameDate($0.date, date) }
    }
    
    private func filteredTodos(for date: Date) -> [ToDo] {
        todos.filter { isSameDate($0.date, date) }
    }
    
    private func completedTime(for todo: ToDo) -> Double {
        exerciseRecords
            .filter { isSameDate($0.date, todo.date) && $0.activity.caseInsensitiveCompare(todo.activity) == .orderedSame }
            .map { $0.duration }
            .reduce(0, +)
    }
    
    private func remainingTime(for todo: ToDo) -> Double {
        max(todo.targetDuration - completedTime(for: todo), 0)
    }
    
    private func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private var calendarView: some View {
        VStack {
            if isCalendarExpanded {
                DatePicker(
                    "選擇日期",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { _ in
                    isCalendarExpanded = false
                }
                .padding()
            } else {
                HStack {
                    Text("選擇日期: \(formattedDate(selectedDate))")
                        .font(.headline)
                    Spacer()
                    Button(action: { isCalendarExpanded.toggle() }) {
                        Image(systemName: "calendar")
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
    }
}
