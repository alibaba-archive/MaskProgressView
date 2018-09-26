//
//  MaskProgressView.swift
//  MaskProgressView
//
//  Created by Xin Hong on 16/3/4.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

public enum MaskProgressViewDirection {
    case vertical
    case horizontal
}

open class MaskProgressView: UIView {
    fileprivate struct GradientLayerPoints {
        static let horizontalStartPoint = CGPoint(x: 1, y: 0.5)
        static let horizontalEndPoint = CGPoint(x: 0, y: 0.5)
        static let verticalStartPoint = CGPoint(x: 0.5, y: 0)
        static let verticalEndPoint = CGPoint(x: 0.5, y: 1)
    }

    open var direction: MaskProgressViewDirection {
        set {
            switch newValue {
            case .vertical:
                gradientLayer.startPoint = GradientLayerPoints.verticalStartPoint
                gradientLayer.endPoint = GradientLayerPoints.verticalEndPoint
            case .horizontal:
                gradientLayer.startPoint = GradientLayerPoints.horizontalStartPoint
                gradientLayer.endPoint = GradientLayerPoints.horizontalEndPoint
            }
        }
        get {
            if gradientLayer.startPoint.equalTo(GradientLayerPoints.horizontalStartPoint) &&
               gradientLayer.endPoint.equalTo(GradientLayerPoints.horizontalEndPoint) {
                return MaskProgressViewDirection.horizontal
            } else {
                return MaskProgressViewDirection.vertical
            }
        }
    }
    open var maskImage: UIImage? {
        didSet {
            if let maskImage = maskImage {
                maskView(self, withImage: maskImage)
            }
        }
    }
    /// The current progress value of MaskProgressView.
    ///
    /// Private setting this property causes the progress view to redraw itself using the new value. To render an animated transition from the current value to the new value, you should use the "setProgress:animated:" method.
    ///
    /// If you try to set a value that is below the minimum or above the maximum value, the minimum or maximum value is set instead. The default value of this property is 0.0.
    open fileprivate(set) var progress: Float = 0
    open var animationDuration: TimeInterval = 0.5
    open var colors: [UIColor]? {
        set {
            if let colors = newValue {
                let cgColors = colors.map { $0.cgColor }
                gradientLayer.colors = cgColors
            }
        }
        get {
            guard let colors = gradientLayer.colors else {
                return nil
            }
            let uiColors = colors.map { UIColor(cgColor: $0 as! CGColor) }
            return uiColors
        }
    }
    open var backColor: UIColor? {
        set {
            if let backColor = newValue, let colors = colors, colors.count > 0 {
                var colors = colors
                colors[0] = backColor
                self.colors = colors
            }
            setNeedsDisplay()
        }
        get {
            if let colors = colors, colors.count > 0 {
                return colors[0]
            }
            return nil
        }
    }
    open var frontColor: UIColor? {
        set {
            if let frontColor = newValue, let colors = colors, colors.count > 1 {
                var colors = colors
                colors[1] = frontColor
                self.colors = colors
            }
            setNeedsDisplay()
        }
        get {
            if let colors = colors, colors.count > 1 {
                return colors[1]
            }
            return nil
        }
    }
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    // MARK: - Life cycle
    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Overriding
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Public
    open func setProgress(_ progress: Float, animated: Bool) {
        let progress = 1 - min(max(progress, 0), 1)
        let newLocations = [progress, progress]

        if animated {
            let animation = CABasicAnimation(keyPath: "locations")
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.duration = animationDuration
            animation.fromValue = gradientLayer.locations
            animation.toValue = newLocations
            gradientLayer.add(animation, forKey: "animateLocations")
        } else {
            gradientLayer.setNeedsDisplay()
        }
        gradientLayer.locations = newLocations.map { NSNumber(value: $0) }
        self.progress = progress
    }
}

extension MaskProgressView {
    // MARK: - Helper
    fileprivate func commonInit() {
        setProgress(0, animated: false)
        backgroundColor = .clear
        colors = [.clear, .clear]
    }

    fileprivate func maskView(_ view: UIView, withImage image: UIImage) {
        let maskLayer = CALayer()
        maskLayer.frame = view.bounds
        maskLayer.contents = image.cgImage
        view.layer.mask = maskLayer
    }
}
