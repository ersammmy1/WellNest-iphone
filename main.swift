// Command-line version of the WellNest app

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

// Simple UUID implementation for command line
struct UUID {
    let uuidString: String

    init() {
        self.uuidString = "\(Int.random(in: 1000...9999))-\(Int.random(in: 1000...9999))"
    }
}

// Contact model
struct Contact {
    let id: UUID
    var name: String
    var mood: MoodStatus
    var lastUpdated: Date
    var phoneNumber: String?
    var email: String?

    init(id: UUID = UUID(), name: String, mood: MoodStatus, lastUpdated: Date = Date(), phoneNumber: String? = nil, email: String? = nil) {
        self.id = id
        self.name = name
        self.mood = mood
        self.lastUpdated = lastUpdated
        self.phoneNumber = phoneNumber
        self.email = email
    }

    func display() {
        print("Name: \(name)")
        print("Mood: \(mood.emoji) \(mood.rawValue) - \(mood.description)")
        print("Last Updated: \(formatDate(lastUpdated))")
        if let phone = phoneNumber {
            print("Phone: \(phone)")
        }
        if let email = email {
            print("Email: \(email)")
        }
        print("--------------------------")
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Contact store
class ContactStore {
    var contacts: [Contact] = [
        Contact(name: "Emma", mood: .happy, phoneNumber: "555-123-4567", email: "emma@example.com"),
        Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600), phoneNumber: "555-234-5678", email: "james@example.com"),
        Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200), phoneNumber: "555-345-6789", email: "sophia@example.com"),
        Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800), phoneNumber: "555-456-7890", email: "noah@example.com")
    ]

    func addContact(_ contact: Contact) {
        contacts.append(contact)
        print("✅ Contact added successfully!")
    }

    func updateContact(_ updatedContact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id.uuidString == updatedContact.id.uuidString }) {
            contacts[index] = updatedContact
            print("✅ Contact updated successfully!")
        } else {
            print("❌ Contact not found!")
        }
    }

    func deleteContact(at index: Int) {
        if index >= 0 && index < contacts.count {
            let contact = contacts[index]
            contacts.remove(at: index)
            print("✅ Contact '\(contact.name)' deleted successfully!")
        } else {
            print("❌ Invalid contact index!")
        }
    }

    func displayAllContacts() {
        print("\n📱 WELLNEST CONTACTS 📱")
        print("==========================")

        if contacts.isEmpty {
            print("No contacts found.")
        } else {
            for (index, contact) in contacts.enumerated() {
                print("[\(index + 1)] \(contact.name) \(contact.mood.emoji)")
            }
        }
        print("==========================\n")
    }
}

// Main menu
func displayMainMenu() {
    print("\n🏠 WELLNEST APP - MAIN MENU 🏠")
    print("1. View All Contacts")
    print("2. View Contact Details")
    print("3. Add New Contact")
    print("4. Update Contact")
    print("5. Delete Contact")
    print("6. Exit")
    print("Enter your choice (1-6): ", terminator: "")
}

// Command line interface
func runCLI() {
    let contactStore = ContactStore()
    var running = true

    print("🚀 Welcome to WellNest CLI!")
    print("Stay connected with those you care about")

    while running {
        displayMainMenu()

        if let input = readLine(), let choice = Int(input) {
            switch choice {
            case 1:
                contactStore.displayAllContacts()

            case 2:
                contactStore.displayAllContacts()
                print("Enter contact number to view details: ", terminator: "")
                if let input = readLine(), let index = Int(input), index > 0, index <= contactStore.contacts.count {
                    print("\n📋 CONTACT DETAILS 📋")
                    print("--------------------------")
                    contactStore.contacts[index - 1].display()
                } else {
                    print("❌ Invalid contact number!")
                }

            case 3:
                print("\n➕ ADD NEW CONTACT ➕")
                print("Enter name: ", terminator: "")
                guard let name = readLine(), !name.isEmpty else {
                    print("❌ Name cannot be empty!")
                    continue
                }

                print("Enter phone number: ", terminator: "")
                let phone = readLine()

                print("Enter email: ", terminator: "")
                let email = readLine()

                print("Select mood:")
                for (index, mood) in MoodStatus.allCases.enumerated() {
                    print("\(index + 1). \(mood.emoji) \(mood.rawValue)")
                }
                print("Enter mood number (1-\(MoodStatus.allCases.count)): ", terminator: "")

                if let input = readLine(), let moodIndex = Int(input), 
                   moodIndex > 0, moodIndex <= MoodStatus.allCases.count {
                    let selectedMood = MoodStatus.allCases[moodIndex - 1]
                    let newContact = Contact(
                        name: name, 
                        mood: selectedMood,
                        phoneNumber: phone?.isEmpty ?? true ? nil : phone,
                        email: email?.isEmpty ?? true ? nil : email
                    )
                    contactStore.addContact(newContact)
                } else {
                    print("❌ Invalid mood selection!")
                }

            case 4:
                contactStore.displayAllContacts()
                print("Enter contact number to update: ", terminator: "")

                if let input = readLine(), let index = Int(input), index > 0, index <= contactStore.contacts.count {
                    let contact = contactStore.contacts[index - 1]

                    print("\n✏️ UPDATE CONTACT ✏️")
                    print("Enter new name (current: \(contact.name)): ", terminator: "")
                    let name = readLine() ?? contact.name

                    print("Enter new phone number (current: \(contact.phoneNumber ?? "None")): ", terminator: "")
                    let phone = readLine()

                    print("Enter new email (current: \(contact.email ?? "None")): ", terminator: "")
                    let email = readLine()

                    print("Select new mood (current: \(contact.mood.rawValue)):")
                    for (index, mood) in MoodStatus.allCases.enumerated() {
                        print("\(index + 1). \(mood.emoji) \(mood.rawValue)")
                    }
                    print("Enter mood number (1-\(MoodStatus.allCases.count)): ", terminator: "")

                    var selectedMood = contact.mood
                    if let input = readLine(), let moodIndex = Int(input), 
                       moodIndex > 0, moodIndex <= MoodStatus.allCases.count {
                        selectedMood = MoodStatus.allCases[moodIndex - 1]
                    }

                    let updatedContact = Contact(
                        id: contact.id,
                        name: name.isEmpty ? contact.name : name,
                        mood: selectedMood,
                        lastUpdated: Date(),
                        phoneNumber: phone?.isEmpty ?? true ? contact.phoneNumber : phone,
                        email: email?.isEmpty ?? true ? contact.email : email
                    )

                    contactStore.updateContact(updatedContact)
                } else {
                    print("❌ Invalid contact number!")
                }

            case 5:
                contactStore.displayAllContacts()
                print("Enter contact number to delete: ", terminator: "")

                if let input = readLine(), let index = Int(input), index > 0, index <= contactStore.contacts.count {
                    contactStore.deleteContact(at: index - 1)
                } else {
                    print("❌ Invalid contact number!")
                }

            case 6:
                print("👋 Thank you for using WellNest CLI!")
                running = false

            default:
                print("❌ Invalid choice. Please enter a number between 1 and 6.")
            }
        } else {
            print("❌ Invalid input. Please enter a number.")
        }

        if running {
            print("\nPress Enter to continue...", terminator: "")
            _ = readLine()
        }
    }
}

// Run the CLI app
print("🌟 WellNest - Stay connected with those you care about 🌟")
runCLI()