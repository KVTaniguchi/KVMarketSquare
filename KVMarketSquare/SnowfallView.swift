//
//  SnowfallView.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-15.
//

import SwiftUI
import UIKit

struct SnowfallView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let size = CGSize(width: 824.0, height: 1112.0)
        let host = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))

        let snowflake = UIImage(named: "snowflake")?.cgImage
        
        let snowflakeCell = CAEmitterCell()
        snowflakeCell.contents = snowflake
        snowflakeCell.scale = 0.06
        snowflakeCell.scaleRange = 0.3
        snowflakeCell.emissionRange = .pi
        snowflakeCell.lifetime = 20.0
        snowflakeCell.birthRate = 40.0
        snowflakeCell.velocity = -30.0
        snowflakeCell.velocityRange = -20.0
        snowflakeCell.yAcceleration = 30.0
        snowflakeCell.xAcceleration = 5.0
        snowflakeCell.spin = -5.0
        snowflakeCell.spinRange = 1.0
        
        let snowfallLayer = CAEmitterLayer()
        snowfallLayer.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        snowfallLayer.emitterPosition = CGPoint(x: size.width / 2.0, y: -50)
        snowfallLayer.emitterSize = CGSize(width: size.width, height: 0)
        snowfallLayer.emitterShape = CAEmitterLayerEmitterShape.line
        snowfallLayer.beginTime = CACurrentMediaTime()
        snowfallLayer.timeOffset = 10
        snowfallLayer.emitterCells = [snowflakeCell]

        host.layer.addSublayer(snowfallLayer)
        host.layer.masksToBounds = true
        
        return host
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}

    typealias UIViewType = UIView
}

struct SnowfallView_Previews: PreviewProvider {
    static var previews: some View {
        SnowfallView()
    }
}
