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
        Dense<Float, CPU>(inputSize: 724, outputSize: 14)
        Relu<Float, CPU>()
         Dense<Float, CPU>(inputSize: 14, outputSize: 14)

         Dense<Float, CPU>(inputSize: 14, outputSize: 14)
        Relu<Float, CPU>()
        Dense<Float, CPU>(inputSize: 14, outputSize: 10)
        LogSoftmax<Float, CPU>()
     }
    var x_train:Tensor<Float, CPU>
    var y_train:Tensor<Int32, CPU>
    public init (){
        //get dataset
        self.x_train = Tensor<Float,CPU>([1,2,3,4,5])
        self.y_train = Tensor<Int32,CPU>([1,2,3,4,5])
//        let documentsURL = Bundle.main.path(forResource: "img_13831", ofType: "jpg", inDirectory: "trainingSet/trainingSet/0")
//        let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "trainingSet/0")
//        let urls = Bundle(for: type(of: self)).path(forResource: "trainingSet", ofType: nil)
        let pth = Bundle.main.resourcePath! + "/PrivateResources/trainingSet/0"
        let urls = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: pth)
        print("SAMPLE IMAGE PTHs: \(urls)")
//        print("RESOURCE PATH is \(Bundle.main.resourcePath)")
//        let indxOfImgToShow = Int.random(in: 0...(documentsURL.count - 1))
//        if let inputImageToShow = UIImage(contentsOfFile: documentsURL[indxOfImgToShow]) {
//
//        }
    }
    func getDataset(){
        // Single iteration of minibatch gradient descent
//        let batch: Tensor<Float, CPU> = ... // shape: [batchSize, 1, 28, 28]
//        let y_true: Tensor<Int32, CPU> = ... // shape: [batchSize]
    }
    ///train the model
    public func train(epochs:Int){
        var optimizer = Adam(model: model, learningRate: 0.001)
        for epoch in 1...epochs{
            //            use optimizer.model, not model
            let pred = optimizer.model(self.x_train)
            for i in self.model.parameters{
                print(i.count)
            }
            let loss = categoricalNegativeLogLikelihood(expected: self.y_train, actual: pred)
            let gradients = loss.gradients(of: optimizer.model.parameters)
            optimizer.update(along: gradients)
            print("EPOCH \(epoch) Finished!!")
        }
    }
    ///simply make a prediction
//    public func predict(input:CGImage) -> String?{
//        let output = try? model.prediction(input: mnistmodelInput(input_1With: input))
//        return output?.classLabel ?? "uhoh something went wrong"
//    }
    ///make a prediction while sending notification center updates to the scene telling it to update its nn diagram with the neuron's activations that prediction func got
    public func predictWithAnimation(input:CGImage, gotPred:(String)->Void){}
}
