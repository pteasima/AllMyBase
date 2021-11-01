import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Service

struct AddWorkItem: EnvironmentKey {
  static var defaultValue: (WorkItem) async throws -> Void = { workItem in
    try Firestore.firestore()
      .collection("workItems")
      .document()
      .setData(from: workItem)
    
  }
}

struct ObserveWorkItems: EnvironmentKey {
  static var defaultValue: () -> AsyncThrowingStream<[WorkItem], Error> = {
    Firestore.firestore()
      .collection("workItems")
      .observe()
      .map { snapshot in
        try snapshot.documents.compactMap { document in
          try document.data(as: WorkItem.self)
        }
      }
      .eraseToStream()

  }
}


//TODO: use document ids properly
struct TimesheetView: View {
  @Environment(\.[key:\Throw.self]) private var `throw`
  @Environment(\.[key:\AddWorkItem.self]) private var addWorkItem
  @Environment(\.[key:\ObserveWorkItems.self]) private var observeWorkItems
  @State private var workItems: [WorkItem] = []
  var body: some View {
    NavigationView {
      List {
        ForEach($workItems) { $workItem in
          Text(String(describing: $workItem))
        }
      }
      .toolbar {
        TaskButton {
          try await addWorkItem(.samples.0)
        } label: {
          Text("+")
        }
      }
      .throwingTask {
        for try await items in observeWorkItems() {
          workItems = items
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TimesheetView()
  }
}
