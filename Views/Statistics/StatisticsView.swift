import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query(sort: \StudySession.startTime, order: .reverse) private var sessions: [StudySession]
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = StatisticsViewModel(sessionRepository: DefaultSessionRepository(context: modelContext))
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Summaries
                HStack(spacing: 20) {
                    SummaryCard(title: "Today", duration: viewModel.dailyTotal)
                    SummaryCard(title: "This Week", duration: viewModel.weeklyTotal)
                }
                
                // Detailed Breakdowns
                HStack(alignment: .top, spacing: 20) {
                    BreakdownCard(title: "Daily Breakdown", breakdown: viewModel.dailyBreakdown)
                    BreakdownCard(title: "Weekly Breakdown", breakdown: viewModel.weeklyBreakdown)
                }
            }
            .padding(24)
        }
        .frame(minWidth: 500, minHeight: 400)
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Statistics Dashboard")
        .onChange(of: sessions, initial: true) { _, newSessions in
            viewModel.recalculate(sessions: newSessions)
        }
    }
}

struct SummaryCard: View {
    let title: String
    let duration: TimeInterval
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(duration.formattedTimerString)
                .font(.system(size: 32, weight: .bold, design: .rounded))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)
    }
}

struct BreakdownCard: View {
    let title: String
    let breakdown: [CategoryBreakdown]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            if breakdown.isEmpty {
                Text("No data yet.")
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            } else {
                VStack(spacing: 8) {
                    ForEach(breakdown) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.duration.formattedTimerString)
                                .font(.system(.body, design: .monospaced))
                        }
                        Divider()
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, y: 1)
    }
}
