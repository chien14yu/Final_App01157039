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

struct ExerciseRecordsView: View {
    @Environment(\.currentUser) private var currentUser: String
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var exerciseRecords: [ExerciseRecord] = [] // 本地緩存
    @State private var isPresentingAddSheet = false
    @State private var searchText = ""
    @State private var sortOption: SortOption = .activity // 排序方式
    @State private var isLoading = true // 加載狀態

    private let exerciseRecordTip = ExerciseRecordTip()

    enum SortOption: String, CaseIterable, Identifiable {
        case activity = "運動項目"
        case date = "日期"
        case duration = "時長"
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
                        // 顯示加載動畫
                        VStack {
                            LottieView(name: "loading_animation", loopMode: .loop)
                                .frame(width: 100, height: 100)
                            Text("載入中...")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                refreshRecords()
                                isLoading = false
                            }
                        }
                    } else if sortedRecords.isEmpty {
                        // 顯示空列表動畫
                        VStack {
                            LottieView(name: "empty_list_animation", loopMode: .loop)
                                .frame(width: 200, height: 200)
                            Text("查無資料")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    } else {
                        // 顯示列表
                        List {
                            ForEach(sortedRecords, id: \.id) { record in
                                VStack(alignment: .leading) {
                                    Text("\(record.activity)")
                                        .font(.headline)
                                    Text("時段: \(record.timeSlot) | 時長: \(record.duration, specifier: "%.1f") 分鐘")
                                    Text(record.date, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onDelete(perform: deleteRecords)
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .navigationTitle("運動記錄")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isPresentingAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                        .popoverTip(exerciseRecordTip, arrowEdge: .top)
                    }
                }
                .sheet(isPresented: $isPresentingAddSheet) {
                    AddExerciseRecordView { newRecord in
                        withAnimation {
                            var records = exerciseRecords // 使用本地緩存
                            records.append(newRecord)
                            DataManager.shared.saveRecords(records, for: currentUser, key: "exerciseRecords")
                            refreshRecords()
                        }
                    }
                }
                .onAppear {
                    isLoading = true // 開始加載動畫
                }
            }
        }
        .scrollContentBackground(.hidden)
    }

    private var sortedRecords: [ExerciseRecord] {
        let filtered = searchText.isEmpty
            ? exerciseRecords
            : exerciseRecords.filter { $0.activity.localizedCaseInsensitiveContains(searchText) }

        switch sortOption {
        case .activity:
            return filtered.sorted { $0.activity.localizedCompare($1.activity) == .orderedAscending }
        case .date:
            return filtered.sorted { $0.date > $1.date }
        case .duration:
            return filtered.sorted { $0.duration > $1.duration }
        }
    }

    private func refreshRecords() {
        exerciseRecords = DataManager.shared.getRecords(for: currentUser, key: "exerciseRecords", type: ExerciseRecord.self)
    }

    private func deleteRecords(at offsets: IndexSet) {
        withAnimation {
            offsets.map { sortedRecords[$0] }.forEach { record in
                exerciseRecords.removeAll { $0.id == record.id }
            }
            DataManager.shared.saveRecords(exerciseRecords, for: currentUser, key: "exerciseRecords")
        }
    }
}
