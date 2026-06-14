import XCTest
@testable import StudyTracker

final class TimerManagerTests: XCTestCase {
    
    var timerManager: TimerManager!
    
    override func setUp() {
        super.setUp()
        timerManager = TimerManager()
    }
    
    override func tearDown() {
        timerManager.reset()
        timerManager = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(timerManager.state, .stopped)
        XCTAssertEqual(timerManager.elapsedTime, 0)
    }
    
    func testStartTimer() async throws {
        timerManager.start()
        XCTAssertEqual(timerManager.state, .running)
        
        // Wait briefly to allow background task to accumulate time
        try await Task.sleep(for: .milliseconds(150))
        XCTAssertTrue(timerManager.elapsedTime > 0.1)
    }
    
    func testPauseTimer() async throws {
        timerManager.start()
        try await Task.sleep(for: .milliseconds(150))
        
        timerManager.pause()
        XCTAssertEqual(timerManager.state, .paused)
        
        let pausedTime = timerManager.elapsedTime
        try await Task.sleep(for: .milliseconds(100))
        
        // Ensure time does not increase while paused
        XCTAssertEqual(timerManager.elapsedTime, pausedTime, accuracy: 0.01)
    }
    
    func testStopTimerDoesNotResetTime() async throws {
        timerManager.start()
        try await Task.sleep(for: .milliseconds(150))
        
        timerManager.stop()
        XCTAssertEqual(timerManager.state, .stopped)
        XCTAssertTrue(timerManager.elapsedTime > 0.1)
    }
    
    func testResetTimer() async throws {
        timerManager.start()
        try await Task.sleep(for: .milliseconds(150))
        
        timerManager.reset()
        XCTAssertEqual(timerManager.state, .stopped)
        XCTAssertEqual(timerManager.elapsedTime, 0)
    }
}
