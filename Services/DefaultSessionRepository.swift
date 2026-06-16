// DefaultSessionRepository.swift
import OSLog
import Foundation
import SwiftData

/// Default implementation of `SessionRepositoryProtocol` using SwiftData.
public final class DefaultSessionRepository: SessionRepositoryProtocol {
    private let context: ModelContext
    private let logger = Logger(subsystem: "com.studytracker", category: "SessionRepository")

    public init(context: ModelContext) {
        self.context = context
    }

    public func fetchAllSessions() async throws -> [StudySession] {
        // Simple fetch of all StudySession objects from the context.
        let descriptor = FetchDescriptor<StudySession>()
        do {
            return try context.fetch(descriptor)
        } catch {
            logger.error("Failed to fetch StudySession objects: \(error.localizedDescription)")
            throw error
        }
    }
}
