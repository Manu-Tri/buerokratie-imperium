import SwiftUI

@main
struct BuerokratieImperiumApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .ignoresSafeArea()
                .background(Color("Paper"))
        }
    }
}
