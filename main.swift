
import SwiftUI

@main
struct WellNestApp: App {
    @StateObject private var contactStore = ContactStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(contactStore: contactStore)
        }
    }
}

struct ContentView: View {
    @ObservedObject var contactStore: ContactStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DashboardView(contactStore: contactStore)
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationView {
                ResourceHubView()
            }
            .tabItem {
                Label("Resources", systemImage: "book.fill")
            }
            .tag(1)
            
            NavigationView {
                Text("Settings")
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(contactStore: ContactStore())
    }
}
