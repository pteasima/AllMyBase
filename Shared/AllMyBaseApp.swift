import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@main
struct AllMyBaseApp: App {

  init() {
    FirebaseApp.configure()
//    let settings = Firestore.firestore().settings
//    settings.host = "localhost:8080"
//    //TODO: this comes from official docs, but is it needed? Can we really not use persistence with emulator?
//    settings.isPersistenceEnabled = false
//    settings.isSSLEnabled = false
//    Firestore.firestore().settings = settings
  }
  
  var body: some Scene {
    WindowGroup {
//      TimesheetView()
//      TaskButton_Previews.previews
//        ShortcutsView()
      NoteView_Previews.previews
    }
  }
}
