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
    public var layers:[[SKShapeNode]] = []
    var connections: [[SKShapeNode]] = []
    public var animationNodes:[SKNode] = []
    var layersShape:[Int]
    let spacing = 19
    let neuronDiameter = 10
    let verticalPadding:CGFloat = 20
    var showConnectionsAnimationTimer: Timer? = nil
    
    
    //animating connections
    var updateStrokeLengthFloat = false
    let strokeSizeFactor = CGFloat( 2.0 )
    var strokeShader: SKShader!
    var strokeLengthUniform: SKUniform!
    var _strokeLengthFloat: Float = 0.0
    var strokeLengthKey: String!
    var strokeLengthFloat: Float {
        get {
            return _strokeLengthFloat
        }
        set( newStrokeLengthFloat ) {
            _strokeLengthFloat = newStrokeLengthFloat
            strokeLengthUniform.floatValue = newStrokeLengthFloat
        }
    }

    var showDataFlowANimationTimer: Timer? = nil
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
            var tmpLayer: [SKShapeNode] = []
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.carryoutAnimation),
            name: .nnStructrueSceneAnimate,
            object: nil)
        noToppingsAnimation()
    }
    
    @objc func carryoutAnimation(notification: NSNotification){
        guard let action = notification.object as? Int else {return}
        switch action {
        case 0:
            self.noToppingsAnimation()
        case 1:
            self.showDataFlowAnimation()
        case 2:
            self.showConnectionsAnimation()
        default:
            self.endAllAnimations()
            print("Yoo Implement this action")
        }
    }
    
    //adds connection lines between each neuron
    private func addConnections(layers:[[SKNode]]){
        for li in 0...layers.count - 1{
            var tmpConnections: [SKShapeNode] = []
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
                        tmpConnections.append(line)
                        self.addChild(line)
                    }
                }
            }
            connections.append(tmpConnections)
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
        // for showConnectionsAnimation
        if self.updateStrokeLengthFloat{
            if strokeLengthFloat < 1.0 {
                // to edit the speed of the effectr, change this add rate
                strokeLengthFloat += 0.02
            }
        }
    }
    
    //MARK: Animation Functions
    
    public func endAllAnimations(){
        print("ending all animations")
        self.removeChildren(in: animationNodes)
        animationNodes.removeAll()
        if showDataFlowANimationTimer != nil{
            showDataFlowANimationTimer!.invalidate()
        }
        if showConnectionsAnimationTimer != nil{
            showConnectionsAnimationTimer!.invalidate()
        }
        //make all neurons gray again
        for il in layers{
            for i in il{
                i.fillColor = .gray
            }
        }
        updateStrokeLengthFloat = false
        
        for il in connections{
            for i in il{
                i.removeAllChildren()
            }
        }
    }
    
    ///adds 2 emojis and bounces them around
    func noToppingsAnimation(){
        endAllAnimations()
        print("added toppings")
        let yesNode = SKLabelNode(text: "🍦")
        let noNode = SKLabelNode(text: "🍦")
        yesNode.position.x = self.layers[0][0].position.x - 35
        yesNode.position.y = self.layers[0][0].position.y + 7

        guard let lastNeuron = self.layers.last?.last else {return}
        noNode.position.x = lastNeuron.position.x + 35
        noNode.position.y = lastNeuron.position.y + 7
        
        let wigglewiggle1 = SKAction.repeatForever(SKAction.group([SKAction.rotate(byAngle: 2, duration: 1.1),SKAction.rotate(byAngle: -2, duration: 2)]))
        let wigglewiggle2 = SKAction.repeatForever(SKAction.group([SKAction.rotate(byAngle: -2, duration: 1.1),SKAction.rotate(byAngle: 2, duration: 2)]))
        noNode.run(wigglewiggle1)
        yesNode.run(wigglewiggle2)
        
        self.animationNodes.append(yesNode)
        self.animationNodes.append(noNode)
        self.addChild(yesNode)
        self.addChild(noNode)
    }
    
    ///shows the flow of data in the network
    func showDataFlowAnimation(){
        self.endAllAnimations()
        var currentAnimatingLayer = 0
        if self.layers.count > 0{
            showDataFlowANimationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { val in
            for i in self.layers[currentAnimatingLayer]{
                i.fillColor = i.fillColor == .yellow ? .gray : .yellow
            }
            if currentAnimatingLayer != 0 {
                for i in self.layers[currentAnimatingLayer - 1]{
                    i.fillColor = .gray
                }
            }else {
                for i in self.layers.last!{
                    i.fillColor = .gray
                }
            }
            
            if currentAnimatingLayer + 1 < self.layers.count {
                currentAnimatingLayer += 1
            } else {
                currentAnimatingLayer = 0
            }
        })
        }else {
            
        }
    }
    
    ///animates the flow of data through connections in the network
    func showConnectionsAnimation(){
        self.endAllAnimations()
        print("Animating Connections")
        
        var currentAnimatingLayer = 0
        if self.connections.count > 0{
            showConnectionsAnimationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] val in
                if currentAnimatingLayer == 0 {
                    for il in connections{
                        for i in il{
                            i.removeAllChildren()
                        }
                    }
                }
//                if let i = self.connections.first?.first{
                self.strokeLengthKey = "u_current_percentage"
                strokeLengthUniform = SKUniform( name: self.strokeLengthKey, float: 0.0 )
                let uniforms: [SKUniform] = [self.strokeLengthUniform]
                self.strokeShader = shaderWithFilename( "animateStroke", fileExtension: "fsh", uniforms: uniforms )
                updateStrokeLengthFloat = true
                strokeLengthFloat = 0.0
                
                let li = currentAnimatingLayer
                for node1i in 0...self.layers[li].count - 1{
                    if self.connections[li].count > 0{
                        self.connections[li][node1i].removeAllChildren()
                        let node1 = self.layers[li][node1i]
                        if li < layers.count - 1{
                            for node2 in layers[li + 1]{
                                // Create line with SKShapeNode
                                let line = SKShapeNode()
                                let path = UIBezierPath()
                                path.move(to: CGPoint(x: CGFloat(node1.position.x + CGFloat(neuronDiameter/2)+1), y: CGFloat(node1.position.y)))
                                path.addLine(to: CGPoint(x: CGFloat(node2.position.x - CGFloat(neuronDiameter/2)-1), y: CGFloat(node2.position.y)))
                                line.path = path.cgPath
                                line.lineWidth = 0.01
                                line.strokeShader = strokeShader
                                self.connections[li][node1i].addChild(line)
                            }
                        }
                    }
                }
                    if currentAnimatingLayer + 1 < self.layers.count {
                        currentAnimatingLayer += 1
                    } else {
                        currentAnimatingLayer = 0
                    }
            })
        }
    }
}


