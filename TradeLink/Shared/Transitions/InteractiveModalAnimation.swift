//
//  InteractiveModalAnimation.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-13.
//



import Foundation
import UIKit
class InteractiveModalPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /**
     Enum representing the possible transition styles
     */
    public enum TransitionStyle {
        case presentation
        case dismissal
    }

    // MARK: - Properties

    /**
     The transition style
     */
    private let transitionStyle: TransitionStyle
    
    
    required public init(transitionStyle: TransitionStyle) {
        self.transitionStyle = transitionStyle
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45
    }
    
    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
        
            else { return }

        let container = transitionContext.containerView
        // Calls viewWillAppear and viewWillDisappear
        fromVC.beginAppearanceTransition(false, animated: true)

        let panView:UIView = transitionContext.containerView.panContainerView ?? toVC.view
        panView.frame = transitionContext.finalFrame(for: toVC)
        panView.frame.origin.y = transitionContext.containerView.frame.height
        
        let blackOutView = UIView()
        blackOutView.backgroundColor = UIColor.black
        blackOutView.alpha = 0.0
        container.insertSubview(blackOutView, belowSubview: panView)
        blackOutView.constraintToSuperview(insets: .zero, ignoreSafeArea: true)
        
        let duration = transitionDuration(using: transitionContext)

        if let root = fromVC as? RootTabBarController {
            root.miniBar.isHidden = true
        }
        
//        UIView.animate(withDuration: duration * 0.3, delay: duration * 0.6, options: .curveLinear, animations: {
//            blackOutView.alpha = 1.0
//        }, completion: { didComplete in
//            
//        })

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            panView.frame.origin.y = 0
            
            if let detailVC = toVC as? InteractiveModalDelegate {
                detailVC.transitionDidUpdate(progress: 0.0)
            }
            
        }, completion: { didComplete in
            // Calls viewDidAppear and viewDidDisappear
            blackOutView.removeFromSuperview()
            fromVC.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
        })
    }
    
    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from)
            else { return }

        // Calls viewWillAppear and viewWillDisappear
        toVC.beginAppearanceTransition(true, animated: true)
        
        let container = transitionContext.containerView
        
        let duration = transitionDuration(using: transitionContext)
        let deviceInsets = UIApplication.deviceInsets
        
        let adjustment = MinibarView.height+49+deviceInsets.bottom+deviceInsets.top
        
        let panView: UIView = transitionContext.containerView.panContainerView ?? fromVC.view
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            panView.frame.origin.y = transitionContext.containerView.frame.height - (adjustment)//- (DetailViewController.headerHeight+49)
            if let detailVC = fromVC as? InteractiveModalDelegate {
                detailVC.transitionDidUpdate(progress: 1.0)
            }
        }, completion: { didComplete in
            if let root = toVC as? RootTabBarController {
                root.miniBar.isHidden = false
            }
            if let detailVC = fromVC as? InteractiveModalDelegate {
                detailVC.transitionDidUpdate(progress: 1.0)
            }
            fromVC.view.removeFromSuperview()
            // Calls viewDidAppear and viewDidDisappear
            toVC.endAppearanceTransition()
            transitionContext.completeTransition(didComplete)
        })
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        switch transitionStyle {
        case .presentation:
            animatePresentation(transitionContext: transitionContext)
        case .dismissal:
            animateDismissal(transitionContext: transitionContext)
        }
    }
    
}


