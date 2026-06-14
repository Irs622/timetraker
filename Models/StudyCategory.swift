import Foundation
import SwiftData

@Model
final class StudyCategory {
    var id: UUID
    @Attribute(.unique) var name: String
    var colorHex: String
    
    @Relationship(deleteRule: .nullify, inverse: \StudySession.category)
    var sessions: [StudySession]?
    
    init(id: UUID = UUID(), name: String, colorHex: String = "#000000") {
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }
}
