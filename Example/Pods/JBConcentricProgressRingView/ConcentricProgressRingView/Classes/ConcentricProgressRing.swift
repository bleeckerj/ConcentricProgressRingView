//
//  ConcentricProgressRing.swift
//
//  Created by Daniel Loewenherz on 6/30/16.
//  Copyright © 2016 Lionheart Software, LLC. All rights reserved.
//

import UIKit

public struct JBProgressRing {
    public var width: CGFloat?
    public var color: UIColor?
    public var backgroundColor: UIColor?
    
    public init?(color: UIColor? = nil, backgroundColor: UIColor? = nil, width: CGFloat? = nil) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.width = width
    }

    public init(color: UIColor, backgroundColor: UIColor? = nil, width: CGFloat) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.width = width
    }
}

open class JBProgressRingLayer: CAShapeLayer, CALayerDelegate, CAAnimationDelegate {
    var completion: (() -> Void)?

    open var progress: CGFloat? {
        get {
            return strokeEnd
        }

        set {
            strokeEnd = newValue ?? 0
        }
    }
    
    public init(center: CGPoint, radius: CGFloat, width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor, cap: String ) {
            super.init()
        let bezier = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        delegate = self as CALayerDelegate
        path = bezier.cgPath
        fillColor = UIColor.clear.cgColor
        strokeColor = color.cgColor
        lineWidth = width
        lineCap = cap
        strokeStart = 0
        strokeEnd = 0

    }
    
    public init(center: CGPoint, radius: CGFloat, width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        super.init()
        
        let bezier = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        delegate = self as CALayerDelegate
        path = bezier.cgPath
        fillColor = UIColor.clear.cgColor
        strokeColor = color.cgColor
        lineWidth = width
        lineCap = kCALineCapButt//kCALineCapRound
        strokeStart = 0
        strokeEnd = 0
    }

    public convenience init(center: CGPoint, radius: CGFloat, width: CGFloat, color: UIColor) {
        self.init(center: center, radius: radius, width: width, startAngle: 0, endAngle: 2*CGFloat.pi, color: color)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    open func setProgress(_ progress: CGFloat, duration: CGFloat, completion: (() -> Void)? = nil) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = strokeEnd
        animation.toValue = progress
        animation.duration = CFTimeInterval(duration)
        animation.delegate = self as CAAnimationDelegate
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        strokeEnd = progress
        add(animation, forKey: "strokeEnd")
    }

      public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completion?()
        }
    }
}

public final class CircleLayer: JBProgressRingLayer {
    init(center: CGPoint, radius: CGFloat, width: CGFloat, color: UIColor) {
        super.init(center: center, radius: radius, width: width, startAngle: 0, endAngle: 2*CGFloat.pi, color: color)
        progress = 1
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ConcentricProgressRingViewError: Error {
    case invalidParameters
}

public final class JBConcentricProgressRingView: UIView, Sequence {
    public var arcs: [JBProgressRingLayer] = []
    var circles: [CircleLayer] = []

    @available(*, unavailable, message: "Progress rings without a color, width, or progress set (such as those provided) can't be used with this initializer. Please use the other initializer that accepts default values.")
    public init?(center: CGPoint, radius: CGFloat, margin: CGFloat, rings: [JBProgressRing?]) {
        return nil
    }

    public convenience init(center: CGPoint, radius: CGFloat, margin: CGFloat, rings theRings: [JBProgressRing?], defaultColor: UIColor? = UIColor.white, defaultBackgroundColor: UIColor = UIColor.clear, defaultWidth: CGFloat?) throws {
        var rings: [JBProgressRing] = []

        for ring in theRings {
            guard var ring = ring else {
                continue
            }

            guard let color = ring.color ?? defaultColor,
                let width = ring.width ?? defaultWidth else {
                    throw ConcentricProgressRingViewError.invalidParameters
            }

            let backgroundColor = ring.backgroundColor ?? defaultBackgroundColor

            ring.color = color
            ring.backgroundColor = backgroundColor
            ring.width = width
            rings.append(ring)
        }

        self.init(center: center, radius: radius, margin: margin, rings: rings)
    }

    public init(center: CGPoint, radius: CGFloat, margin: CGFloat, rings: [JBProgressRing]) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
        let theCenter = CGPoint(x: radius, y: radius)

        super.init(frame: frame)

        var offset: CGFloat = 0
        for ring in rings {
            let color = ring.color!
            let width = ring.width!

            let radius = radius - (width / 2) - offset
            offset = offset + margin + width

            if let backgroundColor = ring.backgroundColor {
                let circle = CircleLayer(center: theCenter, radius: radius, width: width, color: backgroundColor)
                
                circles.append(circle)
                layer.addSublayer(circle)
            }

            let arc = JBProgressRingLayer(center: theCenter, radius: radius, width: width, color: color)
            arcs.append(arc)
            layer.addSublayer(arc)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public subscript(index: Int) -> JBProgressRingLayer {
        return arcs[index]
    }

    public func makeIterator() -> IndexingIterator<[JBProgressRingLayer]> {
        return arcs.makeIterator()
    }
}
