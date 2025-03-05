import SwiftUI

struct WellNestApp: App {
    @StateObject private var contactStore = ContactStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    DashboardView(contactStore: contactStore)
                }
                .tabItem {
                    AppGraphics.homeIcon
                    Text("Home")
                }

                NavigationView {
                    ResourceHubView()
                }
                .tabItem {
                    AppGraphics.resourcesIcon
                    Text("Resources")
                }

                NavigationView {
                    SettingsView()
                }
                .tabItem {
                    AppGraphics.settingsIcon
                    Text("Settings")
                }
            }
            .accentColor(AppColors.primary)
        }
    }
}

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var privacyLevel = 1

    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                Toggle("Dark Mode", isOn: $darkModeEnabled)

                Picker("Privacy Level", selection: $privacyLevel) {
                    Text("Public").tag(0)
                    Text("Friends Only").tag(1)
                    Text("Private").tag(2)
                }
            }

            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }

                NavigationLink(destination: Text("Privacy Policy Content")) {
                    Text("Privacy Policy")
                }

                NavigationLink(destination: Text("Terms of Service Content")) {
                    Text("Terms of Service")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct DashboardView: View {
    @ObservedObject var contactStore: ContactStore
    @State private var isAddingNewContact = false

    var body: some View {
        NavigationView {
            List {
                ForEach(contactStore.contacts) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact, contactStore: contactStore)) {
                        Text(contact.name)
                    }
                }
                .onDelete(perform: deleteContacts)
            }
            .navigationTitle("WellNest")
            .toolbar {
                Button(action: {
                    isAddingNewContact = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isAddingNewContact) {
                AddContactView(isPresented: $isAddingNewContact, contactStore: contactStore)
            }
        }
    }
    func deleteContacts(at offsets: IndexSet) {
        offsets.map { contactStore.contacts[$0] }.forEach { contact in
            if let index = contactStore.contacts.firstIndex(where: { $0.id == contact.id }) {
                contactStore.deleteContact(at: index)
            }
        }
    }
}

struct ResourceHubView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Crisis Hotlines")) {
                    Text("National Suicide Prevention Lifeline: 1-800-273-8255")
                    Text("Crisis Text Line: Text HOME to 741741")
                    Text("Veterans Crisis Line: 1-800-273-8255 (Press 1)")
                }
                Section(header: Text("Articles & Guides")) {
                    Text("• Understanding Anxiety and Depression")
                    Text("• Coping Strategies for Stress")
                    Text("• Building Resilience")
                    Text("• Mindfulness Techniques")
                }
                Section(header: Text("Interactive Tools")) {
                    Text("• Mood Tracker")
                    Text("• Breathing Exercises")
                    Text("• Guided Meditation")
                    Text("• Journaling Prompts")
                }
                Section(header: Text("Support Groups")) {
                    Text("• Online Communities")
                    Text("• Local Support Groups")
                    Text("• Peer Counseling")
                    Text("• Family Support Networks")
                }
            }
            .navigationTitle("Resource Hub")
        }
    }
}


struct ContactDetailView: View {
    @ObservedObject var contact: Contact
    @ObservedObject var contactStore: ContactStore
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Contact Information")) {
                Text("Name: \(contact.name)")
                Text("Mood: \(contact.mood.emoji) \(contact.mood.rawValue)")
                Text("Last Updated: \(contact.lastUpdated, formatter: itemFormatter)")
                if let phoneNumber = contact.phoneNumber {
                    Text("Phone: \(phoneNumber)")
                }
                if let email = contact.email {
                    Text("Email: \(email)")
                }
                if let notes = contact.notes {
                    Text("Notes: \(notes)")
                }
            }
        }
        .navigationTitle(contact.name)
    }
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct AddContactView: View {
    @Binding var isPresented: Bool
    @ObservedObject var contactStore: ContactStore
    @State private var name: String = ""
    @State private var selectedMood: MoodStatus = .happy
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Mood", selection: $selectedMood) {
                    ForEach(MoodStatus.allCases, id: \.self) { mood in
                        Text(mood.rawValue).tag(mood)
                    }
                }
                TextField("Phone Number", text: $phoneNumber)
                TextField("Email", text: $email)
                TextEditor(text: $notes)
            }
            .navigationTitle("Add Contact")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newContact = Contact(name: name, mood: selectedMood, lastUpdated: Date(), phoneNumber: phoneNumber, email: email, notes: notes)
                        contactStore.addContact(newContact)
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}



// Define the MoodStatus enum
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

// Define Contact struct
class Contact: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var mood: MoodStatus
    @Published var lastUpdated: Date
    @Published var phoneNumber: String?
    @Published var email: String?
    @Published var notes: String?

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

struct AppGraphics {
    static let homeIcon = Image(systemName: "house.fill")
    static let resourcesIcon = Image(systemName: "book.closed.fill")
    static let settingsIcon = Image(systemName: "gear")
}

struct AppColors {
    static let primary = Color.blue
}


@main
struct WellNestAppWrapper {
    static func main() {
        if CommandLine.arguments.contains("--preview") {
            // Generate HTML preview
            let previewGenerator = PreviewGenerator()
            previewGenerator.generatePreview()
        } else {
            // Run the actual app
            WellNestApp.main()
        }
    }
}

class PreviewGenerator {
    func generatePreview() {
        // This function generates the HTML preview
        // Implementation already exists in preview.swift
    }
}