import Foundation

protocol OptionalProtocol {
  associatedtype Wrapped
  var value: Wrapped? { get }
}

extension Optional: OptionalProtocol {
  public var value: Wrapped? {
    return self
  }
}
