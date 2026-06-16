// SessionRepositoryProtocol.swift
import Foundation
import SwiftData

/// Protocol for fetching study sessions from a data source.
public protocol SessionRepositoryProtocol {
    /// Retrieves all stored study sessions.
    func fetchAllSessions() async throws -> [StudySession]
}
