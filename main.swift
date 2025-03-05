
import Foundation

print("WellNest App")
print("This is a command-line representation of the WellNest app")

// Define the MoodStatus enum
enum MoodStatus: String, CaseIterable {
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case stressed = "Stressed"
    case anxious = "Anxious"
    
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

// Define Contact struct
struct Contact {
    let id = UUID()
    var name: String
    var mood: MoodStatus
    var lastUpdated: Date
    var phoneNumber: String?
    var email: String?
    var notes: String?
}

// Sample data
let contacts = [
    Contact(name: "Emma", mood: .happy, lastUpdated: Date(), phoneNumber: "555-123-4567", email: "emma@example.com"),
    Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600), phoneNumber: "555-234-5678", email: "james@example.com"),
    Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200), phoneNumber: "555-345-6789", email: "sophia@example.com"),
    Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800), phoneNumber: "555-456-7890", email: "noah@example.com")
]

// Print contact information
print("\n--- Your Contacts ---")
for contact in contacts {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    let dateString = formatter.string(from: contact.lastUpdated)
    
    print("\(contact.name): \(contact.mood.emoji) - \(contact.mood.description)")
    print("  Last updated: \(dateString)")
    if let phone = contact.phoneNumber {
        print("  Phone: \(phone)")
    }
    if let email = contact.email {
        print("  Email: \(email)")
    }
    print("")
}

print("WellNest command-line version complete.")
