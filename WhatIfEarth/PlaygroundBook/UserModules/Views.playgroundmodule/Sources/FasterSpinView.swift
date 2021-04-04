//
//  FasterSpinView.swift
//  BookCore
//
//  Created by Ryan D on 3/31/21.
//

import Foundation
import SwiftUI
import PlaygroundSupport
import Scenes

public struct FasterSpinView: View {
    private var spinRate: Double
    public init (spinRate: Double) {
        self.spinRate = spinRate
    }
    public var body: some View {
        VStack{
            FasterSpinInfoView(spinRate: spinRate).padding()
            EarthSpinningView(spinRate: spinRate)
            
        }
    }
}

private struct FasterSpinInfoView: View{
    var spinRate: Double
    init (spinRate: Double) {
        self.spinRate = spinRate
    }
    var body: some View {
        VStack{
            HStack{
                Text("Info Panel").font(.largeTitle).padding()
                Spacer()
            }
            Divider()
            HStack{
                if self.spinRate != 1{
                    Text("Weight of a 150 lb person at the equator: \(roundToHundreds(calculateWeightOnEquatorMinusCentrifigualForce(originalWeight: 68.0, spinRate: self.spinRate) * 2.2))lbs")
                }else {
                    Text("The weight of an 150 lbs: 150 lbs")
                }
                Spacer()
            }
            HStack{
                Text("Earth's rotational speed at the equator: \(roundToHundreds(1670 * spinRate)) kph / \(roundToHundreds(1038 * spinRate)) mph")
                Spacer()
            }
            HStack{
                Text("Length of a day: \(roundToHundreds(secondsToHours(seconds: lengthOfDay(spinRate: spinRate)))) hours")
                Spacer()
            }
            
            if self.spinRate > 1 {
                HStack{
                    Text("The centrifigual forces caused by Earth's new rotation will also cause stronger winds, cause earth to buldge a bit on the equator and pull more water from the poles to the equator, flooding most costal cities near the equator.").padding(.top)
                    Spacer()
                }
            }
        }
    }
}
func calculateWeightOnEquatorMinusCentrifigualForce(originalWeight: Double, spinRate:Double) -> Double {
    //F = mω^2 R cosθ
    let ω:Double = 2*3.14/(lengthOfDay(spinRate: spinRate))
    let radiusMeters = 6400000.0
    let F = originalWeight * (ω * ω) * radiusMeters
    var res = originalWeight - F
    if res < 0 {
        res = 0
    }
    return res
}

func lengthOfDay(spinRate:Double)->Double{
    return 86400 / spinRate
}

func secondsToHours(seconds:Double)->Double{
    return seconds / 3600
}

func roundToHundreds(_ value:Double)->String{
    return String(round(value * 100) / 100.0)
}

///Instantiates a new live view with Faster Spining Earth View
public func instantiateFasterSpinLiveView(spinRate: Double) -> FasterSpinView {
    let view = FasterSpinView(spinRate:spinRate)
    PlaygroundPage.current.setLiveView(view)
    return view
}
