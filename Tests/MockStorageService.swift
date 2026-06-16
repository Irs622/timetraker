// MockStorageService.swift
import Foundation
import SwiftData

/// In‑memory mock implementation of `StorageServiceProtocol` for unit tests.
public final class MockStorageService: StorageServiceProtocol {
    public private(set) var savedSessions: [StudySession] = []

    public init() {}

    public func saveSession(startTime: Date, endTime: Date, duration: TimeInterval, category: StudyCategory?) {
        // Mimic the same guard logic as the real service.
        guard duration > 0 else { return }
        let session = StudySession(startTime: startTime, endTime: endTime, duration: duration, category: category)
        savedSessions.append(session)
    }
}
