//
//  Knob.swift
//  MyMetronome
//
//  Created by Michael Vartanian on 7/31/19.
//  Originally created in ios-knobs project on 7/1/2019 (knob3.swift)
//  Copyright © 2019 Michael Vartanian. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

@IBDesignable public class Knob3: UIControl {
    
    @IBInspectable public var continuous = true
    
    /// The minimum value of the knob. Defaults to 0.0.
    @IBInspectable public var minimumValue: Float = KnobConstants.minknobvalue { didSet { drawKnob3() }}
    
    /// The maximum value of the knob. Defaults to 1.0.
    @IBInspectable public var maximumValue: Float = KnobConstants.maxknobvalue { didSet { drawKnob3() }}
    
    /// Value of the knob. Also known as progress.
    @IBInspectable public var value: Float = 0.0 {
        didSet {
            value = min(maximumValue, max(minimumValue, value))
            setNeedsLayout()
        }
    }
    
    /// Layers
    public private(set) var outerLayer = CAShapeLayer()
    public private(set) var middleLayer1 = CAShapeLayer()
    public private(set) var middleLayer2 = CAShapeLayer()
    public private(set) var pointerLayer = CAShapeLayer()
    
    /// Start angle of the marker.
    public var startAngle = KnobConstants.startKnobAngle
    /// End angle of the marker.
    public var endAngle = KnobConstants.endKnobAngle
    
    /// Knob gesture recognizer.
    public private(set) var gestureRecognizer: Knob3GestureRecognizer!
    
    // MARK: Init
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        // Setup knob gesture
        gestureRecognizer = Knob3GestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
        // Setup layers
        outerLayer.fillColor = UIColor.init(red: 7/255, green: 41/255, blue: 97/255, alpha: 1.0).cgColor
        outerLayer.strokeColor = UIColor.blue.cgColor
        middleLayer1.fillColor = UIColor.init(red: 28/255, green: 85/255, blue: 176/255, alpha: 1.0).cgColor
        middleLayer2.fillColor = UIColor.init(red: 85/255, green: 139/255, blue: 224/255, alpha: 1.0).cgColor
        pointerLayer.strokeColor = UIColor.white.cgColor
        pointerLayer.lineWidth = 7
        layer.addSublayer(outerLayer)
        layer.addSublayer(middleLayer1)
        layer.addSublayer(middleLayer2)
        
