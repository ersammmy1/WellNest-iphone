
import SwiftUI

// Dashboard View
struct DashboardView: View {
    @ObservedObject var contactStore: ContactStore
    @State private var showingAddContact = false
    @State private var showingContactDetail = false
    @State private var selectedContact: Contact?
    
    var body: some View {
        ZStack {
            AppColors.background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with logo
                HStack {
                    AppGraphics.logo
                        .font(.largeTitle)
                        .foregroundColor(AppColors.primary)
                    
                    Text("WellNest")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Brief app description
                Text("Stay connected with those you care about")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                
                // Contact listing in a ScrollView for custom styling
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(contactStore.contacts) { contact in
                            ContactRow(contact: contact)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedContact = contact
                                    showingContactDetail = true
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Floating action button for adding contacts
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddContact = true
                        }) {
                            AppGraphics.addIcon
                                .font(.system(size: 24))
                                .padding()
                                .background(AppColors.primary)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(color: AppColors.primary.opacity(0.4), radius: 5, x: 0, y: 3)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
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
        AppStyles.cardStyle(
            HStack {
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                        .foregroundColor(AppColors.text)
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.caption2)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text(timeAgo(from: contact.lastUpdated))
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                AppStyles.moodIndicator(contact.mood)
            }
            .padding()
        )
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
        ZStack {
            AppColors.background
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    // Profile header with avatar-like mood indicator
                    VStack(spacing: 16) {
                        // Decorative wave pattern at the top
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [contact.mood.color.opacity(0.7), contact.mood.color.opacity(0.3)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 100)
                            .clipShape(
                                RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 30)
                            )
                            .edgesIgnoringSafeArea(.top)
                            .overlay(
                                Text(contact.mood.emoji)
                                    .font(.system(size: 80))
                                    .shadow(color: Color.white.opacity(0.7), radius: 5, x: 0, y: 0)
                                    .offset(y: 40)
                            )
                            .padding(.bottom, 40)
                        
                        Text(contact.name)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.text)
                        
                        Text(contact.mood.description)
                            .font(.headline)
                            .foregroundColor(contact.mood.color)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(contact.mood.color.opacity(0.1))
                            .clipShape(Capsule())
                        
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text(formattedDate(contact.lastUpdated))
                                .font(.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, 4)
                    }
                    .padding(.bottom, 16)
                    
                    // Contact Information Card
                    AppStyles.cardStyle(
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Information")
                                .headerStyle()
                                .padding(.bottom, 8)
                            
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
                                        .foregroundColor(AppColors.text)
                                    
                                    Text(notes)
                                        .font(.body)
                                        .foregroundColor(AppColors.text)
                                        .padding()
                                        .background(AppColors.background)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    )
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            // Action for messaging
                        }) {
                            AppStyles.primaryButton(
                                HStack {
                                    AppGraphics.messageIcon
                                    Text("Message")
                                }
                            )
                        }
                        
                        Button(action: {
                            // Action for calling
                        }) {
                            AppStyles.secondaryButton(
                                HStack {
                                    AppGraphics.callIcon
                                    Text("Call")
                                }
                            )
                        }
                    }
                    .padding(.top, 16)
                    
                    Button(action: {
                        // Action for video call
                    }) {
                        HStack {
                            AppGraphics.videoIcon
                            Text("Video Chat")
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .background(contact.mood.color.opacity(0.2))
                        .foregroundColor(contact.mood.color)
                        .cornerRadius(10)
                    }
                    .padding(.top, 8)
                }
                .padding(.top, 60)
                .padding(.bottom, 24)
            }
        }
        .navigationBarItems(
            trailing: Button(action: {
                showingEditContact = true
            }) {
                AppGraphics.editIcon
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primary)
            }
        )
        .navigationBarTitle("", displayMode: .inline)
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

// Custom shape for curved edges
struct RoundedShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ContactInfoRow: View {
    let iconName: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon with circular background
            Image(systemName: iconName)
                .foregroundColor(AppColors.primary)
                .font(.system(size: 16))
                .frame(width: 36, height: 36)
                .background(AppColors.primary.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(AppColors.text)
            }
            
            Spacer()
            
            // Interactive button
            Button(action: {
                // Copy to clipboard or perform action
                UIPasteboard.general.string = value
            }) {
                Image(systemName: "square.on.square")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primary.opacity(0.7))
            }
        }
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
