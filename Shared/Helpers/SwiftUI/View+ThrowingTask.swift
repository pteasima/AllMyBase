import SwiftUI

struct ThrowingTask: ViewModifier {
  @Environment(\.[key: \Throw.self]) private var `throw`
  var action: () async throws -> Void
  func body(content: Content) -> some View {
    content
      .task {
        do {
          try await action()
        } catch {
          `throw`(error)
        }
      }
  }
}

extension View {
  func throwingTask(_ action: @escaping () async throws -> Void) -> some View {
    modifier(ThrowingTask(action: action))
  }
}
