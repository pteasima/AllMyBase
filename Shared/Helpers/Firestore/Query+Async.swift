import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
  //TODO: possibly use buffering policy `.bufferingNewest(1)`
  func observe(includeMetadataChanges: Bool = false) -> AsyncThrowingStream<QuerySnapshot, Error> {
    return AsyncThrowingStream { continuation in
      let registration = self.addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
        if let error = error {
          continuation.finish(throwing: error)
        } else if let snapshot = snapshot {
          continuation.yield(snapshot)
        } else {
          assertionFailure()
          continuation.finish(throwing: SimpleError("Unknown firestore error has occured."))
        }
      }
      continuation.onTermination = { @Sendable _ in registration.remove() }
    }
  }
}



