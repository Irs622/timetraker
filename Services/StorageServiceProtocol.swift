// StorageServiceProtocol.swift
import Foundation
import SwiftData

/// Protocol defining the contract for persisting study sessions.
public protocol StorageServiceProtocol {
    /// Saves a completed study session.
    /// - Parameters:
    ///   - startTime: The start time of the session.
    ///   - endTime: The end time of the session.
    ///   - duration: Length of the session in seconds.
    ///   - category: Optional category associated with the session.
    func saveSession(startTime: Date, endTime: Date, duration: TimeInterval, category: StudyCategory?)
}
