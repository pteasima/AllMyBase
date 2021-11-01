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
//      TimesheetView()
      TaskButton_Previews.previews
    }
  }
}
