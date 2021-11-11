//
//  ShortcutsView.swift
//  AllMyBase
//
//  Created by Petr Šíma on 11.11.2021.
//

import SwiftUI

struct ShortcutsView: View {
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button {
            Task {
            openURL(URL(string: "shortcuts://run-shortcut?name=hello")!)
                await Task.sleep(3_000_000_000)
            openURL(URL(string: "shortcuts://run-shortcut?name=hello")!)
            }
        } label: {
            Text("Hello, World!")
        }
        
    }
}

struct ShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsView()
    }
}
