import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [
            TaskItem(id: "1", title: "Sample Task 1", completed: false),
            TaskItem(id: "2", title: "Sample Task 2", completed: false),
            TaskItem(id: "3", title: "Sample Task 3", completed: false)
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: loadTasks())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        let entry = SimpleEntry(date: currentDate, tasks: loadTasks())
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
    
    func loadTasks() -> [TaskItem] {
        // Load tasks from shared UserDefaults (app group)
        if let sharedDefaults = UserDefaults(suiteName: "group.com.might3.app"),
           let tasksData = sharedDefaults.data(forKey: "top_tasks"),
           let tasks = try? JSONDecoder().decode([TaskItem].self, from: tasksData) {
            return Array(tasks.prefix(3))
        }
        
        return [
            TaskItem(id: "1", title: "Add your first task", completed: false),
            TaskItem(id: "2", title: "Complete it!", completed: false),
            TaskItem(id: "3", title: "Stay focused 🎯", completed: false)
        ]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [TaskItem]
}

struct TaskItem: Codable, Identifiable {
    let id: String
    let title: String
    let completed: Bool
}

struct Might3WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Top 3 Tasks")
                    .font(.headline)
                    .bold()
            }
            .padding(.bottom, 4)
            
            ForEach(entry.tasks) { task in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.completed ? .green : .gray)
                        .font(.system(size: 16))
                    
                    Text(task.title)
                        .font(.system(size: 13))
                        .strikethrough(task.completed)
                        .foregroundColor(task.completed ? .gray : .primary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text("Powered by Beads")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }
}

@main
struct Might3Widget: Widget {
    let kind: String = "Might3Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Might3WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Top 3 Tasks")
        .description("View your top 3 priority tasks at a glance")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Might3Widget_Previews: PreviewProvider {
    static var previews: some View {
        Might3WidgetEntryView(entry: SimpleEntry(date: Date(), tasks: [
            TaskItem(id: "1", title: "Review code", completed: false),
            TaskItem(id: "2", title: "Write documentation", completed: true),
            TaskItem(id: "3", title: "Deploy to production", completed: false)
        ]))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
