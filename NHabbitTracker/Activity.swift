//
//  Activity.swift
//  NHabbitTracker
//
//  Created by Adrino Rosario on 17/11/24.
//

import Foundation
import Observation
import SwiftUI

struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var category: String
    var description: String?
    var habit: String
    var activityDate: Date = Date.now
    var iconName: String
    var activityImages: [Data] = []
    
    func image(for index: Int) -> Image? {
        guard index < activityImages.count else { return nil }
        if let uiImage = UIImage(data: activityImages[index]) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

@Observable
class Activities {
    var activities = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "activities")
            }
        }
    }
    
    init() {
        if let savedActivities = UserDefaults.standard.data(forKey: "activities") {
            if let decodedItems = try? JSONDecoder().decode([Activity].self, from: savedActivities) {
                activities = decodedItems
                return
            }
        }
        activities = []
    }
}
