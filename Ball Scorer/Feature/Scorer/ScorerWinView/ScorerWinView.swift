import SwiftUI

struct ScorerWinView: View {
    
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
    
    @State var soundsApp = false {
        didSet {
            UserDefaults.standard.set(soundsApp, forKey: "sounds_app")
        }
    }
    @State var musicApp = false {
        didSet {
            UserDefaults.standard.set(musicApp, forKey: "music_app")
        }
    }
    
    var body: some View {
        VStack {
            Text("YOU\nWIN!")
                 .font(.custom("Slamming", size: 52))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 42)
            
            Spacer()
            
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
            Text("exit to levels")
                 .font(.custom("Slamming", size: 24))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 8)
            
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
            .padding(.top, 24)
            Text("Repeat current level")
                 .font(.custom("Slamming", size: 24))
                 .foregroundColor(.white)
                 .frame(width: 250)
                 .multilineTextAlignment(.center)
                 .padding(.top, 8)
            
            Text("SOUND")
                  .font(.custom("Slamming", size: 32))
                  .foregroundColor(.white)
                  .frame(width: 250)
                  .multilineTextAlignment(.center)
                  .padding(.top, 42)
                
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation(.linear(duration: 0.2)) {
                            soundsApp = false
                        }
                    } label: {
                        Image("sound_off")
                            .opacity(soundsApp ? 0.6 : 1)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear(duration: 0.2)) {
                            soundsApp = true
                        }
                    } label: {
                        Image("sound_on")
                            .opacity(soundsApp ? 1 : 0.6)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
                Text("MUSIC")
                  .font(.custom("Slamming", size: 32))
                  .foregroundColor(.white)
                  .frame(width: 250)
                  .multilineTextAlignment(.center)
                  .padding(.top, 42)
                
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation(.linear(duration: 0.2)) {
                            musicApp = false
                        }
                    } label: {
                        Image("sound_off")
                            .opacity(musicApp ? 0.6 : 1)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear(duration: 0.2)) {
                            musicApp = true
                        }
                    } label: {
                        Image("sound_on")
                            .opacity(musicApp ? 1 : 0.6)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
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
    ScorerWinView()
}
