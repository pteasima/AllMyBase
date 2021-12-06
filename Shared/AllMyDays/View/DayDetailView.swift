//
//  DayDetailView.swift
//  AllMyBase
//
//  Created by Petr Šíma on 06.12.2021.
//

import SwiftUI

// TODO:
// Firebase structure vs. markdown. I'd still love to render to just plain markdown, but how does that relate to Timers stored in firestore etc.
// - [ ]

struct DayDetailView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

extension DayDetailView {
  struct Day: Codable {
    
  }
}

struct DayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DayDetailView()
    }
}
