//
//  NNStructureScene.swift
//  Scenes
//
//  Created by Ryan D on 4/5/21.
//

import Foundation
import SpriteKit
import PlaygroundSupport
import DL4S
import ML

public class NNStructureScene: SKScene{
    var initialSlide: Int
    var layers:[[SKShapeNode]] = []
    var connections: [[SKShapeNode]] = []
    var animationNodes:[SKNode] = []
    var animatedConnections: [[SKShapeNode]] = []
    var ellipsis: [SKShapeNode] = []
    var layersShape:[Int]
    let spacing = 19
    let neuronDiameter = 10
    let verticalPadding:CGFloat = 80
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
    
    //equation
    var equationNodes: [SKNode] = []
    var equationImgNode: SKSpriteNode? = nil
    
    var maxLayerLen: Int!
    var maxN: Int!
    var shiftedDown: Bool = false
    
    //mnist
    var outputLabelNodes: [SKLabelNode] = []

    var showDataFlowANimationTimer: Timer? = nil
    var showTweakWeightsAnimationTimer: Timer? = nil
    
    public init(size:CGSize,layerShape:[Int], initialSlide:Int) {
        self.layersShape = layerShape
        self.initialSlide = initialSlide
        super.init(size: size)
    }
    
    public required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:)? Boo don't initialize this way.")
    }
    
    public override func didMove(to view: SKView) {
        print("LOADED")
        //spawn all the neurons
        let maxLayerLen = Int(self.size.height-verticalPadding)
        let maxN = Int(Double(maxLayerLen/spacing).rounded(.down))
        self.maxLayerLen = maxLayerLen
        self.maxN = maxN
        
        self.backgroundColor = .black
        for layerIndex in 0...layersShape.count-1{
            var tmpLayer: [SKShapeNode] = []
            //initialize some variables
            
            let layerActualLen = Int(layersShape[layerIndex]) * spacing
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
                nd.fillColor = .black
                nd.strokeColor = .white
                tmpLayer.append(nd)
                self.addChild(nd)
            }
            layers.append(tmpLayer)
            //time to add ellipsis if some neurons don't fit on screen
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateWeights),
            name: .updateWeights,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateOutputNeurons),
            name: .updateOutputNeuronValues,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateInputNeurons),
            name: .updateInputNeuronValues,
            object: nil)
        //updateOutputNeuronValues
        dispatchAnimation(slide: self.initialSlide)
    }
    
    @objc func carryoutAnimation(notification: NSNotification){
        guard let action = notification.object as? Int else {return}
        dispatchAnimation(slide: action)
    }
    @objc func updateWeights(notification: NSNotification){
        guard let params = notification.object as? [Tensor<Float,CPU>] else {return}
        let _i_t_1 = params[0]
        let _1_t_2 = params[2]
        let _2_t_3 = params[4]
        for i in 0...connections[0].count - 1{
            connections[0][i].run(SKAction.strokeColorTransition(to: floatToGrayscaleUIColor(_i_t_1.elements[i])))
        }
        for i in 0...connections[1].count - 1{
            connections[1][i].run(SKAction.strokeColorTransition(to: floatToGrayscaleUIColor(_1_t_2.elements[i])))
        }
        for i in 0...connections[2].count - 1{
            connections[2][i].run(SKAction.strokeColorTransition(to: floatToGrayscaleUIColor(_2_t_3.elements[i])))
        }
    }
    
    @objc func updateOutputNeurons(notification: NSNotification){
        guard let outNeurons = notification.object as? [Float] else {return}
        guard let lastLayer = self.layers.last else {return}
        for i in 0...lastLayer.count - 1{
            lastLayer[i].run(SKAction.fillColorTransition(to: floatToGrayscaleUIColor(outNeurons[i])))
        }
    }
    
    @objc func updateInputNeurons(notification: NSNotification){
        guard let img = notification.object as? UIImage else {return}
        guard let tensor = Tensor<Float,CPU>(img) else {return}
        guard let firstLayer = self.layers.first else {return}
        for i in 0...firstLayer.count - 1{
            firstLayer[i].run(SKAction.fillColorTransition(to: floatToGrayscaleUIColor(tensor.elements[i+300])))
        }
    }
    
    func floatToGrayscaleUIColor(_ float: Float)->UIColor{
        let color = UIColor(white: CGFloat(float), alpha: 100)
        return color
    }
    func dispatchAnimation(slide: Int){
        switch slide {
        case 0:
            self.noToppingsAnimation()
        case 1:
            self.showDataFlowAnimation()
        case 2:
            self.showConnectionsAnimation()
        case 3:
            self.showCalculateNeuronEquation()
        case 4:
            self.showAddBiasAndActivationFunctionToEquation()
        case 5:
            self.showSlowlyFeedForwardIndividually()
        case 6:
            self.showTweakWeightsChangeWeightColorAnimation()
        case 7:
            print("no animation for this one, its done on swiftui!")
        case 8:
            print("no animation for this one :(")
        case 9:
            self.addOutputLabels()
        case 10:
            self.animateAndRunMNIST()
        case 11:
            print("")
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
                        line.isAntialiased = true
                        line.lineWidth = 0.8
                        line.alpha = 1
                        tmpConnections.append(line)
                        self.addChild(line)
                    }
                }
            }
            connections.append(tmpConnections)
        }
    }
    
    ///finds the distance between two nodes
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
        
        let niceRatio = Double(self.verticalPadding) / 60
        var distanceInLayerStart = Double(Double(spacing) * ((Double(maxN)) / 2.0 - niceRatio))
        distanceInLayerStart = distanceInLayerStart + Double(neuronDiameter) + Double(extraPaddingEach) + Double(self.verticalPadding)
        //where the ellipsis ends on the y axis.
        var distanceInLayerEnd = Double(Double(spacing) * ((Double(maxN)) / 2.0 - niceRatio))
        
        distanceInLayerEnd = distanceInLayerEnd - Double(neuronDiameter) - Double(extraPaddingEach) + Double(self.verticalPadding)
        let ellipsisAllocatedTotalSpaceY = distanceInLayerEnd - distanceInLayerStart
        
        //initializes ellipsis
        let ellipsisPart1 = SKShapeNode(ellipseOf: CGSize(width: 1.5, height: 1.5))
        ellipsisPart1.fillColor = .white
        ellipsisPart1.position = CGPoint(x: Double(x), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 1)))
        
        let ellipsisPart2 = SKShapeNode(ellipseOf: CGSize(width: 1.5, height: 1.5))
        ellipsisPart2.fillColor = .white
        ellipsisPart2.position = CGPoint(x: Double(x), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 2)))
        
        let ellipsisPart3 = SKShapeNode(ellipseOf: CGSize(width: 1.5, height: 1.5))
        ellipsisPart3.fillColor = .white
        ellipsisPart3.position = CGPoint(x: Double(x), y: Double(distanceInLayerStart + (ellipsisAllocatedTotalSpaceY / 3 * 3)))
        
        self.ellipsis.append(ellipsisPart3)
        self.ellipsis.append(ellipsisPart2)
        self.ellipsis.append(ellipsisPart1)
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
                strokeLengthFloat += 0.025
            }
        }
    }
    
    func getRandomGrayscaleColor()->UIColor{
        let random = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let color = UIColor(white: random, alpha: 1)
        return color
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
        if showTweakWeightsAnimationTimer != nil{
            showTweakWeightsAnimationTimer!.invalidate()
        }
        //make all neurons gray again
        for il in layers{
            for i in il{
                i.fillColor = .black
            }
        }
        self.removeChildren(in: self.outputLabelNodes)
        for layer in self.connections{
            for i in layer{
                i.strokeColor = .white
            }
        }
        updateStrokeLengthFloat = false
        
        for il in animatedConnections{
            self.removeChildren(in: il)
        }
        self.removeChildren(in: self.equationNodes)
        
        if self.shiftedDown{
            for i in self.children{
                i.run(SKAction.moveBy(x: 0, y: 10, duration: 1))
            }
            self.shiftedDown = false
        }
        
        //for the cases where coloring of things are delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.81, execute: {
            for il in self.layers{
                for i in il{
                    i.fillColor = .black
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.11, execute: {
            for layer in self.connections{
                for i in layer{
                    i.strokeColor = .white
                }
            }
        })
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
                
                if !(i.fillColor == UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1) ){
                    i.fillColor = .black
                }else {
                    print("Whiting")
                    i.fillColor = .white
                    
                }
            }
            if currentAnimatingLayer != 0 {
                for i in self.layers[currentAnimatingLayer - 1]{
                    i.fillColor = .black
                }
            }else {
                for i in self.layers.last!{
                    i.fillColor = .black
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
    
    ///shows the model feeding forward its values. only neuron btw
    func showNeuronsPassingDataAnimation(){
        self.endAllAnimations()
        var currentAnimatingLayer = 0
        if self.layers.count > 0{
            showDataFlowANimationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { val in
            for i in self.layers[currentAnimatingLayer]{
                
                if !(i.fillColor == UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1) ){
                    i.fillColor = .black
                    
                }else {
                    print("Whiting")
                    i.fillColor = self.getRandomGrayscaleColor()
                    
                }
            }
            if currentAnimatingLayer != 0 {
                for i in self.layers[currentAnimatingLayer - 1]{
                    i.fillColor = .black
                }
            }else {
                for i in self.layers.last!{
                    i.fillColor = .black
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
                    for il in animatedConnections{
                        self.removeChildren(in: il)
                    }
                }
//                if let i = self.connections.first?.first{
                self.strokeLengthKey = "u_current_percentage"
                strokeLengthUniform = SKUniform( name: self.strokeLengthKey, float: 0.0 )
                let uniforms: [SKUniform] = [self.strokeLengthUniform]
                self.strokeShader = shaderWithFilename( "animateStroke", fileExtension: "fsh", uniforms: uniforms )
                updateStrokeLengthFloat = true
                strokeLengthFloat = 0.0
                var tmpConnections: [SKShapeNode] = []
                let li = currentAnimatingLayer
                for node1i in 0...self.layers[li].count - 1{
                    if self.connections[li].count > 0{
//                        self.removeChildren(in: [self.animatedConnections[li][node1i]])
                        let node1 = self.layers[li][node1i]
                        if li < layers.count - 1{
                            for node2 in layers[li + 1]{
                                // Create line with SKShapeNode
                                let line = SKShapeNode()
                                let path = UIBezierPath()
                                path.move(to: CGPoint(x: CGFloat(node1.position.x + CGFloat(neuronDiameter/2)+1), y: CGFloat(node1.position.y)))
                                path.addLine(to: CGPoint(x: CGFloat(node2.position.x - CGFloat(neuronDiameter/2)-1), y: CGFloat(node2.position.y)))
                                line.path = path.cgPath
                                line.lineWidth = 0.3
                                line.isAntialiased = false
                                line.alpha = 1
                                self.addChild(line)
                                tmpConnections.append(line)
                                line.strokeShader = strokeShader
                                self.connections[li][node1i].calculateAccumulatedFrame()
                            }
                        }
                    }
                }
                self.animatedConnections.append(tmpConnections)
                if currentAnimatingLayer + 1 < self.layers.count {
                    currentAnimatingLayer += 1
                } else {
                    currentAnimatingLayer = 0
                }
            })
        }
    }
    
    func shiftAllDown(){
        self.shiftedDown = true
        for i in self.children{
            i.run(SKAction.moveBy(x: 0, y: -10, duration: 1))
        }
    }
    
    ///show the equation to calcaulate a non-input neuron's value
    func showCalculateNeuronEquation(){
        self.endAllAnimations()
        // first shrink the nn a bit
        shiftAllDown()
        // copy the first node of the second layer plus all nodes from first layer, then move and transform to equation
        guard let firstNeuronLayer = self.layers.first else { return }
        guard let secondLayerFirstNeuron = self.layers[1].last else { return }
        guard let firstLayerLastNeuron = firstNeuronLayer.last else {return}
        let y = self.size.height - (verticalPadding / 2)
        let xShift:CGFloat = 80
        var inodes: [SKShapeNode] = []
        //the inputs to be added together, are equation components
        if !(firstNeuronLayer.count > 3) {
            fatalError("Ay ay, i'm sorry but please make sure you have atleast 3 neurons for the first layer : (.")
        }
        //last 3 neurons before elipsis
        for indx in firstNeuronLayer.count / 2 - 1 - 3...firstNeuronLayer.count / 2 - 1{
            let i = firstNeuronLayer[indx]
            let nd = SKShapeNode(ellipseOf: CGSize(width: neuronDiameter, height: neuronDiameter))
            nd.position = CGPoint(x: i.position.x, y: i.position.y)
            nd.fillColor = .white
            self.addChild(nd)
            inodes.append(nd)
            self.equationNodes.append(nd)
            nd.run(SKAction.moveTo(y: y, duration: 1.5))
            nd.run(SKAction.moveTo(x: nd.position.y + xShift, duration: 1.5))
            nd.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 1)]))
        }
        
        //color code the input layer neurons
        for i in firstNeuronLayer{
            i.fillColor = .white
        }
