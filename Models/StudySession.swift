import Foundation
import SwiftData

@Model
final class StudySession {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval
    
    var category: StudyCategory?
    
    init(id: UUID = UUID(), startTime: Date = .now, endTime: Date? = nil, duration: TimeInterval = 0, category: StudyCategory? = nil) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.category = category
    }
}
