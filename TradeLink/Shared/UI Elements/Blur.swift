//
//  Blur.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-11.
//

import Foundation
import UIKit
import SwiftUI


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
