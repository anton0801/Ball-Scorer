import SwiftUI

struct ScorerMenuView: View {
    
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
        NavigationView {
            VStack {
                AppNameTitle()
                
                NavigationLink(destination: ScorerLevels()
                    .navigationBarBackButtonHidden(true), label: {
                        Text("PLAY")
                            .font(.custom("Slamming", size: 32))
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .multilineTextAlignment(.center)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white, lineWidth: 2.0)
                                    .frame(width: 150, height: 50)
                            }
                    })
                .padding(.top)
                
                Text("Break Bricks")
                    .font(.custom("Slamming", size: 22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                NavigationLink(destination: ScorerSettingsView()
                    .navigationBarBackButtonHidden(true), label: {
                        Text("SETTINGS")
                            .font(.custom("Slamming", size: 38))
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .multilineTextAlignment(.center)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white, lineWidth: 2.0)
                                    .frame(width: 180, height: 50)
                            }
                    })
                .padding(.top, 52)
                Text("Settings of game")
                    .font(.custom("Slamming", size: 22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            .background(
                Image("scorer_image")
                    .resizable()
                    .frame(minWidth: screenWidth, minHeight: screenHeight)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AppNameTitle: View {
    var body: some View {
        Text("Ball Scorer")
            .font(.custom("Slamming", size: 82))
            .foregroundColor(.white)
            .frame(width: 250)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ScorerMenuView()
}
