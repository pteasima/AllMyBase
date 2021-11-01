protocol AsyncThrowingSequence: AsyncSequence {
  associatedtype Failure: Error
}

extension AsyncThrowingStream: AsyncThrowingSequence { }
extension AsyncThrowingMapSequence: AsyncThrowingSequence where Base: AsyncThrowingSequence {
  typealias Failure = Base.Failure
}

// right Failure is required to be Error, since the AsyncThrowingStream initializer doesn't allow others.
extension AsyncThrowingSequence where Failure == Error {
  func eraseToStream() -> AsyncThrowingStream<Element, Failure> {
    AsyncThrowingStream { continuation in
      Task {
        do {
          for try await output in self {
            continuation.yield(output)
          }
          continuation.finish(throwing: nil)
        } catch {
          continuation.finish(throwing: error)
        }
      }
    }
  }
}
