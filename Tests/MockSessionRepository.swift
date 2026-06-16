// MockSessionRepository.swift
import Foundation
import SwiftData

/// Simple in‑memory mock for `SessionRepositoryProtocol` used in unit tests.
public final class MockSessionRepository: SessionRepositoryProtocol {
    public var sessions: [StudySession] = []

    public init(sessions: [StudySession] = []) {
        self.sessions = sessions
    }

    public func fetchAllSessions() async throws -> [StudySession] {
        return sessions
    }
}
