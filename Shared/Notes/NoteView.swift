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
  @Environment(\.[key: \Throw.self]) private var `throw`
  
  @State private var note: Note = .sample
  
  var body: some View {
    NavigationView  {
      TextEditor(text: $note.content)
        .onChange(of: note) { _ in updateNote() }
        .throwingLifetimeTask(perform: observeNote)
        .navigationTitle("Note: \(note.id.rawValue)")
    }
  }
  
  private var noteDocument: DocumentReference {
    Firestore.firestore()
      .collection("notes")
      .document(note.id.rawValue)
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
  
  private func updateNote() {
    `throw`.try {
      try noteDocument.setData(from: note)
    }
  }
}

struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NoteView()
  }
}
