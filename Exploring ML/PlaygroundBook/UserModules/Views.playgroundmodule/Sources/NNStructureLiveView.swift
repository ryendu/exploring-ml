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
    
    public var body: some View {
        GeometryReader{geo in
            ZStack{
                HStack{
                    AnimatedCaptionsView(captions: ["To understand how more complex forms of Neural Networks work, we first have to understand the most basic form of Neural networks, Deep Neural networks. On your right, you will see a model of a plain vanilla DNN with no toppings added 🍦. a DNN consists of multiple layers of neurons. The first layer and last layer are both respectively called the input and output layers. All the layers in between are called the hidden layers. Data gets passed sequentially in one direction from the input layer to the hidden layers, to the output layer.",
                                                    
                        "A neuron in ml is just a number from 0 - 1. Each neuron in each layer is connected to each neuron in the next layer. Each connection is also associated with a number called its weight ⚖️. The input layer's neurons are simply the input data that the model receives. The value of a neuron in a non-input layer can be determined by adding up ∑ all the neurons for the previous layer multiplied by its connection weights. The weights of a neuron's connections directly determine which neuron values from the previous layer are more important. This sum, plus a bias that shifts the overall value and is often crucial to the model's success determines how active the neuron is. This sum then gets squished into a number between 0 and 1 using an activation function.","wooww"], onScreenTime: [10.0,10.0,10.0])//.frame(width:130)
                    SpriteView(scene: scene)//.frame(width:450-captionWidth)
                }//.frame(width: geo.size.width,height: 350)
                if !self.started {
                    Rectangle().ignoresSafeArea().foregroundColor(.gray).opacity(0.5)
                    Button(action: {
                        DispatchQueue.main.async {
                            self.started.toggle()
                            NotificationCenter.default.post(name: .pressedStart, object: nil)
                        }
                    }, label: {
                        Text("Start").background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).frame(width: 60, height: 35, alignment: .center).shadow(radius: 10))
                        
                    })
                }
                
            }
        }
    }
}

extension Notification.Name {
    static var pressedStart: Notification.Name {
        return Notification.Name("pressedStart")
    }
}

public struct AnimatedCaptionsView: View{
    let captions: [String]
    let onScreenTime: [Double]
    @State var text = ""
    @State var toggle = true
    
    public init(captions:[String],onScreenTime:[Double]) {
        self.captions = captions
        self.onScreenTime = onScreenTime
    }
    public var body: some View{
        ZStack{
            Rectangle().ignoresSafeArea().foregroundColor(.black)
            VStack{
                Text(text)
                    .font(.callout)
                    .foregroundColor(.white)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("AnimatedCaptionsView"+text)
                
            }
        }.onReceive(NotificationCenter.default.publisher(for: .pressedStart)) {_ in
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.runLoop()
           }
        }
    }
    private func runLoop(){
        if captions.count > 0{
            self.text = captions[0]
            for i in 1...self.captions.count - 1{
                Timer.scheduledTimer(withTimeInterval: self.getTotalDisplacmentTime(index: i), repeats: false, block: { timer in
                    self.text = captions[i]
                })
            }
        }
    }
    
    private func getTotalDisplacmentTime(index:Int)->Double{
        var res = 0.0
        for i in 1...index{
            res += self.onScreenTime[i]
        }
        return Double(res)
    }
}

public func instantiateNNStructureLiveView() -> NNStructureLiveView {
    let view = NNStructureLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
