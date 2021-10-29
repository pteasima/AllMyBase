import Foundation

extension Date {
  static var samples = (
    Self(timeIntervalSinceReferenceDate: 0),
    Self(timeIntervalSinceReferenceDate: 60*60*24)
  )
}
