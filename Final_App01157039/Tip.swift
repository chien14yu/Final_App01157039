//
//  Tip.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/31.
//


import SwiftUI
import TipKit

struct SearchTip: Tip {
    var title: Text {
        Text("記帳紀錄")
    }
    
    var message: Text? {
        Text("使用搜尋功能快速尋找您的財務記錄。")
    }
    
    var image: Image? {
        Image(systemName: "magnifyingglass")
    }
}

struct ExerciseRecordTip: Tip {
    var title: Text {
        Text("新增運動記錄")
    }
    
    var message: Text? {
        Text("點擊 '+' 按鈕，快速記錄您的每日運動。")
    }
    
    var image: Image? {
        Image(systemName: "figure.run")
    }
}

struct ToDoTip: Tip {
    var title: Text {
        Text("管理目標清單")
    }
    
    var message: Text? {
        Text("使用 ToDo 清單，制定每日運動目標並追蹤完成進度。")
    }
    
    var image: Image? {
        Image(systemName: "checklist")
    }
}

struct AnalysisTip: Tip {
    var title: Text {
        Text("查看目標達成率")
    }
    
    var message: Text? {
        Text("分析頁面為您提供運動目標與完成記錄的詳細數據對比。")
    }
    
    var image: Image? {
        Image(systemName: "chart.bar.doc.horizontal")
    }
}

struct NotificationTip: Tip {
    var title: Text {
        Text("設置提醒")
    }
    
    var message: Text? {
        Text("啟用推送通知，隨時提醒您完成運動目標。")
    }
    
    var image: Image? {
        Image(systemName: "bell")
    }
}
