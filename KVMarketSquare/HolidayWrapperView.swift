//
//  HolidayWrapperView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-15.
//

import SwiftUI
import SpriteKit

struct HolidayWrapperView<Content: View>: View {
    @EnvironmentObject private var appData: AppData
    @Environment(\.colorScheme) var colorScheme

    var content: () -> Content
    var scene: SKScene
    
    init(@ViewBuilder content: @escaping () -> Content, scene: SKScene = BetterSnowFall()) {
        self.content = content
        self.scene = scene
    }
    
    var body: some View {
        ZStack {
            if colorScheme == .dark && appData.isLettingItSnow {
                SpriteView(scene: scene, options: [.allowsTransparency])
//                SnowfallView() -- felt very static
            }
            self.content()
        }
    }
}

class BetterSnowFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        backgroundColor = .clear
        
        let node = SKEmitterNode(fileNamed: "Snowfall.sks")!
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

