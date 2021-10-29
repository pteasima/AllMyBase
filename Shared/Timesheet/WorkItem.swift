import Foundation

struct WorkItem: Codable, Identifiable {
  typealias ID = String
  var id: ID
  
  var started: Date
  var ended: Date?
  
  var notes: String = ""
  
  struct Pause: Codable, Identifiable {
    typealias ID = String
    var id: ID
    
    var started: Date
    var ended: Date?
  }
  
  var pauses: [Pause] = []
}

extension WorkItem {
  static var samples = (
    Self(id: "sampleworkitem0", started: .samples.0),
    Self(id: "sampleworkitem1", started: .samples.1)
  )
}
