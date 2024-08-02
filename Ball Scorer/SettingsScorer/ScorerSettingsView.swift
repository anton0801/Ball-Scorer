import SwiftUI

struct ScorerSettingsView: View {
    
    @Environment(\.presentationMode) var prm
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
    
    init() {
        soundsApp = UserDefaults.standard.bool(forKey: "sounds_app")
        musicApp = UserDefaults.standard.bool(forKey: "music_app")
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    prm.wrappedValue.dismiss()
                } label: {
                    Image("home_btn")
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
            
            AppNameTitle()
            
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
            
            
        }
        .background(
            Image("scorer_image")
                .resizable()
                .frame(minWidth: screenWidth, minHeight: screenHeight)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ScorerSettingsView()
}
