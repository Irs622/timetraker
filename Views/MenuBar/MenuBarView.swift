import SwiftUI
import SwiftData

struct MenuBarView: View {
    @Bindable var viewModel: TimerViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \StudyCategory.name) private var categories: [StudyCategory]
    
    var body: some View {
        VStack(spacing: 16) {
            // Timer Display
            Text(viewModel.timeString)
                .font(.system(size: 44, weight: .bold, design: .monospaced))
                .monospacedDigit()
                .padding(.top, 8)
            
            // Category Picker
            Picker("Category", selection: $viewModel.selectedCategory) {
                Text("Uncategorized").tag(nil as StudyCategory?)
                ForEach(categories) { category in
                    Text(category.name).tag(category as StudyCategory?)
                }
            }
            .disabled(viewModel.timerManager.state != .stopped)
            .labelsHidden() // Keeps the UI clean in the popover
            .frame(maxWidth: 150)
            
            // Controls
            HStack(spacing: 16) {
                if viewModel.timerManager.state == .stopped {
                    Button(action: { viewModel.start() }) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.green)
                } else if viewModel.timerManager.state == .running {
                    Button(action: { viewModel.pause() }) {
                        Image(systemName: "pause.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.orange)
                    
                    Button(action: { viewModel.stop() }) {
                        Image(systemName: "stop.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.red)
                } else if viewModel.timerManager.state == .paused {
                    Button(action: { viewModel.resume() }) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.green)
                    
                    Button(action: { viewModel.stop() }) {
                        Image(systemName: "stop.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.red)
                }
            }
            .padding(.bottom, 8)
            
            Divider()
            
            // App Control
            HStack {
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
                .font(.caption)
            }
        }
        .padding()
        .frame(width: 250)
        .onAppear {
            // Inject StorageService so ViewModel can save when Stop is pressed
            if viewModel.storageService == nil {
                viewModel.storageService = StorageService(context: modelContext)
            }
            
            // Default select the first category if none is selected
            if viewModel.selectedCategory == nil, let first = categories.first {
                viewModel.selectedCategory = first
            }
        }
    }
}
