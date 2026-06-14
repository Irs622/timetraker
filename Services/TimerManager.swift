import Foundation
import Observation

public enum TimerState {
    case stopped
    case running
    case paused
}

@Observable
public final class TimerManager {
    public private(set) var state: TimerState = .stopped
    public private(set) var elapsedTime: TimeInterval = 0
    
    // Internal state tracking for accuracy
    private var accumulatedTime: TimeInterval = 0
    private var currentStartDate: Date?
    
    // Background task for publishing updates
    private var timerTask: Task<Void, Never>?
    
    public init() {}
    
    public func start() {
        if state == .running { return }
        
        // If we are starting fresh, ensure state is clean
        if state == .stopped {
            elapsedTime = 0
            accumulatedTime = 0
        }
        
        currentStartDate = Date()
        state = .running
        
        startTimerTask()
    }
    
    public func pause() {
        guard state == .running else { return }
        
        updateElapsedTime()
        accumulatedTime = elapsedTime
        currentStartDate = nil
        state = .paused
        
        stopTimerTask()
    }
    
    public func resume() {
        start()
    }
    
    public func stop() {
        guard state != .stopped else { return }
        
        updateElapsedTime()
        state = .stopped
        currentStartDate = nil
        stopTimerTask()
        
        // Note: elapsedTime is NOT reset here.
        // It holds the final duration so the calling layer can save it to SwiftData.
    }
    
    public func reset() {
        stopTimerTask()
        state = .stopped
        elapsedTime = 0
        accumulatedTime = 0
        currentStartDate = nil
    }
    
    @MainActor
    private func startTimerTask() {
        stopTimerTask()
        
        timerTask = Task {
            while !Task.isCancelled {
                // Update the elapsed time on the MainActor since it drives SwiftUI
                self.updateElapsedTime()
                
                // Sleep for 0.1 seconds.
                // Using Task.sleep ensures the thread isn't blocked.
                try? await Task.sleep(for: .milliseconds(100))
            }
        }
    }
    
    private func stopTimerTask() {
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func updateElapsedTime() {
        guard let start = currentStartDate else { return }
        let now = Date()
        elapsedTime = accumulatedTime + now.timeIntervalSince(start)
    }
}
