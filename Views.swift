
import SwiftUI

// Dashboard View
struct DashboardView: View {
    @ObservedObject var contactStore: ContactStore
    @State private var showingAddContact = false
    @State private var showingContactDetail = false
    @State private var selectedContact: Contact?
    
    var body: some View {
        List {
            ForEach(contactStore.contacts) { contact in
                ContactRow(contact: contact)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedContact = contact
                        showingContactDetail = true
                    }
            }
            .onDelete { indexSet in
                contactStore.deleteContact(at: indexSet)
            }
        }
        .navigationTitle("WellNest")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddContact = true
                }) {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showingAddContact) {
            NavigationView {
                ContactEditView(contactStore: contactStore)
            }
        }
        .sheet(isPresented: $showingContactDetail) {
            if let contact = selectedContact {
                NavigationView {
                    ContactDetailView(contact: contact, contactStore: contactStore)
                }
            }
        }
    }
}

struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                Text("Last updated: \(timeAgo(from: contact.lastUpdated))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(contact.mood.emoji)
                .font(.system(size: 30))
                .padding(8)
                .background(contact.mood.color.opacity(0.2))
                .clipShape(Circle())
        }
        .padding(.vertical, 8)
    }
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct ContactDetailView: View {
    let contact: Contact
    let contactStore: ContactStore
    @State private var showingEditContact = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text(contact.mood.emoji)
                    .font(.system(size: 80))
                    .padding()
                    .background(contact.mood.color.opacity(0.2))
                    .clipShape(Circle())
                
                Text(contact.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(contact.mood.description)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Last updated: \(formattedDate(contact.lastUpdated))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                
                if let phone = contact.phoneNumber {
                    ContactInfoRow(iconName: "phone.fill", label: "Phone", value: phone)
                }
                
                if let email = contact.email {
                    ContactInfoRow(iconName: "envelope.fill", label: "Email", value: email)
                }
                
                if let notes = contact.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        
                        Text(notes)
                            .font(.body)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                
                HStack(spacing: 30) {
                    Button(action: {
                        // Action for messaging
                    }) {
                        VStack {
                            Image(systemName: "message.fill")
                                .font(.system(size: 24))
                            Text("Message")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        // Action for calling
                    }) {
                        VStack {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 24))
                            Text("Call")
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        // Action for video call
                    }) {
                        VStack {
                            Image(systemName: "video.fill")
                                .font(.system(size: 24))
                            Text("Video")
                                .font(.caption)
                        }
                    }
                }
                .padding()
                .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditContact = true
                }
            }
        }
        .sheet(isPresented: $showingEditContact) {
            NavigationView {
                ContactEditView(contactStore: contactStore, contact: contact)
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContactInfoRow: View {
    let iconName: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ContactEditView: View {
    @ObservedObject var contactStore: ContactStore
    @State private var name: String = ""
    @State private var mood: MoodStatus = .neutral
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var notes: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var contact: Contact?
    
    init(contactStore: ContactStore, contact: Contact? = nil) {
        self.contactStore = contactStore
        self.contact = contact
        
        if let contact = contact {
            _name = State(initialValue: contact.name)
            _mood = State(initialValue: contact.mood)
            _phoneNumber = State(initialValue: contact.phoneNumber ?? "")
            _email = State(initialValue: contact.email ?? "")
            _notes = State(initialValue: contact.notes ?? "")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Contact Info")) {
                TextField("Name", text: $name)
                
                HStack {
                    Text("Phone")
                    Spacer()
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Mood")) {
                Picker("Current Mood", selection: $mood) {
                    ForEach(MoodStatus.allCases) { mood in
                        HStack {
                            Text(mood.emoji)
                            Text(mood.rawValue)
                        }
                        .tag(mood)
                    }
                }
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle(contact == nil ? "Add Contact" : "Edit Contact")
        .navigationBarItems(
            leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
            trailing: Button("Save") {
                saveContact()
                presentationMode.wrappedValue.dismiss()
            }
            .disabled(name.isEmpty)
        )
    }
    
    private func saveContact() {
        if let existingContact = contact {
            let updatedContact = Contact(
                id: existingContact.id,
                name: name,
                mood: mood,
                lastUpdated: Date(),
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                email: email.isEmpty ? nil : email,
                notes: notes.isEmpty ? nil : notes
            )
            contactStore.updateContact(updatedContact)
        } else {
            let newContact = Contact(
                name: name,
                mood: mood,
                lastUpdated: Date(),
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                email: email.isEmpty ? nil : email,
                notes: notes.isEmpty ? nil : notes
            )
            contactStore.addContact(newContact)
        }
    }
}

struct ResourceHubView: View {
    struct Resource: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let icon: String
    }
    
    let resources: [Resource] = [
        Resource(
            title: "Crisis Hotlines",
            description: "Immediate access to mental health support in crisis situations",
            icon: "phone.fill"
        ),
        Resource(
            title: "Articles & Guides",
            description: "Information on mental health topics and coping strategies",
            icon: "doc.text.fill"
        ),
        Resource(
            title: "Interactive Tools",
            description: "Exercises and methods to improve mental wellbeing",
            icon: "hammer.fill"
        ),
        Resource(
            title: "Support Groups",
            description: "Connect with people experiencing similar challenges",
            icon: "person.3.fill"
        )
    ]
    
    var body: some View {
        List {
            ForEach(resources) { resource in
                NavigationLink(destination: ResourceDetailPlaceholder(title: resource.title)) {
                    HStack {
                        Image(systemName: resource.icon)
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text(resource.title)
                                .font(.headline)
                            Text(resource.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Resources")
    }
}

struct ResourceDetailPlaceholder: View {
    let title: String
    
    var body: some View {
        VStack {
            Text("Resource content for \(title) would go here")
                .padding()
            
            Text("This is a placeholder for the actual resource content")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
