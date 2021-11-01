import Foundation
import SwiftUI
import Combine

struct Throw: EnvironmentKey {
  static var defaultValue: Self = .init()
  
  @MainActor var handleError: (Error) -> Void = { error in
    print("Unhandled user-facing error: \(error.localizedDescription) , \(error)")
    #if DEBUG
    raise(SIGINT) // trigger a breakpoint
    #endif
  }
  func callAsFunction(_ error: Error) {
    Task {
      await handleError(error)
    }
  }
  
  func `try`(_ work: (() throws -> Void)) {
    do {
      try work()
    } catch {
      self(error)
    }
  }
  
  func `try`(_ work: @escaping () async throws -> Void) async {
    do {
      try await work()
    } catch {
      self(error)
    }
  }
  
  @discardableResult
  func `try`(_ work: @escaping () async throws -> Void) -> Task<(), Never> {
    Task {
      await `try`(work)
    }
  }
}

extension Throw {
  init(boundTo error: Binding<Error?>) {
    self.init {
      error.wrappedValue = $0
    }
  }
}

extension Publisher {
  func sendErrors(to throw: Throw, completeOnError: Bool = true) -> Publishers.Catch<Publishers.HandleEvents<Self>, Empty<Self.Output, Never>> {
    handleErrors(using: `throw`)
      .`catch` { _ in Empty<Self.Output, Never>(completeImmediately: completeOnError) }
  }
  func handleErrors(using throw: Throw) -> Publishers.HandleEvents<Self> {
    handleEvents(receiveCompletion: {
      if case .failure(let error) = $0 {
        `throw`(error)
      }
    })
  }
}

struct ThrowingTask: ViewModifier {
  @Environment(\.[key: \Throw.self]) private var `throw`
  var action: () async throws -> Void
  func body(content: Content) -> some View {
    content
      .task {
        `throw`.try(action)
      }
  }
}

extension View {
  func throwingTask(_ action: @escaping () async throws -> Void) -> some View {
    modifier(ThrowingTask(action: action))
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
          message: errors.first.map { Text(verbatim: errorDescription($0)) },
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

  private func errorDescription(_ error: Error) -> String {
    #if DEBUG
    return error.localizedDescription + ", \(error)"
    #else
    return error.localizedDescription
    #endif
  }
}

extension View {
  func showErrors(shouldPrint: Bool = true) -> some View {
    modifier(ShowErrors(shouldPrint: shouldPrint))
  }
}

