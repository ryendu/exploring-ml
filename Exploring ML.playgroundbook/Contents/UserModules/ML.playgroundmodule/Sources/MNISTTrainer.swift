//
//  MNISTTrainer.swift
//  ML
//
//  Created by Ryan D on 4/13/21.
//

import Foundation
import CoreML
import UIKit
import DL4S

public class MNISTTrainer{
    let model = Sequential {
        Flatten<Float,CPU>()
        Dense<Float, CPU>(inputSize: 784, outputSize: 14)
        Relu<Float, CPU>()
        Dense<Float, CPU>(inputSize: 14, outputSize: 14)
        Relu<Float, CPU>()
        Dense<Float, CPU>(inputSize: 14, outputSize: 14)
        Relu<Float, CPU>()
        Dense<Float, CPU>(inputSize: 14, outputSize: 10)
        Softmax<Float, CPU>()
     }
    var x_train:Tensor<Float, CPU>
    var y_train:Tensor<Int32, CPU>
    var optimizer: Adam<Sequential<Sequential<Sequential<Sequential<Flatten<Float, CPU>, Dense<Float, CPU>>, Sequential<Relu<Float, CPU>, Dense<Float, CPU>>>, Sequential<Sequential<Relu<Float, CPU>, Dense<Float, CPU>>, Sequential<Relu<Float, CPU>, Dense<Float, CPU>>>>, Softmax<Float, CPU>>>
    public init (){
        //get dataset
        var x_train_:[[Float]]=[]
        var y_train_:[Int32]=[]
        for cate in 0...9{
            for i in 0...60{
                if let pthOfImg = Bundle.main.path(forResource: "mnisttrain_\(cate)_\(i)", ofType: "jpg", inDirectory: nil), let img = UIImage(contentsOfFile: pthOfImg),let cgim = img.cgImage,let tensor = Tensor<Float, CPU>(cgim) {
                    x_train_.append(tensor.elements)
                    y_train_.append(Int32(cate))
                }
            }
        }
        self.x_train = Tensor<Float, CPU>(x_train_)
        self.y_train = Tensor<Int32, CPU>(y_train_)
        self.optimizer = Adam(model: model, learningRate: 0.001)
        
    }
    ///train the model
    public func train(epochs:Int){
        for epoch in 1...epochs{
            let pred = optimizer.model(self.x_train)
            let loss = categoricalNegativeLogLikelihood(expected: self.y_train, actual: pred)
            let gradients = loss.gradients(of: optimizer.model.parameters)
            optimizer.update(along: gradients)
            print("EPOCH \(epoch) Finished with loss: \(loss)")
            //get weights
            NotificationCenter.default.post(name: .updateWeights,object: self.optimizer.model.parameters)
        }
    }
    ///simply make a prediction
    public func predict(input:CGImage) -> String?{
        let classes_ = [0,1,2,3,4,5,6,7,8,9]
        guard let x_ = Tensor<Float,CPU>(input) else {return "error parsing image"}
        let out = self.optimizer.model(x_)
        print("Softmax results: \(out.elements)")
        NotificationCenter.default.post(name: .updateOutputNeuronValues, object: out.elements)
        return "\(classes_[out.argmax()])"
    }
    ///make a prediction while sending notification center updates to the scene telling it to update its nn diagram with the neuron's activations that prediction func got
    public func predictWithAnimation(input:CGImage, gotPred:(String)->Void){}
}

public extension Notification.Name {
    static var nnStructrueSceneAnimate: Notification.Name {
        return Notification.Name("nnStructrueSceneAnimate")
    }
    static var updateWeights: Notification.Name {
        return Notification.Name("updateWeights")
    }
    static var updateOutputNeuronValues: Notification.Name {
        return Notification.Name("updateOutputNeuronValues")
    }
    static var updateInputNeuronValues: Notification.Name {
        return Notification.Name("updateInputNeuronValues")
    }
}
