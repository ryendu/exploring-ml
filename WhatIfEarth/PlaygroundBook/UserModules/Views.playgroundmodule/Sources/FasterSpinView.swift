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
                Text("Info Panel").font(.headline).padding()
                Spacer()
            }
            Divider()
            HStack{
                Text("The weight of an 150 lb person at the equator: \(15)lb")
                Spacer()
            }
            HStack{
                Text("Earth's rotational speed at the equator: \(15)")
                Spacer()
            }
            HStack{
                Text("Length of a day: \(15)")
                Spacer
            }
                // The weight of an 150 lb person
                // earth's speed at the equator
                // Length of a day
            if self.spinRate > 1 {
                HStack{
                    Text("Earth's rotation will cause more wind and hurricanes and cyclones and more water at the equator ")
                }
            }
        }
    }
}

///Instantiates a live view with any view
public func instantiateFasterSpinLiveView(spinRate: Double) -> FasterSpinView {
    let view = FasterSpinView(spinRate:spinRate)
    PlaygroundPage.current.setLiveView(view)
    return view
}
