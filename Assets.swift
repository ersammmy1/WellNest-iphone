
import SwiftUI

// App color scheme
struct AppColors {
    static let primary = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let secondary = Color(red: 0.9, green: 0.4, blue: 0.4)
    static let background = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let cardBackground = Color.white
    static let text = Color(red: 0.2, green: 0.2, blue: 0.3)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.6)
    
    // Mood colors with improved palette
    static func moodColor(_ mood: MoodStatus) -> Color {
        switch mood {
        case .happy: return Color(red: 0.1, green: 0.8, blue: 0.4)
        case .neutral: return Color(red: 0.2, green: 0.6, blue: 0.9)
        case .sad: return Color(red: 1.0, green: 0.7, blue: 0.2)
        case .stressed: return Color(red: 0.9, green: 0.3, blue: 0.3)
        case .anxious: return Color(red: 0.6, green: 0.4, blue: 0.8)
        }
    }
}

// Logo and app graphics
struct AppGraphics {
    // App logo
    static let logo = Image(systemName: "heart.text.square.fill")
    
    // Custom tab bar icons
    static let homeIcon = Image(systemName: "house.fill")
    static let resourcesIcon = Image(systemName: "book.fill")
    static let settingsIcon = Image(systemName: "gear")
    
    // Action icons
    static let addIcon = Image(systemName: "plus.circle.fill")
    static let callIcon = Image(systemName: "phone.fill")
    static let messageIcon = Image(systemName: "message.fill")
    static let videoIcon = Image(systemName: "video.fill")
    static let editIcon = Image(systemName: "pencil")
    
    // Widget elements
    static let widgetIcon = Image(systemName: "heart.text.square.fill")
}

// Reusable UI components and styling
struct AppStyles {
    // Card style for list items
    static func cardStyle<T: View>(_ content: T) -> some View {
        content
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Mood indicator bubble style
    static func moodIndicator(_ mood: MoodStatus) -> some View {
        Text(mood.emoji)
            .font(.system(size: 30))
            .padding(10)
            .background(AppColors.moodColor(mood).opacity(0.2))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(AppColors.moodColor(mood).opacity(0.4), lineWidth: 2)
            )
            .shadow(color: AppColors.moodColor(mood).opacity(0.3), radius: 3, x: 0, y: 1)
    }
    
    // Primary button style
    static func primaryButton<T: View>(_ content: T) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(AppColors.primary)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .shadow(color: AppColors.primary.opacity(0.3), radius: 3, x: 0, y: 2)
    }
    
    // Secondary button style
    static func secondaryButton<T: View>(_ content: T) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(AppColors.cardBackground)
            .foregroundColor(AppColors.primary)
            .font(.headline)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.primary, lineWidth: 1)
            )
    }
    
    // Header style
    static var headerStyle: some ViewModifier {
        ViewModifier { content in
            content
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.text)
        }
    }
    
    // Badge style for notifications
    static func badgeStyle(_ count: Int) -> some View {
        Text("\(count)")
            .font(.caption2)
            .fontWeight(.bold)
            .padding(5)
            .background(AppColors.secondary)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

// Extension to apply modifiers
extension View {
    func headerStyle() -> some View {
        self.modifier(AppStyles.headerStyle)
    }
}