//add more stuff
        
        let firstLindx:Int = maxN / 2 + 2
        let notUsedNeuronsDistance = (firstLayerLastNeuron.position.y + xShift) - (firstNeuronLayer[firstLindx].position.y + xShift)
        print("Not used neuron distance: \(notUsedNeuronsDistance)")
        //add what we are finding
        let res = SKShapeNode(ellipseOf: CGSize(width: neuronDiameter, height: neuronDiameter))
        res.position = CGPoint(x: secondLayerFirstNeuron.position.x, y: secondLayerFirstNeuron.position.y)
        secondLayerFirstNeuron.fillColor = .blue
        res.fillColor = .blue
        self.addChild(res)
        self.equationNodes.append(res)
        res.run(SKAction.moveTo(y: y, duration: 1.5))
        res.run(SKAction.moveTo(x: res.position.y + xShift + CGFloat(self.spacing*2) - notUsedNeuronsDistance, duration: 1.5))
        
        //add equal sign
        let equalSign = SKLabelNode(text:"=")
        equalSign.fontSize = 15
        equalSign.position = CGPoint(x: secondLayerFirstNeuron.position.x, y: secondLayerFirstNeuron.position.y)
        equalSign.color = .white
        self.addChild(equalSign)
        self.equationNodes.append(equalSign)
        equalSign.run(SKAction.moveTo(y: y - 5, duration: 1.5))
        equalSign.run(SKAction.moveTo(x: res.position.y + xShift + CGFloat(self.spacing) - notUsedNeuronsDistance, duration: 1.5))
        
        
        //add equation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.9, execute: {
            let nd = SKSpriteNode(imageNamed: "weightedsum")
            nd.position = CGPoint(x: res.position.x - CGFloat(self.spacing * 9), y: res.position.y )
            nd.setScale(0.5)
            self.addChild(nd)
            self.equationNodes.append(nd)
            self.equationImgNode = nd
        })
        
        
    }
    
    ///adds bias and activation func to the equation
    func showAddBiasAndActivationFunctionToEquation(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.91, execute: {
            guard let ein = self.equationImgNode else {
                self.showCalculateNeuronEquation()
                self.showAddBiasAndActivationFunctionToEquation()
                return
            }
            let equationFullTexture = SKTexture(imageNamed: "weightedSumPlusBiasAndActivation")
            ein.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.setTexture(equationFullTexture),SKAction.scale(by: 1.2, duration: 1),SKAction.moveBy(x: CGFloat(self.spacing), y: 0, duration: 1)]))
        })
    }
    
    ///animates the network calculating every individual neuron
    func showSlowlyFeedForwardIndividually(){
        self.endAllAnimations()
        var currentAnimatingLayer = 0
        var node2i = 0
        if self.layers.count > 0{
            showDataFlowANimationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] val in
                if currentAnimatingLayer == 0{
                    for i in self.layers[currentAnimatingLayer]{
                        
                        if !(i.fillColor == UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1) ){
//                            i.fillColor = .black
                        }else {
                            i.fillColor = self.getRandomGrayscaleColor()
                        }
                    }
                }
                //if not last layer, then animate each neuron thing
                if currentAnimatingLayer < self.layers.count - 1 {
                    self.strokeLengthKey = "u_current_percentage"
                    strokeLengthUniform = SKUniform( name: self.strokeLengthKey, float: 0.0 )
                    let uniforms: [SKUniform] = [self.strokeLengthUniform]
                    self.strokeShader = shaderWithFilename( "animateStroke", fileExtension: "fsh", uniforms: uniforms )
                    updateStrokeLengthFloat = true
                    strokeLengthFloat = 0.0
                    var tmpConnections: [SKShapeNode] = []
                    let li = currentAnimatingLayer
                    let node2Count = layers[li + 1].count
                    let node2 = layers[li+1][node2i]
                        for conlayer in self.animatedConnections{
                            self.removeChildren(in: conlayer)
                        }
                    if self.connections[li].count > 0{
                        if li < layers.count - 1{
                            for node1i in 0...self.layers[li].count - 1{
                                let node1 = self.layers[li][node1i]
                                // Create line with SKShapeNode
                                let line = SKShapeNode()
                                let path = UIBezierPath()
                                path.move(to: CGPoint(x: CGFloat(node1.position.x + CGFloat(neuronDiameter/2)+1), y: CGFloat(node1.position.y)))
                                path.addLine(to: CGPoint(x: CGFloat(node2.position.x - CGFloat(neuronDiameter/2)-1), y: CGFloat(node2.position.y)))
                                line.path = path.cgPath
                                line.lineWidth = 1
                                line.isAntialiased = true
                                line.alpha = 1
                                self.addChild(line)
                                tmpConnections.append(line)
                                line.strokeShader = strokeShader
                                self.connections[li][node1i].calculateAccumulatedFrame()
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                            node2.fillColor = getRandomGrayscaleColor()
                        })
                    }
                    self.animatedConnections.append(tmpConnections)
                    if (node2i < node2Count - 1) {
                        node2i += 1
                    }else {
                        node2i = 0
                        currentAnimatingLayer += 1
                    }
                } else {
                    node2i = 0
                    currentAnimatingLayer = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        for il in layers{
                            for i in il{
                                i.fillColor = .black
                            }
                        }
                    })
                }
        })
        }
    }
    
    ///shows the changing of the color of connections indicating tweaking weights
    func showTweakWeightsChangeWeightColorAnimation(){
        self.endAllAnimations()
        showTweakWeightsAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            for layer in self.connections{
                for i in layer{
                    i.run(SKAction.strokeColorTransition(to: self.getRandomGrayscaleColor()))
                }
            }
        })
    }
    
    
    ///adds labels to each of the output neurons 0 - 9
    func addOutputLabels(){
        guard let lastNeuronLayer = self.layers.last else { return }
        for i in 0...lastNeuronLayer.count - 1{
            let neuron = lastNeuronLayer[i]
            let label = SKLabelNode(text: "\(i)")
            label.fontSize = 10
            label.position = CGPoint(x: neuron.position.x + 10, y: neuron.position.y - 3)
            self.addChild(label)
            self.outputLabelNodes.append((label))
        }
    }
    
    ///shows the neural network predicting MNIST in action.
    func animateAndRunMNIST(){
        self.endAllAnimations()
        self.addOutputLabels()
    }
    
    ///let the user draw a number from 1-0 and show the model working to predict
    func letUserTestMNIST(){
        //dunno
    }
}


