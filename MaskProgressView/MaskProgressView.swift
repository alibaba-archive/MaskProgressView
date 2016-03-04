//
//  MaskProgressView.swift
//  MaskProgressView
//
//  Created by Xin Hong on 16/3/4.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public enum MaskProgressViewDirection {
    case Vertical
    case Horizontal
}

public class MaskProgressView: UIView {
    private struct GradientLayerPoints {
        static let horizontalStartPoint = CGPoint(x: 1, y: 0.5)
        static let horizontalEndPoint = CGPoint(x: 0, y: 0.5)
        static let verticalStartPoint = CGPoint(x: 0.5, y: 0)
        static let verticalEndPoint = CGPoint(x: 0.5, y: 1)
    }

    public var direction: MaskProgressViewDirection {
        set {
            switch newValue {
            case .Vertical:
                gradientLayer.startPoint = GradientLayerPoints.verticalStartPoint
                gradientLayer.endPoint = GradientLayerPoints.verticalEndPoint
            case .Horizontal:
                gradientLayer.startPoint = GradientLayerPoints.horizontalStartPoint
                gradientLayer.endPoint = GradientLayerPoints.horizontalEndPoint
            }
        }
        get {
            if CGPointEqualToPoint(gradientLayer.startPoint, GradientLayerPoints.horizontalStartPoint) &&
               CGPointEqualToPoint(gradientLayer.endPoint, GradientLayerPoints.horizontalEndPoint) {
                return MaskProgressViewDirection.Horizontal
            } else {
                return MaskProgressViewDirection.Vertical
            }
        }
    }
    public var maskImage: UIImage? {
        didSet {
            if let maskImage = maskImage {
                maskView(self, withImage: maskImage)
            }
        }
    }
    public private(set) var progress: CGFloat = 0
    public var animationDuration: NSTimeInterval = 0.5
    public var colors: [UIColor]? {
        set {
            if let colors = newValue {
                let cgColors = colors.map({ (color) -> CGColorRef in
                    return color.CGColor
                })
                gradientLayer.colors = cgColors
            }
        }
        get {
            guard let colors = gradientLayer.colors else {
                return nil
            }
            let uiColors = colors.flatMap { (color) -> UIColor? in
                if color is CGColorRef {
                    return UIColor(CGColor: color as! CGColorRef)
                }
                return nil
            }
            return uiColors
        }
    }
    public var backColor: UIColor? {
        set {
            if let backColor = newValue, var colors = colors where colors.count > 0 {
                colors[0] = backColor
                self.colors = colors
                setNeedsDisplay()
            }
        }
        get {
            if let colors = colors where colors.count > 0 {
                return colors[0]
            }
            return nil
        }
    }
    public var frontColor: UIColor? {
        set {
            if let frontColor = newValue, var colors = colors where colors.count > 0 {
                colors[1] = frontColor
                self.colors = colors
                setNeedsDisplay()
            }
        }
        get {
            if let colors = colors where colors.count > 1 {
                return colors[1]
            }
            return nil
        }
    }
    public var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    // MARK: - Life cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Overriding
    override public class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Public
    public func setProgress(progress: CGFloat, animated: Bool) {
        let progress = 1 - min(max(progress, 0), 1)
        let newLocations = [progress, progress]

        if animated {
            let animation = CABasicAnimation(keyPath: "locations")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = animationDuration
            animation.delegate = self
            animation.fromValue = gradientLayer.locations
            animation.toValue = newLocations
            gradientLayer.addAnimation(animation, forKey: "animateLocations")
        } else {
            gradientLayer.setNeedsDisplay()
        }
        gradientLayer.locations = newLocations
        self.progress = progress
    }
}

extension MaskProgressView {
    // MARK: - Helper
    private func commonInit() {
        setProgress(0, animated: false)
        backgroundColor = UIColor.clearColor()
        colors = [UIColor.whiteColor(), UIColor.whiteColor()]
    }

    private func maskView(view: UIView, withImage image: UIImage) {
        let maskLayer = CALayer()
        maskLayer.frame = view.bounds
        maskLayer.contents = image.CGImage
        view.layer.mask = maskLayer
    }
}
