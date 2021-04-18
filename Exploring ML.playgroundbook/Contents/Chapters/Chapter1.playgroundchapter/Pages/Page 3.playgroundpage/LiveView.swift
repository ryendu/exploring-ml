//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//
import Foundation
import PlaygroundSupport
import SwiftUI
import Views

struct WrapUpLiveView: View{
    let data = (1...200).map{$0 % 2 == 0 ? IdentifiableString(content:"👩‍💻"):IdentifiableString(content:"👨‍💻")}
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(data, id: \.id) { item in
                Text(item.content).font(.largeTitle)
            }
        }
        .padding(.horizontal)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                PlaygroundPage.current.assessmentStatus = .pass(message: "You have completed this playground! Congratulations 🎉!")
            })
        }
    }
}

PlaygroundPage.current.setLiveView(WrapUpLiveView())


