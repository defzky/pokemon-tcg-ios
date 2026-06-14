import SwiftUI

struct ContentView: View {
    @AppStorage("useDarkMode") private var useDarkMode = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "person")
                }
        }
        .preferredColorScheme(useDarkMode ? .dark : nil)
    }
}
