//
//  EarthView.swift
//  BookCore
//
//  Created by Ryan D on 3/30/21.
//

import Foundation
import SceneKit
import UIKit
import SwiftUI
import ModelIO
import SceneKit.ModelIO

/// a swiftui view that displays a spinning 3D earth with Scene Kit
public struct EarthSpinningView : UIViewRepresentable {
    public let scene = SCNScene()
    
    var spinRate:Double
    public init(spinRate:Double) {
        self.spinRate = spinRate
    }
    public func makeUIView(context: Context) -> SCNView {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let earthGeo = SCNSphere(radius: 5)
        earthGeo.firstMaterial?.diffuse.contents = UIImage(named: "earth albedo")!
        earthGeo.firstMaterial?.specular.contents = UIImage(named: "earth land ocean mask")!
        earthGeo.firstMaterial?.emission.contents = UIImage(named: "earth night_lights_modified")
        earthGeo.firstMaterial?.ambient.contents = UIImage(named: "clouds earth")!
        let earth = SCNNode(geometry: earthGeo)
        scene.rootNode.addChildNode(earth)
        
        earth.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(Int(self.spinRate.rounded())), z: 0, duration: 5)))

        let scnView = SCNView()
        return scnView
    }

    public func updateUIView(_ scnView: SCNView, context: Context) {
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = false
        scnView.backgroundColor = UIColor.black
    }
}
