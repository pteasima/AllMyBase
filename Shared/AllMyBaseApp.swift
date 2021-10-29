import SwiftUI
import Firebase

@main
struct AllMyBaseApp: App {

  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
