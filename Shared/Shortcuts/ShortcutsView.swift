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
        .throwingLifetimeTask {
//            DistributedNotificationCenter.default().addObserver(forName: .init(rawValue: "com.apple.MultitouchSupport.HID.DeviceAdded"), object: nil, queue: nil) {
//                print("notification", $0)
//            }
        }
        
    }
}

struct ShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutsView()
    }
}