        layer.addSublayer(pointerLayer)
    }
    
    // MARK: Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        drawKnob3()
    }
    public func drawKnob3() {
        outerLayer.bounds = bounds
        outerLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        middleLayer1.bounds = bounds
        middleLayer1.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        middleLayer2.bounds = bounds
        middleLayer2.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        pointerLayer.bounds = bounds
        pointerLayer.position = outerLayer.position
        
        // Draw base ring.
        let center = CGPoint(x: outerLayer.bounds.width / 2, y: outerLayer.bounds.height / 2)
        let radius_outer = (min(outerLayer.bounds.width, outerLayer.bounds.height) / 2)
        let radius_middle1 = radius_outer - KnobConstants.radius_middle1_offset
        let radius_middle2 = radius_outer - KnobConstants.radius_middle2_offset
        let ring_outer = UIBezierPath(arcCenter: center,
                                      radius: radius_outer,
                                      startAngle: 0,
                                      endAngle: CGFloat(2 * Double.pi),
                                      clockwise: true)
        let ring_middle1 = UIBezierPath(arcCenter: center,
                                        radius: radius_middle1,
                                        startAngle: 0,
                                        endAngle: CGFloat(2 * Double.pi),
                                        clockwise: true)
        let ring_middle2 = UIBezierPath(arcCenter: center,
                                        radius: radius_middle2,
                                        startAngle: 0,
                                        endAngle: CGFloat(2 * Double.pi),
                                        clockwise: true)
        outerLayer.path = ring_outer.cgPath
        outerLayer.lineCap = .round
        middleLayer1.path = ring_middle1.cgPath
        middleLayer1.lineCap = .round
        middleLayer2.path = ring_middle2.cgPath
        middleLayer2.lineCap = .round
        
        
        // Draw pointer.
        let pointer = UIBezierPath()
        pointer.move(to: CGPoint(x: center.x + radius_middle2 - KnobConstants.pointer_offset1, y: center.y))
        pointer.addLine(to: CGPoint(x: center.x + radius_middle2 - KnobConstants.pointer_offset2, y: center.y))
        pointerLayer.path = pointer.cgPath
        pointerLayer.lineCap = .round
        
        let angle = CGFloat(angleForValue(value))
        
        // Draw pointer
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pointerLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        CATransaction.commit()
        
    }
    
    // MARK: Rotation Gesture Recogniser
    // note the use of dynamic, because calling
    // private swift selectors(@ gestureRec target:action:!) gives an exception
    @objc dynamic func handleGesture(_ gesture: Knob3GestureRecognizer) {
        let midPointAngle = (2 * CGFloat.pi + startAngle - endAngle) / 2 + endAngle
        
        var boundedAngle = gesture.touchAngle
        if boundedAngle > midPointAngle {
            boundedAngle -= 2 * CGFloat.pi
        } else if boundedAngle < (midPointAngle - 2 * CGFloat.pi) {
            boundedAngle += 2 * CGFloat.pi
        }
        
        boundedAngle = min(endAngle, max(startAngle, boundedAngle))
        value = min(maximumValue, max(minimumValue, valueForAngle(boundedAngle)))
        
        // Inform changes based on continuous behaviour of the knob.
        sendActions(for: .valueChanged)
    }
    
    // MARK: Value/Angle conversion
    public func valueForAngle(_ angle: CGFloat) -> Float {
        let angleRange = Float(endAngle - startAngle)
        let valueRange = maximumValue - minimumValue
        return Float(angle - startAngle) / angleRange * valueRange + minimumValue
    }
    
    public func angleForValue(_ value: Float) -> CGFloat {
        let angleRange = endAngle - startAngle
        let valueRange = CGFloat(maximumValue - minimumValue)
        return CGFloat(self.value - minimumValue) / valueRange * angleRange + startAngle
    }
}

/// Custom gesture recognizer for the knob.
public class Knob3GestureRecognizer: UIPanGestureRecognizer {
    /// Current angle of the touch related the current progress value of the knob.
    public private(set) var touchAngle: CGFloat = 0
    /// Horizontal and vertical slide changes for the calculating current progress value of the knob.
    public private(set) var diagonalChange: CGSize = .zero
    /// Horizontal and vertical slide calculation reference.
    private var lastTouchPoint: CGPoint = .zero
    /// Horizontal and vertical slide sensitivity multiplier. Defaults 0.005.
    public var slidingSensitivity: CGFloat = KnobConstants.slidingSensitivity
    
    // MARK: UIGestureRecognizerSubclass
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        
        // Update diagonal movement.
        guard let touch = touches.first else { return }
        lastTouchPoint = touch.location(in: view)
        
        // Update rotary movement.
        updateTouchAngleWithTouches(touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        // Update diagonal movement.
        guard let touchPoint = touches.first?.location(in: view) else { return }
        diagonalChange.width = (touchPoint.x - lastTouchPoint.x) * slidingSensitivity
        diagonalChange.height = (touchPoint.y - lastTouchPoint.y) * slidingSensitivity
        
        // Reset last touch point.
        lastTouchPoint = touchPoint
        
        // Update rotary movement.
        updateTouchAngleWithTouches(touches)
    }
    
    private func updateTouchAngleWithTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: view)
        touchAngle = calculateAngleToPoint(touchPoint)
    }
    
    private func calculateAngleToPoint(_ point: CGPoint) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view!.bounds.midX, y: point.y - view!.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }
    
    // MARK: Lifecycle
    public init() {
        super.init(target: nil, action: nil)
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
    
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
}
