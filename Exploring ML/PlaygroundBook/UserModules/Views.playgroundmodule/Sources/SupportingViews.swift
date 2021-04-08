//
//  SupportingViews.swift
//  Views
//
//  Created by Ryan D on 4/7/21.
//

import Foundation
import SwiftUI




public struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style
    
    public init (style: UIBlurEffect.Style){
        self.style = style
    }

    public func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    public func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }

}

public struct AnimatedCaptionsView: View{
    let captions: [String]
    @State var text = ""
    @State var toggle = true
    @State var count = 0
    let slideChangedCB: (Int)->()
    public init(captions:[String],slideChangedCB: @escaping (Int)->()) {
        self.captions = captions
        self.slideChangedCB = slideChangedCB
    }
    @State var timer: Timer!
    @State var animation = false
    public var body: some View{
        ZStack{
            Rectangle().ignoresSafeArea().foregroundColor(.black)
            VStack{
                HStack{
                    Button(action: {
                        if self.count - 1 >= 0 {
                            self.count -= 1
                            self.text = captions[count]
                            slideChangedCB(self.count)
                        }
                    }, label: {
                        Image(systemName: "arrow.backward.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.white)
                    })
                    Spacer()
                    
                    Text("Tap Anywhere down here for Next")
                    
                    Spacer()
                    
                    Button(action: {
                        if self.count + 1 < self.captions.count {
                            self.count += 1
                            self.text = captions[count]
                            slideChangedCB(self.count)
                        }
                    }, label: {
                        Image(systemName: "arrow.forward.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.white)
                    }).scaleEffect(CGSize(width: self.animation ? 1.5 : 1, height: self.animation ? 1.5 : 1)).opacity(Double(self.animation ? 1 : 0.75))
                }
                Spacer()
                Text(text)
                    .font(.custom("OpenSans-Light", fixedSize: 20))
                    .foregroundColor(.white)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:0.7)))
                    .id("AnimatedCaptionsView"+text)
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
        }
        .onAppear{
            let fontURL = Bundle.main.url(forResource: "OpenSans-Light", withExtension: "ttf")
            CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
            let oslFont = UIFont(name: "OpenSans-Light", size: 20)!
            self.text = captions[0]
            self.slideChangedCB(self.count)
            
            self.animation.toggle()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.timer = timer
                withAnimation(.easeInOut(duration: 1)){
                    self.animation.toggle()
                }
            }
        }
        .onTapGesture {
            if self.count + 1 < self.captions.count {
                self.count += 1
                self.text = captions[count]
                slideChangedCB(self.count)
            }
        }
        
    }
}
