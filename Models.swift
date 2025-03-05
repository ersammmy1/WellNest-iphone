
import SwiftUI

// Models for WellNest App
enum MoodStatus: String, CaseIterable, Identifiable, Codable {
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
    
    var color: Color {
        switch self {
        case .happy: return .green
        case .neutral: return .blue
        case .sad: return .orange
        case .stressed: return .red
        case .anxious: return .purple
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

struct Contact: Identifiable, Codable {
    let id: UUID
    var name: String
    var mood: MoodStatus
    var lastUpdated: Date
    var phoneNumber: String?
    var email: String?
    var notes: String?
    
    init(id: UUID = UUID(), name: String, mood: MoodStatus, lastUpdated: Date, phoneNumber: String? = nil, email: String? = nil, notes: String? = nil) {
        self.id = id
        self.name = name
        self.mood = mood
        self.lastUpdated = lastUpdated
        self.phoneNumber = phoneNumber
        self.email = email
        self.notes = notes
    }
}

// Data management
class ContactStore: ObservableObject {
    @Published var contacts: [Contact] = []
    
    init() {
        loadContacts()
    }
    
    func loadContacts() {
        // In a real app, load from UserDefaults, CoreData, or a backend service
        // For now, use sample data
        contacts = [
            Contact(name: "Emma", mood: .happy, lastUpdated: Date(), phoneNumber: "555-123-4567", email: "emma@example.com"),
            Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600), phoneNumber: "555-234-5678", email: "james@example.com"),
            Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200), phoneNumber: "555-345-6789", email: "sophia@example.com"),
            Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800), phoneNumber: "555-456-7890", email: "noah@example.com")
        ]
    }
    
    func saveContacts() {
        // In a real app, save to UserDefaults, CoreData, or a backend service
    }
    
    func addContact(_ contact: Contact) {
        contacts.append(contact)
        saveContacts()
    }
    
    func updateContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index] = contact
            saveContacts()
        }
    }
    
    func deleteContact(at indexSet: IndexSet) {
        contacts.remove(atOffsets: indexSet)
        saveContacts()
    }
}
