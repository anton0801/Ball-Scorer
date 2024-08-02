import SwiftUI

struct ScorerLoseScreen: View {
 
    @Environment(\.presentationMode) var presmode
    
    private var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    private var screenHeight: CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    
    var body: some View {
        VStack {
            Text("GAME OVER!")
                 .font(.custom("Slamming", size: 52))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 42)
            
            Text("you lose, but you can try again!")
                 .font(.custom("Slamming", size: 24))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 42)
            
            Spacer()
            
            Button {
                NotificationCenter.default.post(name: Notification.Name("restart_game"), object: nil)
            } label: {
                Text("RESTART")
                    .font(.custom("Slamming", size: 38))
                    .foregroundColor(.white)
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white, lineWidth: 2.0)
                            .frame(width: 180, height: 50)
                    }
            }
            Text("Repeat current level")
                 .font(.custom("Slamming", size: 24))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 8)
            
            Button {
                presmode.wrappedValue.dismiss()
            } label: {
                Text("EXIT GAME")
                    .font(.custom("Slamming", size: 38))
                    .foregroundColor(.white)
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white, lineWidth: 2.0)
                            .frame(width: 180, height: 50)
                    }
            }
            .padding(.top, 24)
            Text("exit to levels")
                 .font(.custom("Slamming", size: 24))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 8)
            
            Spacer()
            
            Spacer()
        }
        .background(
            Image("background_color")
                .resizable()
                .frame(minWidth: screenWidth, minHeight: screenHeight)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ScorerLoseScreen()
}
