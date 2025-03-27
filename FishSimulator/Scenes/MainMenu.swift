import SwiftUI

struct MainMenu: View {
    
    @State var isShowingShop: Bool = false
    @State var isShowingSettings: Bool = false
    @State var isShowingGame: Bool = false
    
    @AppStorage("coins") private var coins: Int = 0

    var body: some View {
        ZStack {
            CurrentBackground()
            CurrentPlayer()
            
            VStack {
                CoinFullItem(text:"\(coins)")
                Spacer()
                WoodenButton(text: "Play") {
                    withAnimation(.easeInOut) {
                        isShowingGame = true
                    }
                }
                .frame(width: 256, height: 64)
                .padding(.bottom, 24)
                HStack(spacing: 32) {
                    WoodenButton(text: "Shop") {
                        withAnimation(.easeInOut) {
                            isShowingShop = true
                        }
                    }
                    .frame(width: 256, height: 64)
                    WoodenButton(text: "Settings") {
                        withAnimation(.easeInOut) {
                            isShowingSettings = true
                        }
                    }
                    .frame(width: 256, height: 64)
                }
            }.padding()
            if isShowingShop {
                Shop {
                    withAnimation(.easeInOut) {
                        isShowingShop = false
                    }
                }.transition(.opacity)
            }
            
            if isShowingSettings {
                Settings {
                    withAnimation(.easeInOut) {
                        isShowingSettings = false
                    }
                }.transition(.opacity)
            }
        }.fullScreenCover(isPresented: $isShowingGame) {
            FishingGameView() {
                isShowingGame = false
            }
        }
    }
}

#Preview {
    MainMenu()
}
