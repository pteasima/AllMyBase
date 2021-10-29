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

struct TimesheetView: View {
  @Environment(\.[key:\AddWorkItem.self]) private var addWorkItem
  @State private var workItems: [WorkItem] = []
  var body: some View {
    NavigationView {
      List {
        ForEach($workItems) { $workItem in
          Text(String(describing: $workItem))
        }
      }
      .toolbar {
        Button {
          Task {
           try! await addWorkItem(.samples.0)
          }
        } label: {
          Text("+")
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
