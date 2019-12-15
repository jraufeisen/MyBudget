//
//  ScaleTransition.swift
//  MyBudget
//
//  Created by Johannes on 15.12.19.
//  Copyright © 2019 Johannes Raufeisen. All rights reserved.
//
import Foundation
import SwipeCellKit

/**
 A scale transition object drives the custom appearance of actions during transition.
 
 As button's percentage visibility crosses the `threshold`, the `ScaleTransition` object will animate from `initialScale` to `identity`.  The default settings provide a "pop-like" effect as the buttons are exposed more than 50%.
 */
public struct ScaleTransition: SwipeActionTransitioning {
    
    /// Returns a `ScaleTransition` instance with default transition options.
    public static var `default`: ScaleTransition { return ScaleTransition() }
    
    /// The duration of the animation.
    public let duration: Double
    
    /// The initial scale factor used before the action button percent visible is greater than the threshold.
    public let initialScale: CGFloat

    /// The percent visible threshold that triggers the scaling animation.
    public let threshold: CGFloat
    
    /**
     Contructs a new `ScaleTransition` instance.
    
    - parameter duration: The duration of the animation.
    
    - parameter initialScale: The initial scale factor used before the action button percent visible is greater than the threshold.
    
    - parameter threshold: The percent visible threshold that triggers the scaling animation.
    
    - returns: The new `ScaleTransition` instance.
    */
    public init(duration: Double = 0.15, initialScale: CGFloat = 0.8, threshold: CGFloat = 0.5) {
        self.duration = duration
        self.initialScale = initialScale
        self.threshold = threshold
    }
    
    /// :nodoc:
    public func didTransition(with context: SwipeActionTransitioningContext) -> Void {
        if context.oldPercentVisible == 0 {
            context.button.transform = .init(scaleX: initialScale, y: initialScale)
        }
        
        if context.oldPercentVisible < threshold && context.newPercentVisible >= threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .identity
            }
        } else if context.oldPercentVisible >= threshold && context.newPercentVisible < threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .init(scaleX: self.initialScale, y: self.initialScale)
            }
        }
    }
    
}
