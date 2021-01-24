//
//  LoadingView.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-20.
//

import Foundation
import UIKit
import Lottie

class LoadingView:UIView {
    var animationView:AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let a = Animation.named("pixel_square_3")
                
        animationView = AnimationView(animation: a)
        
        self.addSubview(animationView)
        animationView.constraintToCenter(axis: [.x,.y])
        animationView.constraintWidth(to: 44)
        animationView.constraintHeight(to: 44)
        
        //animationView.tintColor = UIColor.white
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.alpha = 1.0
        animationView.play()
        
//
        /// A keypath that finds the color value for all `Fill 1` nodes.
        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        /// A Color Value provider that returns a reddish color.
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath)
        
        let fillKeypath2 = AnimationKeypath(keypath: "**.Stroke 1.Color")
        /// A Color Value provider that returns a reddish color.
        //let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath2)
    }
}
