import Foundation
import SwiftData
import OSLog

@MainActor
public final class StorageService: StorageServiceProtocol {
    private let context: ModelContext
    private let logger = Logger(subsystem: "com.studytracker", category: "StorageService")

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
            logger.error("Failed to save StudySession: \(error.localizedDescription)")
        }
    }
}
