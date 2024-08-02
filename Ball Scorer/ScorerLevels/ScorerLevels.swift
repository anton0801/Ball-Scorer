import SwiftUI

struct ScorerLevels: View {
    
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
    
    @StateObject var vm = ScorerLevelsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image("home_btn")
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Text("LEVELS")
                      .font(.custom("Slamming", size: 42))
                      .foregroundColor(.white)
                      .frame(width: 250)
                      .multilineTextAlignment(.center)
                      .padding(.top, 42)
                
                LazyVGrid(columns: [
                    GridItem(.fixed(120)),
                    GridItem(.fixed(120)),
                    GridItem(.fixed(120))
                ]) {
                    ForEach(vm.levels, id: \.id) { level in
                        if vm.isLevelUnlocked(id: level.id) {
                            NavigationLink(destination: ScorerView(level: level.id)
                                .environmentObject(vm)
                                .navigationBarBackButtonHidden()) {
                                Text("\(level.id)")
                                    .font(.custom("Slamming", size: 42))
                                    .foregroundColor(.white)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Color.white, lineWidth: 2.0)
                                            .frame(width: 70, height: 70)
                                    }
                                    .frame(width: 70, height: 70)
                                    .padding(4)
                            }
                        } else {
                            VStack {
                                Image("lock")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                            }
                            .frame(width: 70, height: 70)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white, lineWidth: 2.0)
                                    .frame(width: 70, height: 70)
                            }
                            .padding(4)
                        }
                    }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ScorerLevels()
}
