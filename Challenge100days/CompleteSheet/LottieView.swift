//
//  LottieView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/08/08.
//

import SwiftUI
import Lottie


///Lottieのアニメーションを表示するためのビュー
struct LottieView: UIViewRepresentable {
    
    let filename: String
    let loop: LottieLoopMode
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loop
        animationView.play()
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        // Nothing to update
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(filename: "confetti", loop: .playOnce)
            .frame(width: 200, height: 200)
    }
}
