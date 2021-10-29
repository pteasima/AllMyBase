import SwiftUI

struct Throw: EnvironmentKey {
  static var defaultValue: Self = .init()
  
  @MainActor var handleError: (Error) -> Void = { error in
    print("Unhandled user-facing error: \(error.localizedDescription) , \(error)")
#if DEBUG
    raise(SIGINT) // trigger a breakpoint
#endif
  }
  
  @MainActor func callAsFunction(_ error: Error) {
    handleError(error)
  }
  
  @MainActor func `try`(_ work: () throws -> Void) {
    do {
      try work()
    } catch {
      handleError(error)
    }
  }
  
  @MainActor func `try`(_ work: @escaping () async throws -> Void) async {
    do {
      try await work()
    } catch {
      handleError(error)
    }
  }
  
  @discardableResult
  @MainActor func `try`(_ work: @escaping () async throws -> Void) -> Task<(), Never> {
    Task {
      await `try`(work)
    }
  }
}

fileprivate struct ShowErrors: ViewModifier {
  var shouldPrint: Bool
  @State private var errors: [Error] = []
  func body(content: Content) -> some View {
    content
      .alert(
        isPresented: Binding(
          get: { !errors.isEmpty },
          set: { if !$0 { errors.removeFirst() } }
        )
      ) {
        Alert(
          title: Text("Error"),
          message: errors.first.map {
#if DEBUG
            Text(verbatim: $0.localizedDescription + ", \($0)")
#else
            Text(verbatim: $0.localizedDescription)
#endif
          },
          dismissButton: .default(Text("OK"))
        )
      }
      .environment(\.[key: \Throw.self], Throw { error in
        if shouldPrint {
          print("error: ", error, "description: ", error.localizedDescription)
        }
        errors.append(error)
      })
  }
}

extension View {
  func showErrors(shouldPrint: Bool = true) -> some View {
    modifier(ShowErrors(shouldPrint: shouldPrint))
  }
}

