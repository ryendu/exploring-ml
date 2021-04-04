//
//  NNStructureLiveView.swift
//  Views
//
//  Created by Ryan D on 4/4/21.
//

import SwiftUI
import PlaygroundSupport
import ML

public struct NNStructureLiveView: View {
    public init () {}
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NNStructureLiveView_Previews: PreviewProvider {
    static var previews: some View {
        NNStructureLiveView()
    }
}

public func instantiateNNStructureLiveView() -> NNStructureLiveView {
    let view = NNStructureLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
