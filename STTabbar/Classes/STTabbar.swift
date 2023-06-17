//
//  STTabbar.swift
//  Pods-STTabbar_Example
//
//  Created by Shraddha Sojitra on 19/06/20.
//

import Foundation
import UIKit

@IBDesignable
public final class STTabbar: UITabBar {
    
    // MARK:- Variables -
    @objc public var centerButtonActionHandler: ()-> () = {}

    @IBInspectable public var centerButtonColor: UIColor?
    @IBInspectable public var centerButtonHeight: CGFloat = 50.0
    @IBInspectable public var padding: CGFloat = 5.0
    @IBInspectable public var buttonImage: UIImage?
    @IBInspectable public var buttonTitle: String?
    
    @IBInspectable public var tabbarColor: UIColor = UIColor.lightGray
    @IBInspectable public var unselectedItemColor: UIColor = UIColor.white

    @IBInspectable public var labelTitle: String?
    @IBInspectable public var label: UILabel?

    
    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = tabbarColor.cgColor
        shapeLayer.lineWidth = 0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
//        self.tintColor = centerButtonColor
//        self.unselectedItemTintColor = unselectedItemColor
        self.setupMiddleButton()
    }
    
    override public func draw(_ rect: CGRect) {
        self.addShape()
    }
        
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
    
    private func createPath() -> CGPath {
        let f = CGFloat(centerButtonHeight / 2.0) + padding
        let h = frame.height
        let w = frame.width
        let halfW = frame.width/2.0
        let r = CGFloat(18)
        let path = UIBezierPath()
        path.move(to: .zero)
        
        path.addLine(to: CGPoint(x: halfW-f-(r/2.0), y: 0))
        
        path.addQuadCurve(to: CGPoint(x: halfW-f, y: (r/2.0)), controlPoint: CGPoint(x: halfW-f, y: 0))
        
        path.addArc(withCenter: CGPoint(x: halfW, y: (r/2.0)), radius: f, startAngle: .pi, endAngle: 0, clockwise: false)
        
        path.addQuadCurve(to: CGPoint(x: halfW+f+(r/2.0), y: 0), controlPoint: CGPoint(x: halfW+f, y: 0))
        
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0.0, y: h))
        
        return path.cgPath
    }
    
    private func setupMiddleButton() {
        
        let centerButton = UIButton(frame: CGRect(x: (self.bounds.width / 2)-(centerButtonHeight/2), y: -20, width: centerButtonHeight, height: centerButtonHeight))
        
        centerButton.layer.cornerRadius = centerButton.frame.size.width / 2.0
        centerButton.setTitle(buttonTitle, for: .normal)
        centerButton.setImage(buttonImage, for: .normal)
        centerButton.backgroundColor = centerButtonColor
        centerButton.tintColor = UIColor.white

        //drop shadow
        centerButton.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15).cgColor
        centerButton.layer.shadowOpacity = 0.8
        centerButton.layer.shadowRadius = 3.0
        centerButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        centerButton.clipsToBounds = true
        centerButton.layer.masksToBounds = false

        
        //add to the tabbar and add click event
        self.addSubview(centerButton)
        centerButton.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
        
        
        // Add badge label
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label?.center = CGPoint(x: centerButton.frame.origin.x + centerButtonHeight - 10, y: centerButton.frame.origin.y + 5)
        label?.textAlignment = .center
        label?.text = ""
        label?.backgroundColor = UIColor(red: 244/255, green: 186/255, blue: 69/255, alpha: 1.0)
        label?.textColor = .black
        label?.layer.cornerRadius = (label?.frame.size.height ?? 0) / 2
        label?.layer.masksToBounds = true
        label?.font = UIFont(name: "LoewNextArabic-Medium", size: 13)
        label?.isHidden = true
        self.addSubview(label ?? UILabel())
    }
    
    // Menu Button Touch Action
     @objc func centerButtonAction(sender: UIButton) {
        self.centerButtonActionHandler()
     }
}

