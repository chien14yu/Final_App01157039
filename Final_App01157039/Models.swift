//
//  Models.swift
//  Final_App01157039
//
//  Created by user05 on 2024/11/29.
//

import SwiftData
import Foundation

@Model
class ExerciseRecord: Codable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var timeSlot: String
    var activity: String
    var duration: Double

    init(date: Date, timeSlot: String, activity: String, duration: Double) {
        self.id = UUID()
        self.date = date
        self.timeSlot = timeSlot
        self.activity = activity
        self.duration = duration
    }

    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        timeSlot = try container.decode(String.self, forKey: .timeSlot)
        activity = try container.decode(String.self, forKey: .activity)
        duration = try container.decode(Double.self, forKey: .duration)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(timeSlot, forKey: .timeSlot)
        try container.encode(activity, forKey: .activity)
        try container.encode(duration, forKey: .duration)
    }

    enum CodingKeys: String, CodingKey {
        case id, date, timeSlot, activity, duration
    }
}

@Model
class ToDo: Codable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var activity: String
    var targetDuration: Double
    var isCompleted: Bool

    init(date: Date, activity: String, targetDuration: Double, isCompleted: Bool = false) {
        self.id = UUID()
        self.date = date
        self.activity = activity
        self.targetDuration = targetDuration
        self.isCompleted = isCompleted
    }

    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        activity = try container.decode(String.self, forKey: .activity)
        targetDuration = try container.decode(Double.self, forKey: .targetDuration)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(activity, forKey: .activity)
        try container.encode(targetDuration, forKey: .targetDuration)
        try container.encode(isCompleted, forKey: .isCompleted)
    }

    enum CodingKeys: String, CodingKey {
        case id, date, activity, targetDuration, isCompleted
    }
}