public func shaderWithFilename( _ filename: String?, fileExtension: String?, uniforms: [SKUniform] ) -> SKShader {
        let path = Bundle.main.path( forResource: filename, ofType: fileExtension )
        let source = try! NSString( contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue )
        let shader = SKShader( source: source as String, uniforms: uniforms )
        return shader
}


func linearInterpolation(a: CGFloat, b: CGFloat, frac : CGFloat) -> CGFloat{
    return (b-a) * frac + a
}

struct ColorComponents {
    var red = CGFloat(0)
    var green = CGFloat(0)
    var blue = CGFloat(0)
    var alpha = CGFloat(0)
}

extension UIColor {
    func toComponents() -> ColorComponents {
        var components = ColorComponents()
        getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
        return components
    }
}

extension SKAction {
    static func strokeColorTransition(to: UIColor, duration: Double = 1) -> SKAction{
        return SKAction.customAction(withDuration: duration, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
            guard let node = node as? SKShapeNode else { fatalError("storkeColorTransition is only available for SKShapeNode")}
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let startColorComponents = node.strokeColor.toComponents()
            let endColorComponents = to.toComponents()
            let transColor = UIColor(red: linearInterpolation(a: startColorComponents.red, b: endColorComponents.red, frac: fraction),
                                     green: linearInterpolation(a: startColorComponents.green, b: endColorComponents.green, frac: fraction),
                                     blue: linearInterpolation(a: startColorComponents.blue, b: endColorComponents.blue, frac: fraction),
                                     alpha: linearInterpolation(a: startColorComponents.alpha, b: endColorComponents.alpha, frac: fraction))
            node.strokeColor = transColor
        }
        )
    }
    static func fillColorTransition(to: UIColor, duration: Double = 0.4) -> SKAction{
        return SKAction.customAction(withDuration: duration, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
            guard let node = node as? SKShapeNode else { fatalError("storkeColorTransition is only available for SKShapeNode")}
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let startColorComponents = node.fillColor.toComponents()
            let endColorComponents = to.toComponents()
            let transColor = UIColor(red: linearInterpolation(a: startColorComponents.red, b: endColorComponents.red, frac: fraction),
                                     green: linearInterpolation(a: startColorComponents.green, b: endColorComponents.green, frac: fraction),
                                     blue: linearInterpolation(a: startColorComponents.blue, b: endColorComponents.blue, frac: fraction),
                                     alpha: linearInterpolation(a: startColorComponents.alpha, b: endColorComponents.alpha, frac: fraction))
            node.fillColor = transColor
        }
        )
    }
}

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let shapeNode = SKShapeNode(rectOf: self.size)
            shapeNode.fillColor = .clear
            shapeNode.strokeColor = color
            shapeNode.lineWidth = width
            self.addChild(shapeNode)
        })
    }
}
