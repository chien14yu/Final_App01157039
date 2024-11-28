//
//  Item.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/28.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
