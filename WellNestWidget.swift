
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), contacts: sampleContacts)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), contacts: sampleContacts)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // In a real app, you would fetch real data here
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        let entry = SimpleEntry(date: currentDate, contacts: sampleContacts)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
    
    private var sampleContacts: [Contact] {
        [
            Contact(name: "Emma", mood: .happy, lastUpdated: Date()),
            Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600)),
            Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200)),
            Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800))
        ]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let contacts: [Contact]
}

struct WellNestWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            largeWidget
        default:
            smallWidget
        }
    }
    
    var smallWidget: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("WellNest")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
            }
            .padding(.bottom, 4)
            
            ForEach(entry.contacts.prefix(3)) { contact in
                HStack {
                    Text(contact.name)
                        .font(.system(size: 12))
                        .lineLimit(1)
                    Spacer()
                    Text(contact.mood.emoji)
                        .font(.system(size: 16))
                }
            }
        }
        .padding()
    }
    
    var mediumWidget: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("WellNest")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("Wellness Check")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
            
            HStack {
                ForEach(entry.contacts.prefix(4)) { contact in
                    VStack {
                        Text(contact.mood.emoji)
                            .font(.system(size: 24))
                            .padding(8)
                            .background(contact.mood.color.opacity(0.2))
                            .clipShape(Circle())
                        
                        Text(contact.name)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
    }
    
    var largeWidget: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("WellNest")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("Your Circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
            
            ForEach(entry.contacts) { contact in
                HStack {
                    Text(contact.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text(contact.mood.emoji)
                        .font(.system(size: 20))
                        .padding(6)
                        .background(contact.mood.color.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text(timeAgo(from: contact.lastUpdated))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
            }
        }
        .padding()
    }
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

@main
struct WellNestWidget: Widget {
    let kind: String = "WellNestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WellNestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WellNest")
        .description("Keep track of your loved ones' well-being at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct WellNestWidget_Previews: PreviewProvider {
    static var previews: some View {
        let sampleContacts = [
            Contact(name: "Emma", mood: .happy, lastUpdated: Date()),
            Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600)),
            Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200)),
            Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800))
        ]
        
        WellNestWidgetEntryView(entry: SimpleEntry(date: Date(), contacts: sampleContacts))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WellNestWidgetEntryView(entry: SimpleEntry(date: Date(), contacts: sampleContacts))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        WellNestWidgetEntryView(entry: SimpleEntry(date: Date(), contacts: sampleContacts))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
