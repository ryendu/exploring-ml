//
//  NNStructureLiveView.swift
//  Views
//
//  Created by Ryan D on 4/4/21.
//

import SwiftUI
import PlaygroundSupport
import ML
import Scenes
import SpriteKit

public struct NNStructureLiveView: View {
    public init () {}
    
    var scene: SKScene {
        let scene = NNStructureScene(size:CGSize(width: 400, height: 300), layerShape:[724,16,16,10])
        scene.scaleMode = .aspectFit
            return scene
    }

    public var body: some View {
        SpriteView(scene: scene)
    }
}


public func instantiateNNStructureLiveView() -> NNStructureLiveView {
    let view = NNStructureLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
