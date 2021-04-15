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
    let captionWidth:CGFloat = 120
    
    public init () {}
    public var scene: SKScene {
        let scene = NNStructureScene(size:CGSize(width: 450, height: 350), layerShape:[724,14,14,10],initialSlide:self.slide)
        scene.scaleMode = .aspectFit
        return scene
    }
    @State var started = false
    @State var timer: Timer?
    @State var animation = false
    @State var slide: Int = 0
    public var body: some View {
        GeometryReader{geo in
            ZStack{
                VStack{
                    HStack{
                        MNISTHelperSideBarView(slide: self.$slide).frame(width: geo.size.width * 0.3)
                        SpriteView(scene: scene).id("NNStructureLiveView")
                    }
                    AnimatedCaptionsView(captions: ["Right above, you will see a model of a plain vanilla Deep Neural Network with no toppings added 🍦. a DNN consists of multiple layers of neurons. The first layer and last layer are both respectively called the input and output layers. All the layers in between are called the hidden layers."," Data gets passed sequentially in one direction from the input layer to the hidden layers, to the output layer."," A neuron in ml is just a number from 0 - 1 (Neurons are denoted by circles in). Each neuron in each layer is connected to each neuron in the next layer. Each connection is also associated with a number called its weight ⚖️."," The input layer's neurons are simply the input data that the model receives. The value of a neuron in a non-input layer can be determined by adding up ∑ all the neurons for the previous layer multiplied by its connection weights."," The weights of a neuron's connections directly determine which neuron values from the previous layer are more important. This sum, plus a bias that shifts the overall value and is often crucial to the model's success determines how active the neuron is. This sum then gets squished into a number between 0 and 1 using the sigmoid function σ."," This process is repeated for every neuron in every non-input layer. The last layer, aka the output layer, could consist of one neuron indicating a yes or a no, multiple neurons each indicating the possibility of a different outcome, one neuron indicating a number, or just about anything else."," ML Models trains by tweaking 🎛 the weights and biases for each neuron and each connection until it has achieved a high accuracy at the given task.","The Neural Network you see now is pre-trained on the MNIST dataset, a classic handwritten number classification dataset that contains 10 classes/categories, the images of handwritten numbers 0 - 9. The images are 28 pixels by 28 pixels, totaling 784 pixels corresponding to each neuron in the input layer.","The number of hidden layers and the number of their neurons are randomly chosen as most combinations work well for MNIST.","The output layer consists of 10 Neurons corresponding to the 10 classes. The Neuron that is brightest in the output layer will be the model's prediction.","Watch the Model do its thing in action!", "Draw a number in the designated box, hit predict, and see the neural network predict on what you drew!"],
                        slideChangedCB: {slide in
                            //nnStructrueSceneAnimate
                            print("got slide: \(slide) in live view")
                            self.slide = slide
                            NotificationCenter.default.post(name: .nnStructrueSceneAnimate,object: slide)
                        }
                    ).frame(height:geo.size.height * 0.3)
                }//.frame(width: geo.size.width,height: 350)
                if !self.started {
                    Button(action: {
                        self.started = true
                        self.timer?.invalidate()
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
                self.timer?.invalidate()
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

private struct MNISTHelperSideBarView: View{
    @Binding var slide: Int
    @State var xImage: UIImage? = nil
    let trainer = MNISTTrainer()
    @State var prediction = ""
    var body: some View{
        if slide >= 7{
            GeometryReader{geo in
                NavigationView{
                VStack{
                    if self.xImage != nil{
                        Image(uiImage: self.xImage!)
                                .antialiased(false)
                                .resizable()
                                .border(Color.white, width: 1)
                                .frame(width: getXImageLength(geo:geo), height: getXImageLength(geo:geo), alignment: .center)
                                .padding()
                        Text(self.prediction).padding()
                    }
                    
                            
                    Spacer()
                    if slide >= 7 && self.xImage != nil{
                        Button(action: {
//                            if let img = self.xImage?.cgImage, let pred = self.trainer.predict(input: img){
//                                self.prediction = "Prediction: \(pred)"
//                            }
                        }, label: {
                            Text("Predict")
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.black).padding()).padding()
                        })
                        Button(action: {
//                            if let img = self.xImage?.cgImage, let pred = self.trainer.predict(input: img){
//                                self.prediction = "Prediction: \(pred)"
//                            }
                            trainer.train(epochs: 10)
                        }, label: {
                            Text("Train")
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.black).padding()).padding()
                        })
                    }
                    if slide >= 7 {
                        Button(action: {
                            getRandomXImage()
                        }, label: {
                            Text("Get New Input Image")
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.black).padding()).padding()
                        })
                    }
                }.navigationTitle("Input Image")
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
            }
            .onAppear{
                getRandomXImage()
            }
        }
    }
    func getRandomXImage(){
        let documentsURL = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: nil)
        if documentsURL.count > 1{
            let indxOfImgToShow = Int.random(in: 0...(documentsURL.count - 1))
            if let inputImageToShow = UIImage(contentsOfFile: documentsURL[indxOfImgToShow]) {
                self.xImage = inputImageToShow
                print("mnist sample image pth: \(documentsURL[indxOfImgToShow])")
            }
        }
    }
    func getXImageLength(geo:GeometryProxy)->CGFloat{
        let widthIsGreaterThanSize = geo.size.width > geo.size.height
        return widthIsGreaterThanSize ? geo.size.height * 0.4 : geo.size.width * 0.4
    }
}
