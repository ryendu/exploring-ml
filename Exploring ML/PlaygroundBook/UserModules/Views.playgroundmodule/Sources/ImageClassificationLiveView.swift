//
//  ImageClassificationLiveView.swift
//  Views
//
//  Created by Ryan D on 4/4/21.
//

import SwiftUI
import PlaygroundSupport
import ML

public struct ImageClassificationLiveView: View {
    public init () {}
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ImageClassificationLiveView_Previews: PreviewProvider {
    static var previews: some View {
        ImageClassificationLiveView()
    }
}

public func instantiateimageClassificationLiveView() -> ImageClassificationLiveView {
    let view = ImageClassificationLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
