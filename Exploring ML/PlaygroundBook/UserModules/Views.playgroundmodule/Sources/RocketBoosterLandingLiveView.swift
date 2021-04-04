//
//  RocketBoosterLandingLiveView.swift
//  Views
//
//  Created by Ryan D on 4/4/21.
//

import SwiftUI
import PlaygroundSupport
import ML

public struct RocketBoosterLandingLiveView: View {
    public init () {}
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RocketBoosterLandingLiveView_Previews: PreviewProvider {
    static var previews: some View {
        RocketBoosterLandingLiveView()
    }
}

public func instantiaterocketBoosterLandingLiveView() -> RocketBoosterLandingLiveView {
    let view = RocketBoosterLandingLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
