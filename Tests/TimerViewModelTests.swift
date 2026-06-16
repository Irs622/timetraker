// TimerViewModelTests.swift
import XCTest
@testable import StudyTracker

final class TimerViewModelTests: XCTestCase {
    var viewModel: TimerViewModel!
    var mockStorage: MockStorageService!
    var mockTimerManager: TimerManager!

    override func setUp() {
        super.setUp()
        mockStorage = MockStorageService()
        // Use a real TimerManager but we will control its state directly.
        mockTimerManager = TimerManager()
        viewModel = TimerViewModel(timerManager: mockTimerManager, storageService: mockStorage)
    }

    override func tearDown() {
        viewModel = nil
        mockStorage = nil
        mockTimerManager = nil
        super.tearDown()
    }

    func testStartSetsStartTime() {
        XCTAssertNil(viewModel.timerManager.startTime) // assuming TimerManager exposes startTime for testability
        viewModel.start()
        XCTAssertNotNil(viewModel.timerManager.startTime)
    }

    func testPauseDoesNotSaveSession() {
        viewModel.start()
        viewModel.pause()
        XCTAssertTrue(mockStorage.savedSessions.isEmpty)
    }

    func testStopSavesSession() {
        // Simulate a short session
        viewModel.start()
        // Fast‑forward elapsed time manually for deterministic test
        viewModel.timerManager.elapsedTime = 5
        viewModel.stop()

        XCTAssertEqual(mockStorage.savedSessions.count, 1)
        let saved = mockStorage.savedSessions.first!
        XCTAssertEqual(saved.duration, 5)
        XCTAssertNotNil(saved.startTime)
        XCTAssertNotNil(saved.endTime)
    }
}
