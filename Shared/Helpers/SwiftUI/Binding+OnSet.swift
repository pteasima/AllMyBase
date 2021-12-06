import SwiftUI

extension Binding {
  @inlinable
  public func onSet(perform: @escaping (Value) -> Void) -> Self {
    return .init {
      wrappedValue
    } set: {
      self.wrappedValue = $0; perform($0) 
    }
  }
}
