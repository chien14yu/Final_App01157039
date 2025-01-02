//  ContentView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/28.

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExerciseRecordsView()
                .tabItem {
                    Label("運動記錄", systemImage: "figure.run")
                }

            ToDoListView()
                .tabItem {
                    Label("ToDo 清單", systemImage: "checklist")
                }

            AnalysisView()
                .tabItem {
                    Label("分析", systemImage: "chart.bar.doc.horizontal")
                }
        }
        .accentColor(.blue) // 設定 Tab 選擇器的顏色
    }
}

#Preview {
    ContentView().modelContainer(for: [ExerciseRecord.self, ToDo.self])
}