extension Notification.Name {
   static var nnStructrueSceneAnimate: Notification.Name {
       return Notification.Name("nnStructrueSceneAnimate")
   }
}

public func shaderWithFilename( _ filename: String?, fileExtension: String?, uniforms: [SKUniform] ) -> SKShader {
        let path = Bundle.main.path( forResource: filename, ofType: fileExtension )
        let source = try! NSString( contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue )
        let shader = SKShader( source: source as String, uniforms: uniforms )
        return shader
}





//MARK: keeping old code just incase


//iteration2
//func showConnectionsAnimation(){
//    self.endAllAnimations()
//    print("Animating Connections")
//
//    var currentAnimatingLayer = 0
//    if self.connections.count > 0{
//        showConnectionsAnimationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [self] val in
//            for i in self.connections[currentAnimatingLayer]{
////                if let i = self.connections.first?.first{
//                guard let ogPath = i.path else { return }
//                self.strokeLengthKey = "u_current_percentage"
//                strokeLengthUniform = SKUniform( name: self.strokeLengthKey, float: 0.0 )
//                let uniforms: [SKUniform] = [self.strokeLengthUniform]
//                self.strokeShader = shaderWithFilename( "animateStroke", fileExtension: "fsh", uniforms: uniforms )
//                strokeLengthFloat = 0.0
//                let path1 = CGMutablePath()
//                let startPoint = CGPoint(x: ogPath.boundingBoxOfPath.minX, y: ogPath.boundingBoxOfPath.minY)
//                let endPoint = CGPoint(x: ogPath.boundingBoxOfPath.maxX, y: ogPath.boundingBoxOfPath.maxY)
//                path1.move( to: startPoint)
//                path1.addLine( to: endPoint)
//                path1.closeSubpath()
////                    updateStrokeLengthFloat = true
//                let shapeNode = SKShapeNode( path: path1 )
//                shapeNode.lineWidth = 0.01
//                shapeNode.strokeColor = .yellow
////                    shapeNode.lineCap = .round
//                i.removeAllChildren()
//                i.addChild(shapeNode)
////                    shapeNode.strokeShader = strokeShader
////                    i.calculateAccumulatedFrame()
//
//            }
//                if currentAnimatingLayer + 1 < self.layers.count {
//                    currentAnimatingLayer += 1
//                } else {
//                    currentAnimatingLayer = 0
//                }
//        })
//    }
//}

