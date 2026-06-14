import Foundation
import SwiftData
import Observation

public struct CategoryBreakdown: Identifiable {
    public let id = UUID()
    public let name: String
    public let duration: TimeInterval
}

@Observable
@MainActor
public final class StatisticsViewModel {
    public private(set) var dailyTotal: TimeInterval = 0
    public private(set) var weeklyTotal: TimeInterval = 0
    public private(set) var dailyBreakdown: [CategoryBreakdown] = []
    public private(set) var weeklyBreakdown: [CategoryBreakdown] = []
    
    public init() {}
    
    public func recalculate(sessions: [StudySession]) {
        let calendar = Calendar.current
        let now = Date()
        
        // Compute Daily Stats
        let dailySessions = sessions.filter { calendar.isDate($0.startTime, inSameDayAs: now) }
        dailyTotal = dailySessions.reduce(0) { $0 + $1.duration }
        dailyBreakdown = aggregate(sessions: dailySessions)
        
        // Compute Weekly Stats
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        if let startOfWeek = calendar.date(from: components) {
            let weeklySessions = sessions.filter { $0.startTime >= startOfWeek }
            weeklyTotal = weeklySessions.reduce(0) { $0 + $1.duration }
            weeklyBreakdown = aggregate(sessions: weeklySessions)
        }
    }
    
    private func aggregate(sessions: [StudySession]) -> [CategoryBreakdown] {
        var dict: [String: TimeInterval] = [:]
        for session in sessions {
            let name = session.category?.name ?? "Uncategorized"
            dict[name, default: 0] += session.duration
        }
        
        return dict.map { CategoryBreakdown(name: $0.key, duration: $0.value) }
                   .sorted { $0.duration > $1.duration } // Sort descending by time spent
    }
}
