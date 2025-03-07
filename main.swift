import SwiftUI

// Define the MoodStatus enum (from edited code)
enum MoodStatus: String, CaseIterable, Identifiable {
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case stressed = "Stressed"
    case anxious = "Anxious"
    var id: String { self.rawValue }

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .neutral: return "😐"
        case .sad: return "😔"
        case .stressed: return "😫"
        case .anxious: return "😰"
        }
    }

    var description: String {
        switch self {
        case .happy: return "I'm doing well!"
        case .neutral: return "I'm okay."
        case .sad: return "I'm feeling down."
        case .stressed: return "I'm feeling stressed."
        case .anxious: return "I'm feeling anxious."
        }
    }
}

// Contact model (from edited code)
struct Contact: Identifiable {
    let id = UUID()
    var name: String
    var mood: MoodStatus
    var lastUpdated: Date
    var phoneNumber: String
    var email: String
}

// Contact Store to manage contacts (from edited code)
class ContactStore: ObservableObject {
    @Published var contacts: [Contact] = [
        Contact(name: "Emma", mood: .happy, lastUpdated: Date(), phoneNumber: "555-123-4567", email: "emma@example.com"),
        Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600), phoneNumber: "555-234-5678", email: "james@example.com"),
        Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200), phoneNumber: "555-345-6789", email: "sophia@example.com"),
        Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800), phoneNumber: "555-456-7890", email: "noah@example.com")
    ]

    func addContact(_ contact: Contact) {
        contacts.append(contact)
    }

    func updateContact(at index: Int, with contact: Contact) {
        if index >= 0 && index < contacts.count {
            contacts[index] = contact
        }
    }

    func deleteContact(at index: Int) {
        if index >= 0 && index < contacts.count {
            contacts.remove(at: index)
        }
    }
}

// SocialMediaStore is defined in SocialMediaSettings.swift


// Main App Structure (from edited code)
@main
struct YourSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// Main tab view for app navigation (from edited code)
struct MainTabView: View {
    @StateObject private var videoStore = VideoProcessingStore()
    @StateObject private var socialStore = SocialMediaStore()

    var body: some View {
        TabView {
            YouTubeSearchView()
                .environmentObject(videoStore)
                .tabItem {
                    Image(systemName: "play.rectangle.fill")
                    Text("Videos")
                }

            SocialMediaSettingsView()
                .environmentObject(socialStore)
                .tabItem {
                    Image(systemName: "network")
                    Text("Social")
                }

            AnalyticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(AppColors.primary)
    }
}

// A simple analytics view
struct AnalyticsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Video stats card
                AppStyles.cardStyle(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Video Performance")
                            .font(.headline)
                        
                        HStack {
                            StatItem(title: "Videos", value: "12")
                            StatItem(title: "Views", value: "1.5K")
                            StatItem(title: "Likes", value: "324")
                        }
                        
                        // Placeholder chart
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                            .overlay(
                                Text("Performance Chart")
                                    .foregroundColor(.gray)
                            )
                    }
                )
                .padding(.horizontal)
                
                // Engagement metrics
                AppStyles.cardStyle(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Engagement")
                            .font(.headline)
                        
                        HStack {
                            StatItem(title: "Comments", value: "87")
                            StatItem(title: "Shares", value: "45")
                            StatItem(title: "Saves", value: "68")
                        }
                    }
                )
                .padding(.horizontal)
                
                // Platform breakdown
                AppStyles.cardStyle(
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Platform Breakdown")
                            .font(.headline)
                        
                        HStack {
                            PlatformStat(platform: "YouTube", percentage: 45)
                            PlatformStat(platform: "Instagram", percentage: 30)
                            PlatformStat(platform: "TikTok", percentage: 25)
                        }
                    }
                )
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Analytics")
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PlatformStat: View {
    let platform: String
    let percentage: Int
    
    var body: some View {
        VStack {
            Text("\(percentage)%")
                .font(.headline)
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 30, height: 100)
                
                Rectangle()
                    .fill(AppColors.primary)
                    .frame(width: 30, height: CGFloat(percentage))
            }
            
            Text(platform)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// Simple settings view (from edited code with modifications)
struct SettingsView: View {
    @State private var enableNotifications = true
    @State private var darkModeEnabled = false
    @State private var selectedAPIModel = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }

                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $enableNotifications)

                    if enableNotifications {
                        Toggle("Processing Updates", isOn: .constant(true))
                        Toggle("Social Media Insights", isOn: .constant(true))
                    }
                }

                Section(header: Text("AI Settings")) {
                    Picker("AI Model", selection: $selectedAPIModel) {
                        Text("GPT-3.5").tag(0)
                        Text("GPT-4").tag(1)
                        Text("Claude").tag(2)
                    }

                    HStack {
                        Text("API Key")
                        Spacer()
                        Text("••••••••")
                            .foregroundColor(AppColors.textSecondary)
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Button(action: {
                        // Privacy policy action
                    }) {
                        Text("Privacy Policy")
                    }

                    Button(action: {
                        // Terms of service action
                    }) {
                        Text("Terms of Service")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct AppGraphics {
    static let homeIcon = Image(systemName: "house.fill")
    static let resourcesIcon = Image(systemName: "book.closed.fill")
    static let settingsIcon = Image(systemName: "gear")
}

struct AppColors {
    static let primary = Color.blue
    static let textSecondary = Color.gray // Added for consistency
}

print("YouTube Video Creator App Starting...")