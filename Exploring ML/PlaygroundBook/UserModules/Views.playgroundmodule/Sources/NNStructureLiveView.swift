//
//  NNStructureLiveView.swift
//  Views
//
//  Created by Ryan D on 4/4/21.
//

import SwiftUI
import PlaygroundSupport
//import ML
import Scenes
import SpriteKit

public struct NNStructureLiveView: View {
    let captionWidth:CGFloat = 120
    
    public init () {}
    public var scene: SKScene {
        let scene = NNStructureScene(size:CGSize(width: 450, height: 350), layerShape:[724,14,14,10])
        scene.scaleMode = .aspectFit
        return scene
    }
    @State var started = false
    @State var timer: Timer!
    @State var animation = false
    public var body: some View {
        GeometryReader{geo in
            ZStack{
                VStack{
                    SpriteView(scene: scene).id("NNStructureLiveView")
                    AnimatedCaptionsView(captions: ["Right above, you will see a model of a plain vanilla Deep Neural Network with no toppings added 🍦. a DNN consists of multiple layers of neurons. The first layer and last layer are both respectively called the input and output layers. All the layers in between are called the hidden layers."," Data gets passed sequentially in one direction from the input layer to the hidden layers, to the output layer."," A neuron in ml is just a number from 0 - 1. Each neuron in each layer is connected to each neuron in the next layer. Each connection is also associated with a number called its weight ⚖️."," The input layer's neurons are simply the input data that the model receives. The value of a neuron in a non-input layer can be determined by adding up ∑ all the neurons for the previous layer multiplied by its connection weights."," This process is repeated for every neuron in every non-input layer. The last layer, aka the output layer, could consist of one neuron, indicating a yes or a no, multiple neurons each indicating the possibility of a different outcome, or just about anything else."," ML Models trains by tweaking 🎛 the weights and biases for each neuron and each connection until it has achieved a high accuracy at the given task."],
                        slideChangedCB: {slide in
                            //nnStructrueSceneAnimate
                            print("got slide: \(slide) in live view")
                            NotificationCenter.default.post(name: .nnStructrueSceneAnimate,object: slide)
                        }
                    ).frame(height:geo.size.height * 0.3)
                }//.frame(width: geo.size.width,height: 350)
                if !self.started {
                    Button(action: {
                        self.started = true
                        self.timer.invalidate()
                    }, label: {
                        ZStack{
                            BlurView(style: .light).ignoresSafeArea()
                            Text("Tap Anywhere to get started")
                                .foregroundColor(.black)
                                .font(.title)
                                .scaleEffect(CGSize(width: self.animation ? 1.1 : 1, height: self.animation ? 1.1 : 1))
                                .opacity(Double(self.animation ? 1 : 0.75))
                        }
                    })
                }
            }
            .onAppear{
                self.animation.toggle()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    self.timer = timer
                    withAnimation(.easeInOut(duration: 1)){
                        self.animation.toggle()
                    }
                }
            }
            .onDisappear{
                self.timer.invalidate()
            }
        }
    }
}



public func instantiateNNStructureLiveView() -> NNStructureLiveView {
    let view = NNStructureLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}

extension Notification.Name {

   static var nnStructrueSceneAnimate: Notification.Name {
       return Notification.Name("nnStructrueSceneAnimate")
   }
}
