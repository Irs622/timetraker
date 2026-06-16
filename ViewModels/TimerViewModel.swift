import Foundation
import SwiftData
import Observation

// Import the protocol for dependency injection
import StorageServiceProtocol
import Observation

@Observable
@MainActor
public final class TimerViewModel {
    public var timerManager: TimerManager
    public var selectedCategory: StudyCategory?
    
    // For saving sessions upon stop
    private let storageService: StorageServiceProtocol
    
    // Using a Date to anchor the true start time of the session
    private var trueSessionStartTime: Date?
    
    public init(timerManager: TimerManager = TimerManager(), storageService: StorageServiceProtocol) {
        self.timerManager = timerManager
        self.storageService = storageService
    }
    
    public var timeString: String {
        timerManager.elapsedTime.formattedTimerString
    }
    
    public func start() {
        if timerManager.state == .stopped {
            trueSessionStartTime = Date()
        }
        timerManager.start()
    }
    
    public func pause() {
        timerManager.pause()
    }
    
    public func resume() {
        timerManager.resume()
    }
    
    public func stop() {
        timerManager.stop()
        
        saveSession()
        
        timerManager.reset()
        trueSessionStartTime = nil
    }
    
    private func saveSession() {
        guard timerManager.elapsedTime > 0 else { return }
        guard let startTime = trueSessionStartTime else { return }
        
        storageService.saveSession(
            startTime: startTime,
            endTime: Date(),
            duration: timerManager.elapsedTime,
            category: selectedCategory
        )
    }
}
