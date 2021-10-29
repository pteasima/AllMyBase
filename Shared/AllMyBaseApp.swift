import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@main
struct AllMyBaseApp: App {

  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      TimesheetView()
        .task {
          Firestore.firestore().collection("dump")
            .document("Hello")
            .setData(["value": "World!"])
        }
    }
  }
}
