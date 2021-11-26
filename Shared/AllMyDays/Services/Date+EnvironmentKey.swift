import Foundation
import SwiftUI

extension Date: EnvironmentKey {
  public static var defaultValue: () -> Self { Self.init }
}
