//
//  LottieView.swift
//  Final_App01157039
//
//  Created by user05 on 2024/12/22.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .playOnce // 設定成 Lottie 提供的播放模式
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let view = LottieAnimationView(name: name) // 創建動畫實例
        view.loopMode = loopMode
        view.play() // 播放動畫
        return view
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