//iteration1
//func showConnectionsAnimation(){
//    self.endAllAnimations()
//    print("Animating Connections")
//    var currentAnimatingLayer = 0
//    if self.connections.count > 0{
//        showConnectionsAnimationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { val in
//        for i in self.connections[currentAnimatingLayer]{
////                i.strokeColor = i.strokeColor == .yellow ? .white : .yellow
//
//
//            let path1 = UIBezierPath()
//            guard let ogPath = i.path else {return}
//            path1.move(to: CGPoint(x: ogPath.boundingBoxOfPath.minX, y: ogPath.boundingBoxOfPath.minY))
//            path1.addLine(to: CGPoint(x: ogPath.boundingBoxOfPath.maxX, y: ogPath.boundingBoxOfPath.maxY))
//
//
//
//            let path2 = UIBezierPath()
//            path2.move(to: CGPoint(x: ogPath.boundingBoxOfPath.minX, y: ogPath.boundingBoxOfPath.minY))
//            path2.addLine(to: CGPoint(x: (ogPath.boundingBoxOfPath.minX + ogPath.boundingBoxOfPath.midX)/10, y: (ogPath.boundingBoxOfPath.minY + ogPath.boundingBoxOfPath.midY)/10))
//
//            let casl = CAShapeLayer()
//            casl.path = path1.cgPath
//            casl.fillColor = UIColor.clear.cgColor
//
//            let animation = CABasicAnimation(keyPath: "strokeEnd")
//            animation.fromValue = path1.cgPath
//            animation.toValue = path2.cgPath
//            animation.duration = 2
//            animation.isRemovedOnCompletion = false
//
//
//            let line = SKShapeNode(path: path1.cgPath)
//            line.strokeColor = UIColor.yellow
//            line.fillColor = UIColor.yellow
//            line.lineWidth = 5
//            self.addChild(line)
//
//            casl.add(animation, forKey: "prepanimation")
//            let ska = SKAction.customAction(withDuration: animation.duration, actionBlock: { (node, timeDuration) in
//                if let node = node as? SKShapeNode {
//                    node.path = casl.presentation()?.path
//                }
//            })
//            line.run(ska)
//        }
//        if currentAnimatingLayer != 0 {
//            for i in self.connections[currentAnimatingLayer - 1]{
//                i.strokeColor = .white
//            }
//        }else {
//            for i in self.connections.last!{
//                i.strokeColor = .white
//            }
//        }
//
//        if currentAnimatingLayer + 1 < self.connections.count {
//            currentAnimatingLayer += 1
//        } else {
//            currentAnimatingLayer = 0
//        }
//    })
//    }
//}
