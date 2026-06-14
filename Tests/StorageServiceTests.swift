import XCTest
import SwiftData
@testable import StudyTracker

@MainActor
final class StorageServiceTests: XCTestCase {
    
    var modelContainer: ModelContainer!
    var storageService: StorageService!
    
    override func setUpWithError() throws {
        // Create an in-memory database for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: StudyCategory.self, StudySession.self, configurations: config)
        storageService = StorageService(context: modelContainer.mainContext)
    }
    
    override func tearDownWithError() throws {
        storageService = nil
        modelContainer = nil
    }
    
    func testSaveSessionWithValidDuration() throws {
        let category = StudyCategory(name: "Test Category")
        modelContainer.mainContext.insert(category)
        
        let start = Date().addingTimeInterval(-3600)
        let end = Date()
        
        storageService.saveSession(startTime: start, endTime: end, duration: 3600, category: category)
        
        // Verify insertion
        let descriptor = FetchDescriptor<StudySession>()
        let sessions = try modelContainer.mainContext.fetch(descriptor)
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.duration, 3600)
        XCTAssertEqual(sessions.first?.category?.name, "Test Category")
    }
    
    func testSaveSessionWithZeroDurationIsIgnored() throws {
        storageService.saveSession(startTime: Date(), endTime: Date(), duration: 0, category: nil)
        
        let descriptor = FetchDescriptor<StudySession>()
        let sessions = try modelContainer.mainContext.fetch(descriptor)
        
        XCTAssertTrue(sessions.isEmpty, "Sessions with 0 duration should not be saved.")
    }
}
