import XCTest
@testable import StudyTracker

@MainActor
final class StatisticsViewModelTests: XCTestCase {
    
    var viewModel: StatisticsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = StatisticsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testRecalculateEmptySessions() {
        viewModel.recalculate(sessions: [])
        XCTAssertEqual(viewModel.dailyTotal, 0)
        XCTAssertEqual(viewModel.weeklyTotal, 0)
        XCTAssertTrue(viewModel.dailyBreakdown.isEmpty)
    }
    
    func testRecalculateCalculatesCorrectly() {
        let category1 = StudyCategory(name: "Math")
        let category2 = StudyCategory(name: "Science")
        
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        
        let s1 = StudySession(startTime: now, duration: 1800, category: category1)
        let s2 = StudySession(startTime: now, duration: 3600, category: category2)
        let s3 = StudySession(startTime: yesterday, duration: 7200, category: category1)
        
        viewModel.recalculate(sessions: [s1, s2, s3])
        
        // Daily total should only include `now` sessions
        XCTAssertEqual(viewModel.dailyTotal, 5400)
        
        // Daily breakdown logic check
        XCTAssertEqual(viewModel.dailyBreakdown.count, 2)
        XCTAssertEqual(viewModel.dailyBreakdown.first(where: { $0.name == "Science" })?.duration, 3600)
        
        // Weekly total should include yesterday depending on week boundary, but safely tested by checking presence
        XCTAssertTrue(viewModel.weeklyTotal >= 5400) 
    }
}
