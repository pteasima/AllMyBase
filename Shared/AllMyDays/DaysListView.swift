import SwiftUI

struct DaysListView: View {
  @Environment(\.calendar) private var calendar
  @Environment(\.[key: \Date.self]) private var now
  @State private var today: Date = .distantPast
  
  var body: some View {
    List {
      ForEach(displayedDays) { day in
        Section(header: Text(day.date.formatted())) {
          Text(day.log)
        }
      }
    }
    .lifetimeTask {
      today = calendar.startOfDay(for: now())
    }
  }
}

extension DaysListView {
  struct Day: Identifiable {
    var id: Date { date }
    var date: Date
    
    var log: String = "hello"
  }
  
  private var displayedDays: [Day] {
    return [
      .init(date: today)
    ]
  }
}

struct DaysListView_Previews: PreviewProvider {
  static var previews: some View {
    DaysListView()
  }
}
