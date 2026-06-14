import SwiftUI
import SwiftData

@main
struct StudyTrackerApp: App {
    @State private var timerViewModel = TimerViewModel()
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: StudyCategory.self, StudySession.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        MenuBarExtra {
            MenuBarView(viewModel: timerViewModel)
                .modelContainer(modelContainer)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "timer")
                if timerViewModel.timerManager.state == .running || timerViewModel.timerManager.state == .paused {
                    Text(timerViewModel.timeString)
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
