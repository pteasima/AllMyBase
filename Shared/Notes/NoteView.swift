import SwiftUI
import Tagged
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Note: Hashable, Codable, Identifiable {
  typealias ID = Tagged<Self, String>
  var id: ID = "the only note"
  var content: String
}
extension Note {
  static var sample: Self {
    .init(content: "hello world")
  }
}

struct NoteView: View {
  @State private var note: Note = .sample
  var body: some View {
    NavigationView  {
      EditNoteView(note: Binding {
        note
      } set: {
        if let newValue = $0 { note = newValue }
      })
        .throwingLifetimeTask(perform: observeNote)
        .navigationTitle("Note: \(note.id.rawValue)")
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  private func observeNote() async throws {
    let query = noteDocument
      .observe()
      .compactMap {
        try $0.data(as: Note.self)
      }
    for try await newValue in query {
      print(newValue)
      note = newValue
    }
  }
  
  private var noteDocument: DocumentReference {
    Firestore.firestore()
      .collection("notes")
      .document(note.id.rawValue)
  }
}

struct EditNoteView: View {
  @Environment(\.[key: \Throw.self]) private var `throw`
  
  @Binding var note: Note?
  
  var body: some View {
    if let $note = Binding($note) {
      TextEditor(
        text: $note.content
          .onSet { _ in
            updateNote()
          }
      )
    }
  }
  
  private func updateNote() {
    //    `throw`.try {
    //      try noteDocument.setData(from: note)
    //    }
  }
}

struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NoteView()
  }
}
