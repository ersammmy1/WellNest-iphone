
import SwiftUI

struct SocialAccount: Identifiable {
    let id = UUID()
    let platform: SocialPlatform
    var isConnected: Bool
    var username: String
    
    enum SocialPlatform: String, CaseIterable {
        case youtube = "YouTube"
        case instagram = "Instagram"
        case tiktok = "TikTok"
        case twitter = "Twitter"
        
        var iconName: String {
            switch self {
            case .youtube: return "play.rectangle.fill"
            case .instagram: return "camera.fill"
            case .tiktok: return "music.note"
            case .twitter: return "bubble.left.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .youtube: return Color.red
            case .instagram: return Color.purple
            case .tiktok: return Color.black
            case .twitter: return Color.blue
            }
        }
    }
}

class SocialMediaStore: ObservableObject {
    @Published var accounts: [SocialAccount] = [
        SocialAccount(platform: .youtube, isConnected: false, username: ""),
        SocialAccount(platform: .instagram, isConnected: false, username: ""),
        SocialAccount(platform: .tiktok, isConnected: false, username: ""),
        SocialAccount(platform: .twitter, isConnected: false, username: "")
    ]
    
    func connectAccount(platform: SocialAccount.SocialPlatform, username: String) {
        if let index = accounts.firstIndex(where: { $0.platform == platform }) {
            accounts[index].isConnected = true
            accounts[index].username = username
        }
    }
    
    func disconnectAccount(platform: SocialAccount.SocialPlatform) {
        if let index = accounts.firstIndex(where: { $0.platform == platform }) {
            accounts[index].isConnected = false
            accounts[index].username = ""
        }
    }
    
    var connectedAccountsCount: Int {
        return accounts.filter { $0.isConnected }.count
    }
}

struct SocialMediaSettingsView: View {
    @StateObject private var socialStore = SocialMediaStore()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Connected Accounts")) {
                    ForEach(socialStore.accounts) { account in
                        NavigationLink(destination: AccountDetailView(account: account, socialStore: socialStore)) {
                            HStack {
                                Image(systemName: account.platform.iconName)
                                    .foregroundColor(account.platform.color)
                                    .frame(width: 30, height: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(account.platform.rawValue)
                                        .font(.headline)
                                    
                                    if account.isConnected {
                                        Text(account.username)
                                            .font(.subheadline)
                                            .foregroundColor(AppColors.textSecondary)
                                    } else {
                                        Text("Not connected")
                                            .font(.subheadline)
                                            .foregroundColor(Color.gray)
                                    }
                                }
                                
                                Spacer()
                                
                                if account.isConnected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Section(header: Text("Posting Settings")) {
                    Toggle("Auto-post to all platforms", value: .constant(false))
                    
                    HStack {
                        Text("Default caption template")
                        Spacer()
                        Text("Edit")
                            .foregroundColor(AppColors.primary)
                    }
                    
                    HStack {
                        Text("Default hashtags")
                        Spacer()
                        Text("Edit")
                            .foregroundColor(AppColors.primary)
                    }
                }
                
                Section(header: Text("AI Response Settings")) {
                    Picker("Response Style", selection: .constant(0)) {
                        Text("Analytical").tag(0)
                        Text("Humorous").tag(1)
                        Text("Critical").tag(2)
                        Text("Supportive").tag(3)
                    }
                    
                    HStack {
                        Text("Response Length")
                        Spacer()
                        Text("30 seconds")
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Toggle("Generate subtitles", value: .constant(true))
                }
            }
            .navigationTitle("Social Accounts")
        }
    }
}

struct AccountDetailView: View {
    let account: SocialAccount
    let socialStore: SocialMediaStore
    
    @State private var username: String = ""
    @State private var isConnected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(account: SocialAccount, socialStore: SocialMediaStore) {
        self.account = account
        self.socialStore = socialStore
        self._username = State(initialValue: account.username)
        self._isConnected = State(initialValue: account.isConnected)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Account Details")) {
                HStack {
                    Image(systemName: account.platform.iconName)
                        .foregroundColor(account.platform.color)
                        .font(.system(size: 24))
                    
                    Text(account.platform.rawValue)
                        .font(.headline)
                }
                .padding(.vertical, 8)
                
                if isConnected {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(username)
                            .foregroundColor(AppColors.textSecondary)
                    }
                } else {
                    TextField("Username", text: $username)
                }
            }
            
            Section {
                if isConnected {
                    Button(action: disconnectAccount) {
                        Text("Disconnect Account")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    Button(action: connectAccount) {
                        Text("Connect Account")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(username.isEmpty ? Color.gray : AppColors.primary)
                            .cornerRadius(10)
                    }
                    .disabled(username.isEmpty)
                }
            }
            
            if isConnected {
                Section(header: Text("Publishing Settings")) {
                    Toggle("Automatically post", value: .constant(true))
                    
                    Picker("Privacy", selection: .constant(0)) {
                        Text("Public").tag(0)
                        Text("Friends only").tag(1)
                        Text("Private").tag(2)
                    }
                }
            }
        }
        .navigationTitle(account.platform.rawValue)
        .onAppear {
            username = account.username
            isConnected = account.isConnected
        }
    }
    
    private func connectAccount() {
        socialStore.connectAccount(platform: account.platform, username: username)
        isConnected = true
        presentationMode.wrappedValue.dismiss()
    }
    
    private func disconnectAccount() {
        socialStore.disconnectAccount(platform: account.platform)
        isConnected = false
        username = ""
        presentationMode.wrappedValue.dismiss()
    }
}
