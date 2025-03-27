import SwiftUI
import SpriteKit

#Preview {
    FishingGameView() {
        //
    }
}

struct FishingGameView: View {
    @State private var fishCaught = 0
    @State private var coinsEarned = 0 {
        didSet {
            self.coins += coinsEarned
        }
    }
    @State private var depth = 1
    @State private var catchL = 1
    @AppStorage("coins") private var coins: Int = 0
    @AppStorage("depthLevel") private var depthLevel: Int = 1
    @AppStorage("fishLimit") private var catchLimit: Int = 1
    @State private var showFinish = false
    

    
    var onBack: () -> Void

    var scene: SKScene {
        let scene = FishingScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.getDepthLevel = { self.depth }
        scene.getCatchLimit = { self.catchL }
        scene.showFinishCallback = { fish, coins in
            self.fishCaught = fish
            self.coinsEarned = coins
            withAnimation(.easeInOut) {
                self.showFinish = true
            }
        }
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)
            if showFinish {
                Finish(fishCount: fishCaught, coinsCount: coinsEarned) {
                    withAnimation(.easeInOut) {
                        showFinish = false
                    }
                } onBack: {
                    onBack()
                }.transition(.scale)

            } else {
                VStack {
                    ZStack(alignment: .top) {
                        CoinFullItem(text: "\(coins)")
                            .padding()
                        HStack(alignment: .top) {
                            Button {
                                onBack()
                            } label: {
                                Assets.UI.optionsButton
                                    .frame(width: 60, height: 60)
                            }
                            Spacer()
                            VStack {
                                if depthLevel <= 20 {
                                    GameItem(itemType: .depth, text: "\(depthLevel)", price: "\(depthLevel * 100)") {
                                        let price = depthLevel * 100
                                        guard price <= coins else { return }
                                        coins -= price
                                        depthLevel += 1
                                        depth = depthLevel
                                    }.colorMultiply(depthLevel * 100 <= coins ? .white : .gray)
                                }
                                
                                if catchLimit <= 15 {
                                    GameItem(itemType: .fish, text: "\(catchLimit)", price: "\(catchLimit * 100)") {
                                        let price = catchLimit * 100
                                        guard price <= coins else { return }
                                        coins -= price
                                        catchLimit += 1
                                        catchL = catchLimit
                                    }.colorMultiply(catchLimit * 100 <= coins ? .white : .gray)
                                }
                            }
                        }.padding()
                    }
                    Spacer()
                }.transition(.opacity)
            }
        }.onAppear {
            MusicCentre.shared.playMusic()
            depth = depthLevel
            catchL = catchLimit
        }
        .onDisappear {
            MusicCentre.shared.stopMusic()
        }
    }
}

struct GameItem: View {
    
    let itemType: ItemType
    let text: String
    let price: String
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                switch itemType {
                case .depth:
                    Assets.UI.depthCountFrame
                        .frame(width: 140, height: 80)
                case .fish:
                    Assets.UI.fishCountFrame
                        .frame(width: 140, height: 80)
                }
                StrokedText(text: text, size: 28, strokeColor: .red)
                    .offset(x: 15, y: -2)
            }
            WoodenButton(text: price, size: 20) {
                onTap()
            }
            .frame(width: 100, height: 32)
        }
    }
}

enum ItemType {
    case depth
    case fish
}
