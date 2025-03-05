
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
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(red: 0.95, green: 0.97, blue: 1.0)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 8) {
                // Widget header
                HStack {
                    // App logo
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                    
                    Text("WellNest")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.4))
                }
                .padding(.bottom, 6)
                
                // Divider with gradient
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.2, green: 0.5, blue: 0.8), Color(red: 0.9, green: 0.4, blue: 0.4)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .padding(.bottom, 8)
                
                // Contact list
                ForEach(entry.contacts.prefix(3)) { contact in
                    HStack {
                        Text(contact.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Emoji with custom background
                        Text(contact.mood.emoji)
                            .font(.system(size: 16))
                            .padding(6)
                            .background(
                                Circle()
                                    .fill(AppColors.moodColor(contact.mood).opacity(0.15))
                                    .shadow(color: AppColors.moodColor(contact.mood).opacity(0.2), radius: 2, x: 0, y: 1)
                            )
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(12)
        }
    }
    
    var mediumWidget: some View {
        ZStack {
            // Background with subtle pattern
            Color(red: 0.95, green: 0.97, blue: 1.0)
                .overlay(
                    ZStack {
                        // Decorative circles
                        Circle()
                            .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.05))
                            .frame(width: 100, height: 100)
                            .offset(x: -120, y: -50)
                        
                        Circle()
                            .fill(Color(red: 0.9, green: 0.4, blue: 0.4).opacity(0.05))
                            .frame(width: 80, height: 80)
                            .offset(x: 120, y: 50)
                    }
                )
            
            VStack(alignment: .leading, spacing: 12) {
                // Widget header
                HStack {
                    // App logo with text
                    HStack(spacing: 4) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                        
                        Text("WellNest")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    // Wellness check label
                    Text("Wellness Check")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.5))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.93, green: 0.94, blue: 0.98))
                                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        )
                }
                
                // Contact mood grid
                HStack(spacing: 12) {
                    ForEach(entry.contacts.prefix(4)) { contact in
                        VStack(spacing: 8) {
                            // Mood emoji with decorative background
                            ZStack {
                                // Outer circle
                                Circle()
                                    .fill(AppColors.moodColor(contact.mood).opacity(0.15))
                                    .frame(width: 56, height: 56)
                                
                                // Inner highlight
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                AppColors.moodColor(contact.mood).opacity(0.05),
                                                AppColors.moodColor(contact.mood).opacity(0.25)
                                            ]),
                                            center: .center,
                                            startRadius: 5,
                                            endRadius: 28
                                        )
                                    )
                                    .frame(width: 56, height: 56)
                                
                                // Emoji
                                Text(contact.mood.emoji)
                                    .font(.system(size: 28))
                                    .shadow(color: Color.white.opacity(0.5), radius: 1, x: 0, y: 0)
                            }
                            .shadow(color: AppColors.moodColor(contact.mood).opacity(0.3), radius: 3, x: 0, y: 2)
                            
                            // Name
                            Text(contact.name)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(16)
        }
    }
    
    var largeWidget: some View {
        ZStack {
            // Background with subtle wave pattern
            Color(red: 0.95, green: 0.97, blue: 1.0)
                .overlay(
                    VStack {
                        // Decorative wave at top
                        ZStack {
                            Capsule()
                                .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1))
                                .frame(width: 200, height: 80)
                                .rotationEffect(.degrees(-15))
                                .offset(x: -100, y: -20)
                            
                            Capsule()
                                .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.05))
                                .frame(width: 180, height: 60)
                                .rotationEffect(.degrees(-5))
                                .offset(x: 80, y: -40)
                        }
                        
                        Spacer()
                    }
                )
            
            VStack(alignment: .leading, spacing: 16) {
                // Widget header with decorative element
                HStack {
                    // App logo with text
                    HStack(spacing: 8) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                        
                        Text("WellNest")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    // Circle label
                    HStack(spacing: 4) {
                        Text("Your Circle")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.5))
                        
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.5))
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                }
                .padding(.bottom, 8)
                
                // Divider with gradient
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.2, green: 0.5, blue: 0.8), Color(red: 0.9, green: 0.4, blue: 0.4)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .padding(.bottom, 8)
                
                // Contact list with rich styling
                ForEach(entry.contacts) { contact in
                    HStack {
                        // Name with dot indicator
                        HStack(spacing: 8) {
                            // Status dot
                            Circle()
                                .fill(AppColors.moodColor(contact.mood))
                                .frame(width: 8, height: 8)
                            
                            Text(contact.name)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.4))
                        }
                        
                        Spacer()
                        
                        // Mood emoji with custom styling
                        Text(contact.mood.emoji)
                            .font(.system(size: 22))
                            .padding(8)
                            .background(
                                ZStack {
                                    Circle()
                                        .fill(AppColors.moodColor(contact.mood).opacity(0.15))
                                    
                                    Circle()
                                        .strokeBorder(AppColors.moodColor(contact.mood).opacity(0.3), lineWidth: 1.5)
                                }
                            )
                        
                        // Time ago with custom styling
                        Text(timeAgo(from: contact.lastUpdated))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                            )
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
        }
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
