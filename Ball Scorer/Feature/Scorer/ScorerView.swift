import SwiftUI
import SpriteKit

extension String {
    static let winScreen = "win_screen"
    static let loseScreen = "lose_screen"
    static let pauseScreen = "pause_screen"
}

struct ScorerView: View {
    
    var level: Int
    var scene: ScorerScene
    
    @EnvironmentObject var levelsVm: ScorerLevelsViewModel
    @Environment(\.presentationMode) var presMode
    
    @State var gameViewVisible: String = "game"
    
    init(level: Int) {
        self.level = level
        self.scene = ScorerScene(level: level)
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            switch (gameViewVisible) {
            case .winScreen:
                ScorerWinView()
            case .loseScreen:
                ScorerLoseScreen()
            case .pauseScreen:
                ScorerGamePauseView()
            default:
                EmptyView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("win")), perform: { _ in
            levelsVm.unlockLevel(id: level + 1)
            withAnimation {
                gameViewVisible = .winScreen
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("lose")), perform: { _ in
            withAnimation {
                gameViewVisible = .loseScreen
              }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pause")), perform: { _ in
            scene.isPaused = true
            withAnimation {
                gameViewVisible = .pauseScreen
              }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("back")), perform: { _ in
            presMode.wrappedValue.dismiss()
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restart_game")), perform: { _ in
            scene.isPaused = false
            scene.restartGame()
            withAnimation {
                  gameViewVisible = "game"
              }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("continue_game")), perform: { _ in
            scene.isPaused = false
            withAnimation {
                  gameViewVisible = "game"
              }
        })
    }
}

#Preview {
    ScorerView(level: 1)
        .environmentObject(ScorerLevelsViewModel())
}
