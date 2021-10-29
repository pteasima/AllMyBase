@inlinable
func with<T>(_ value: T, _ block: @escaping (inout T) throws -> Void) rethrows -> T {
  var copy = value
  try block(&copy)
  return copy
}
