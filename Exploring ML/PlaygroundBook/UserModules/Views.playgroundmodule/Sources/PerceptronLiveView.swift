//
//  AIRuleSocietyView.swift
//  Views
//
//  Created by Ryan D on 4/3/21.
//

import SwiftUI
import PlaygroundSupport
import ML

public struct PerceptronLiveView: View {
    public init () {}
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PerceptronLiveView_Previews: PreviewProvider {
    static var previews: some View {
        PerceptronLiveView()
    }
}

public func instantiatePerceptronLiveView() -> PerceptronLiveView {
    let view = PerceptronLiveView()
    PlaygroundPage.current.setLiveView(view)
    return view
}
