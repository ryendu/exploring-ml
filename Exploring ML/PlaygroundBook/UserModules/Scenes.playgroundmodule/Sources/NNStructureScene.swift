//
//  NNStructureScene.swift
//  Scenes
//
//  Created by Ryan D on 4/5/21.
//

import Foundation
import SpriteKit
import PlaygroundSupport

public class NNStructureScene: SKScene{
    public var layers:[[SKNode]] = []
    var layersShape:[Int]
    let spacing = 19
    let neuronDiameter = 10
    let verticalPadding:CGFloat = 20
    public init(size:CGSize,layerShape:[Int]) {
        self.layersShape = layerShape
        super.init(size: size)
    }
    
    public required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:)? Boo don't initialize this way.")
    }
    
    public override func didMove(to view: SKView) {
        //spawn all the neurons
        self.backgroundColor = .black
        for layerIndex in 0...layersShape.count-1{
            var tmpLayer: [SKNode] = []
            //initialize some variables
            let maxLayerLen = Int(self.size.height-verticalPadding)
            let layerActualLen = Int(layersShape[layerIndex]) * spacing
            let maxN = Int(Double(maxLayerLen/spacing).rounded(.down))
            let isOverMaxLen = layerActualLen > maxLayerLen
            //only used if layerActualLen is greater than max layer len
            let beforeQuotaLimit = layersShape[layerIndex]
            //if some neurons of a layer won't fit in side the view, we remove those neurons and 4 more to make space for the ...
            layersShape[layerIndex] = isOverMaxLen ? maxN : layersShape[layerIndex]
            let layerLen = layersShape.count
            let x = (Int(self.size.width) - 40) / layerLen * (layerIndex + 1) - 20
            //for each neuron to be spawned, we get the y value, initialize sum stuff, and add it.
            for i in 0...layersShape[layerIndex] - 1{
                let y = getyValueForNeuron(len: layersShape[layerIndex], n: i,isOverMaxLen: isOverMaxLen)
                let nd = SKShapeNode(ellipseOf: CGSize(width: neuronDiameter, height: neuronDiameter))
                nd.position = CGPoint(x: Int(x), y: y)
                nd.fillColor = .gray
                nd.strokeColor = .white
                tmpLayer.append(nd)
                self.addChild(nd)
            }
            layers.append(tmpLayer)
            //time to add elipses if some neurons don't fit on screen
            if isOverMaxLen{
                insertEllipsisAndNum(x:x,num:beforeQuotaLimit)
            }
            
            
            
        }
        addConnections(layers:layers)
    }
    
    //adds connection lines between each neuron
    private func addConnections(layers:[[SKNode]]){
        var line_: SKShapeNode = SKShapeNode()
        for li in 0...layers.count - 1{
            for node1i in layers[li]{
                if li < layers.count - 1{
                    for node2i in layers[li + 1]{
                        // Create line with SKShapeNode
                        let line = SKShapeNode()
                        let path = UIBezierPath()
                        path.move(to: CGPoint(x: CGFloat(node1i.position.x + CGFloat(neuronDiameter/2)+1), y: CGFloat(node1i.position.y)))
                        
                        path.addLine(to: CGPoint(x: CGFloat(node2i.position.x - CGFloat(neuronDiameter/2)-1), y: CGFloat(node2i.position.y)))
                        line.path = path.cgPath
                        line.strokeColor = UIColor.white
                        line.lineWidth = 0.01
                        line_ = line
                        self.addChild(line)
                    }
                }
                
            }
        }
    }
    
    ///finds the distance between two sprite nodes
    private func distanceBetweenNodes(n1:SKNode,n2:SKNode) -> CGFloat{
        let x = n2.position.x - n1.position.x
        let y = n2.position.y - n1.position.y
        let res = sqrt(x*x + y*y)
        return res
    }
    
    ///spawns teh ellipsis and number on the side to indicate how many total neurons
    private func insertEllipsisAndNum(x:Int,num:Int){
        //how much extra padding each side
        let extraPaddingEach = 0
        let maxLayerLen = Int(self.size.height-self.verticalPadding)
        let maxN = Int(Double(maxLayerLen/spacing).rounded(.down))
        //where the ellipsis can start on the y axis.
        let distanceInLayerStart = spacing * (maxN / 2) + (neuronDiameter) + (extraPaddingEach)
        //where the ellipsis ends on the y axis.
        let distanceInLayerEnd = spacing * (maxN / 2 + 2) - (neuronDiameter) - (extraPaddingEach)
        let ellipsisAllocatedTotalSpaceY = distanceInLayerEnd - distanceInLayerStart
        
        //initializes ellipsis
        let ellipsisPart1 = SKShapeNode(ellipseIn: CGRect(x: Double(x), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 1)), width: 1.5, height: 1.5))
        ellipsisPart1.fillColor = .white
        let ellipsisPart2 = SKShapeNode(ellipseIn: CGRect(x: Double(x), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 2)), width: 1.5, height: 1.5))
        ellipsisPart1.fillColor = .white
        let ellipsisPart3 = SKShapeNode(ellipseIn: CGRect(x: Double(x), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 3)), width: 1.5, height: 1.5))
        ellipsisPart1.fillColor = .white
        self.addChild(ellipsisPart1)
        self.addChild(ellipsisPart2)
        self.addChild(ellipsisPart3)
        
        //adds text
        let neuronNLabel = SKLabelNode(text: "\(num)")
        neuronNLabel.fontSize = 10
        neuronNLabel.color = .white
        neuronNLabel.position = CGPoint(x: Double(x - 15), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 2)) - 2)
        self.addChild(neuronNLabel)
    }
    
    ///gets the y value for a neuron
    private func getyValueForNeuron(len:Int, n:Int,isOverMaxLen:Bool)->Int{
        let maxLayerLen = Int(self.size.height-self.verticalPadding)
        let layerActualLen = Int(len) * spacing
        var res: Int = 0
        let oneSidePadding = ((Int(self.size.height) - (layerActualLen))/2)+neuronDiameter
        if isOverMaxLen {
            let maxN = Int(Double(maxLayerLen/spacing).rounded(.down))
            // if this neuron is supposed to be in the middle 2
            if maxN / 2 - 1 < n && maxN / 2 + 1 > n {
//                self.addChild(SKLabelNode(text: "maxN: \(maxN)"))
                // sets y pos to that of the first neuron so it does not appear
                let overRes = spacing * 1 + oneSidePadding
                res = overRes
            } else {
                let distanceInLayer = spacing * n
                let overRes = (distanceInLayer + oneSidePadding)
                res = overRes
            }
        }else{
            let distanceInLayer = spacing * n
            let nonOverRes:Int = (distanceInLayer + oneSidePadding)
            res = nonOverRes
        }
        return res
    }

    public override func update(_ currentTime: TimeInterval) {
        
    }
    
    
}
