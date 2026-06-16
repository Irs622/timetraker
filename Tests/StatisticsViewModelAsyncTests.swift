// StatisticsViewModelAsyncTests.swift
import XCTest
@testable import StudyTracker

final class StatisticsViewModelAsyncTests: XCTestCase {
    var viewModel: StatisticsViewModel!
    var mockRepo: MockSessionRepository!

    override func setUp() {
        super.setUp()
        // Prepare mock sessions
        let category1 = StudyCategory(name: "Math")
        let category2 = StudyCategory(name: "Science")
        let now = Date()
        let session1 = StudySession(startTime: now, duration: 1800, category: category1)
        let session2 = StudySession(startTime: now, duration: 3600, category: category2)
        mockRepo = MockSessionRepository(sessions: [session1, session2])
        viewModel = StatisticsViewModel(sessionRepository: mockRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }

    func testRecalculateAllFetchesAndAggregates() async {
        await viewModel.recalculateAll()
        // Daily total should include both sessions (same day)
        XCTAssertEqual(viewModel.dailyTotal, 5400)
        XCTAssertEqual(viewModel.dailyBreakdown.count, 2)
        // Verify breakdown values
        let math = viewModel.dailyBreakdown.first { $0.name == "Math" }
        let science = viewModel.dailyBreakdown.first { $0.name == "Science" }
        XCTAssertEqual(math?.duration, 1800)
        XCTAssertEqual(science?.duration, 3600)
    }
}
