import Foundation
import SwiftData

@MainActor
public final class StorageService {
    private let context: ModelContext
    
    public init(context: ModelContext) {
        self.context = context
    }
    
    /// Saves a completed study session to the local SwiftData store.
    public func saveSession(startTime: Date, endTime: Date, duration: TimeInterval, category: StudyCategory?) {
        // Prevent saving 0-second ghost sessions
        guard duration > 0 else { return }
        
        let session = StudySession(
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            category: category
        )
        
        context.insert(session)
        
        do {
            try context.save()
        } catch {
            print("Failed to save StudySession: \(error.localizedDescription)")
        }
    }
}
