import SwiftUI

private struct LifetimeTask: ViewModifier {
  @State @Reference private var hasAppeared = false
  var perform: () async -> Void
  func body(content: Content) -> some View {
    content
      .task {
        guard !hasAppeared else { return }
        hasAppeared = true
        await perform()
      }
  }
}

extension View {
  func lifetimeTask(perform: @escaping () async -> Void) -> some View {
    self.modifier(LifetimeTask(perform: perform))
  }
}

private struct ThrowingLifetimeTask: ViewModifier {
  @State @Reference private var hasAppeared = false
  var perform: () async throws -> Void
  func body(content: Content) -> some View {
    content
      .throwingTask {
        guard !hasAppeared else { return }
        hasAppeared = true
        try await perform()
      }
  }
}

extension View {
  func throwingLifetimeTask(perform: @escaping () async throws -> Void) -> some View {
    self.modifier(ThrowingLifetimeTask(perform: perform))
  }
}
