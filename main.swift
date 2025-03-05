
import Foundation

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
class Contact {
    let id = UUID()
    var name: String
    var mood: MoodStatus
    var lastUpdated: Date
    var phoneNumber: String?
    var email: String?
    var notes: String?
    
    init(name: String, mood: MoodStatus, lastUpdated: Date, phoneNumber: String? = nil, email: String? = nil, notes: String? = nil) {
        self.name = name
        self.mood = mood
        self.lastUpdated = lastUpdated
        self.phoneNumber = phoneNumber
        self.email = email
        self.notes = notes
    }
}

// Contact Store to manage contacts
class ContactStore {
    var contacts: [Contact]
    
    init() {
        self.contacts = [
            Contact(name: "Emma", mood: .happy, lastUpdated: Date(), phoneNumber: "555-123-4567", email: "emma@example.com"),
            Contact(name: "James", mood: .sad, lastUpdated: Date().addingTimeInterval(-3600), phoneNumber: "555-234-5678", email: "james@example.com"),
            Contact(name: "Sophia", mood: .neutral, lastUpdated: Date().addingTimeInterval(-7200), phoneNumber: "555-345-6789", email: "sophia@example.com"),
            Contact(name: "Noah", mood: .stressed, lastUpdated: Date().addingTimeInterval(-10800), phoneNumber: "555-456-7890", email: "noah@example.com")
        ]
    }
    
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

// Helper functions for UI
func printHeader(title: String) {
    print("\n===== \(title) =====")
}

func getInput(prompt: String) -> String {
    print(prompt, terminator: ": ")
    return readLine() ?? ""
}

func getOptionalInput(prompt: String) -> String? {
    let input = getInput(prompt: prompt)
    return input.isEmpty ? nil : input
}

func displayContact(_ contact: Contact) {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    let dateString = formatter.string(from: contact.lastUpdated)
    
    print("\n\(contact.name): \(contact.mood.emoji) - \(contact.mood.description)")
    print("  Last updated: \(dateString)")
    if let phone = contact.phoneNumber {
        print("  Phone: \(phone)")
    }
    if let email = contact.email {
        print("  Email: \(email)")
    }
    if let notes = contact.notes {
        print("  Notes: \(notes)")
    }
}

func selectMood() -> MoodStatus {
    while true {
        printHeader(title: "Select Mood")
        
        for (index, mood) in MoodStatus.allCases.enumerated() {
            print("\(index + 1). \(mood.emoji) \(mood.rawValue) - \(mood.description)")
        }
        
        if let choice = Int(getInput(prompt: "Enter choice (1-\(MoodStatus.allCases.count))")) {
            if choice >= 1 && choice <= MoodStatus.allCases.count {
                return MoodStatus.allCases[choice - 1]
            }
        }
        
        print("Invalid selection. Please try again.")
    }
}

// Main menu functions
func viewContacts(store: ContactStore) {
    printHeader(title: "Your Contacts")
    
    if store.contacts.isEmpty {
        print("No contacts found.")
        return
    }
    
    for (index, contact) in store.contacts.enumerated() {
        print("\n[\(index + 1)] \(contact.name): \(contact.mood.emoji)")
    }
    
    print("\nEnter a number to view details or 0 to return to main menu")
    if let choice = Int(getInput(prompt: "Choice")) {
        if choice > 0 && choice <= store.contacts.count {
            let contact = store.contacts[choice - 1]
            viewContactDetails(contact: contact, store: store, index: choice - 1)
        }
    }
}

func viewContactDetails(contact: Contact, store: ContactStore, index: Int) {
    while true {
        printHeader(title: "Contact Details")
        displayContact(contact)
        
        print("\n1. Edit contact")
        print("2. Delete contact")
        print("0. Back to contacts list")
        
        if let choice = Int(getInput(prompt: "Choice")) {
            switch choice {
            case 1:
                editContact(store: store, index: index)
                return
            case 2:
                print("Are you sure you want to delete \(contact.name)? (y/n)")
                if getInput(prompt: "").lowercased() == "y" {
                    store.deleteContact(at: index)
                    print("\(contact.name) has been deleted.")
                    return
                }
            case 0:
                return
            default:
                print("Invalid choice. Please try again.")
            }
        } else {
            print("Invalid input. Please enter a number.")
        }
    }
}

func addNewContact(store: ContactStore) {
    printHeader(title: "Add New Contact")
    
    let name = getInput(prompt: "Name")
    if name.isEmpty {
        print("Name cannot be empty. Contact not added.")
        return
    }
    
    let mood = selectMood()
    let phoneNumber = getOptionalInput(prompt: "Phone number (optional)")
    let email = getOptionalInput(prompt: "Email (optional)")
    let notes = getOptionalInput(prompt: "Notes (optional)")
    
    let newContact = Contact(
        name: name,
        mood: mood,
        lastUpdated: Date(),
        phoneNumber: phoneNumber,
        email: email,
        notes: notes
    )
    
    store.addContact(newContact)
    print("\n✅ Contact added successfully!")
}

func editContact(store: ContactStore, index: Int) {
    if index < 0 || index >= store.contacts.count {
        print("Invalid contact index")
        return
    }
    
    let contact = store.contacts[index]
    printHeader(title: "Edit Contact")
    
    print("Current name: \(contact.name)")
    let name = getInput(prompt: "New name (leave empty to keep current)")
    
    print("Current mood: \(contact.mood.emoji) \(contact.mood.rawValue)")
    print("Change mood? (y/n)")
    let changeMood = getInput(prompt: "").lowercased() == "y"
    
    print("Current phone: \(contact.phoneNumber ?? "None")")
    let phoneNumber = getOptionalInput(prompt: "New phone (leave empty to keep current)")
    
    print("Current email: \(contact.email ?? "None")")
    let email = getOptionalInput(prompt: "New email (leave empty to keep current)")
    
    print("Current notes: \(contact.notes ?? "None")")
    let notes = getOptionalInput(prompt: "New notes (leave empty to keep current)")
    
    // Update the contact with new information
    let updatedContact = Contact(
        name: name.isEmpty ? contact.name : name,
        mood: changeMood ? selectMood() : contact.mood,
        lastUpdated: Date(),
        phoneNumber: phoneNumber ?? contact.phoneNumber,
        email: email ?? contact.email,
        notes: notes ?? contact.notes
    )
    
    store.updateContact(at: index, with: updatedContact)
    print("\n✅ Contact updated successfully!")
}

func viewResourceHub() {
    printHeader(title: "Resource Hub")
    
    print("1. Crisis Hotlines")
    print("2. Articles & Guides")
    print("3. Interactive Tools")
    print("4. Support Groups")
    
    if let choice = Int(getInput(prompt: "Select a resource")) {
        switch choice {
        case 1:
            printHeader(title: "Crisis Hotlines")
            print("National Suicide Prevention Lifeline: 1-800-273-8255")
            print("Crisis Text Line: Text HOME to 741741")
            print("Veterans Crisis Line: 1-800-273-8255 (Press 1)")
        case 2:
            printHeader(title: "Articles & Guides")
            print("• Understanding Anxiety and Depression")
            print("• Coping Strategies for Stress")
            print("• Building Resilience")
            print("• Mindfulness Techniques")
        case 3:
            printHeader(title: "Interactive Tools")
            print("• Mood Tracker")
            print("• Breathing Exercises")
            print("• Guided Meditation")
            print("• Journaling Prompts")
        case 4:
            printHeader(title: "Support Groups")
            print("• Online Communities")
            print("• Local Support Groups")
            print("• Peer Counseling")
            print("• Family Support Networks")
        default:
            print("Invalid selection")
        }
        
        print("\nPress Enter to continue...")
        _ = readLine()
    }
}

// Main application
func runWellNestApp() {
    let contactStore = ContactStore()
    
    print("""
    ╔════════════════════════════════════════╗
    ║                WellNest                ║
    ║     Take care of your mental health    ║
    ╚════════════════════════════════════════╝
    """)
    
    var running = true
    while running {
        printHeader(title: "Main Menu")
        print("1. View Contacts")
        print("2. Add New Contact")
        print("3. Resource Hub")
        print("0. Exit")
        
        if let choice = Int(getInput(prompt: "Choose an option")) {
            switch choice {
            case 1:
                viewContacts(store: contactStore)
            case 2:
                addNewContact(store: contactStore)
            case 3:
                viewResourceHub()
            case 0:
                running = false
                print("Thank you for using WellNest. Goodbye!")
            default:
                print("Invalid option. Please try again.")
            }
        } else {
            print("Please enter a number.")
        }
    }
}

// Start the application
runWellNestApp()
