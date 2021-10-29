import FirebaseFirestore
import FirebaseFirestoreSwift

extension DocumentReference {
  // Unlike raw dictionary based APIs, the Encodable based API don't get auto translated (presumably because they can also throw synchronously. So we created our own.
  // We could wrap the original in an explicit continuation, but using the lower-level dictionary based api (which is already async/await compatible) is more straighforward.
  func setData<T: Encodable>(from value: T, merge: Bool = false, encoder: Firestore.Encoder = .init()) async throws {
    try await setData(encoder.encode(value), merge: merge)
  }
  
  // For now, we chose not to replicate the Encodable based API with `mergeFields` params, since we felt like it doesn't bring much value over the dictionary based one (if we have to deal with string field names anyway, might as well deal with the dictionary)
}

extension DocumentReference {
  func observe(includeMetadataChanges: Bool = false) -> AsyncThrowingStream<DocumentSnapshot, Error> {
    //TODO: possibly use buffering policy `.bufferingNewest(1)`
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
