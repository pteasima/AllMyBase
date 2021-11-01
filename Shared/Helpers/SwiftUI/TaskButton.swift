import SwiftUI

struct TaskButton<Label: View>: View {
  var action: () async throws -> Void
  @ViewBuilder var label: () -> Label
  
  @Environment(\.[key: \Throw.self]) private var `throw`
  @State private var task: Task<(), Error>?
  var body: some View {
    Button {
      task?.cancel()
      task = Task {
        do {
          try await action()
        } catch {
          `throw`(error)
        } 
        task = nil
      }
    } label: {
      label()
        .overlay {
          if let _ = task {
            Color.gray
              .opacity(0.5)
              .overlay(ProgressView())
          }
        }
    }
  }
}

struct TaskButton_Previews: PreviewProvider {
  static var previews: some View {
    TaskButton {
      print(try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://www.google.com")!), delegate: nil))
    } label: {
      Text("yello")
    }
  }
}
