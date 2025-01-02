//
//  ToDoListView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/29.
//

import SwiftUI
import SwiftData
import Lottie
import TipKit

struct ToDoListView: View {
    @Environment(\.currentUser) private var currentUser
    @State private var todos: [ToDo] = [] // 本地緩存
    @State private var isPresentingAddSheet = false
    @State private var searchText = ""
    @State private var sortOption: SortOption = .activity // 排序方式
    @State private var isLoading = true // 加載狀態

    private let toDoTip = ToDoTip()

    enum SortOption: String, CaseIterable, Identifiable {
        case activity = "運動項目"
        case date = "日期"
        case targetDuration = "目標時長"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // 背景視圖
                Image("background_image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    // 排序選擇器
                    Picker("排序方式", selection: $sortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    if isLoading {
                        // 載入動畫
                        LottieView(name: "loading_animation", loopMode: .loop)
                            .frame(width: 150, height: 150)
                    } else if searchText.isEmpty == false && sortedTodos.isEmpty {
                        // 搜尋結果為空時顯示動畫
                        VStack {
                            LottieView(name: "empty_list_animation", loopMode: .loop)
                                .frame(width: 200, height: 200)
                            Text("查無資料")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    } else if todos.isEmpty {
                        // 空列表訊息
                        VStack {
                            Text("目前沒有待辦事項")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    } else {
                        // 列表顯示
                        List {
                            ForEach(sortedTodos, id: \.id) { todo in
                                VStack(alignment: .leading) {
                                    Text("\(todo.activity)")
                                        .font(.headline)
                                    Text("目標時段: \(formattedTimeSlot(todo.date)) | 目標時長: \(todo.targetDuration, specifier: "%.1f") 分鐘")
                                    Text(todo.date, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onDelete(perform: deleteTodos)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .navigationTitle("ToDo 清單")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isPresentingAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                        .popoverTip(toDoTip, arrowEdge: .top)
                    }
                }
                .sheet(isPresented: $isPresentingAddSheet) {
                    AddToDoView()
                        .onDisappear {
                            refreshTodos() // 刷新目標清單
                        }
                }
                .onAppear {
                    isLoading = true // 顯示加載動畫
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        refreshTodos()
                        isLoading = false // 加載完成
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }

    private var sortedTodos: [ToDo] {
        let filtered = searchText.isEmpty
        ? todos
        : todos.filter { $0.activity.localizedCaseInsensitiveContains(searchText) }

        switch sortOption {
        case .activity:
            return filtered.sorted { $0.activity.localizedCompare($1.activity) == .orderedAscending }
        case .date:
            return filtered.sorted { $0.date > $1.date }
        case .targetDuration:
            return filtered.sorted { $0.targetDuration > $1.targetDuration }
        }
    }

    private func refreshTodos() {
        todos = DataManager.shared.getRecords(for: currentUser, key: "todos", type: ToDo.self)
    }

    private func formattedTimeSlot(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a" // 上午/下午格式
        return formatter.string(from: date)
    }

    private func deleteTodos(at offsets: IndexSet) {
        withAnimation {
            offsets.map { sortedTodos[$0] }.forEach { todo in
                todos.removeAll { $0.id == todo.id }
            }
            DataManager.shared.saveRecords(todos, for: currentUser, key: "todos")
        }
    }
}
