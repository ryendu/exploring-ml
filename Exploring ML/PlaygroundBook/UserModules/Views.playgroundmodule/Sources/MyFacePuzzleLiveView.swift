//
//  MyFacePuzzleLiveView.swift
//  Views
//
//  Created by Ryan D on 4/4/21.
//

import Foundation
import SwiftUI
import PlaygroundSupport
import ML

public struct MyFacePuzzleLiveView: View {
    public init () {}
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MyFacePuzzleLiveView_Previews: PreviewProvider {
    static var previews: some View {
        RocketBoosterLandingLiveView()
    }
}

public func instantiateMyFacePuzzleLiveView() -> MyFacePuzzleLiveView {
    let view = MyFacePuzzleLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
