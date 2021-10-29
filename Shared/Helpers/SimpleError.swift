import Foundation

struct SimpleError: LocalizedError {
  var errorDescription: String?
}

extension SimpleError {
  init(_ errorDescription: String = "Undefined error occured.") {
    self.init(errorDescription: errorDescription)
  }
}
