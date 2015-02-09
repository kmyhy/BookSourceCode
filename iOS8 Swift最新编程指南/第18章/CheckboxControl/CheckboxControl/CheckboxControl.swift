//
//  CheckboxControl.swift
//  CheckboxControl
//
//  Created by yanghongyan on 15/1/19.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

@IBDesignable
class CheckboxControl:UIView{

    var bgLayer: CAShapeLayer!

    @IBInspectable var bgColor:UIColor = UIColor.grayColor() {
        didSet{
            bgLayer?.fillColor = bgColor.CGColor
        }
    }
    
    var boxLayer:CALayer!
    var checkImage:UIImage? = UIImage(named: "check")
    var uncheckImage:UIImage? = UIImage(named: "uncheck")
    @IBInspectable var boxFrame:CGRect = CGRectMake(5, 5, 20, 20){
        didSet{
            boxLayer?.frame = boxFrame
       }
    }
    @IBInspectable var boxCornerRadius:Int = 4 {
        didSet{
            boxLayer?.cornerRadius = CGFloat(boxCornerRadius)
        }
    }
    @IBInspectable var boxColor:UIColor = UIColor.whiteColor(){
        didSet{
            boxLayer?.backgroundColor = boxColor.CGColor
        }
    }
    
    var markLayer:CAShapeLayer!
    @IBInspectable var markColor:UIColor = UIColor.blueColor(){
        didSet{
            markLayer?.fillColor = markColor.CGColor
        }
    }
    @IBInspectable var markThickness:CGFloat = 1.3 {
        didSet{
            markLayer?.lineWidth = markThickness
        }
    }
    @IBInspectable var selected: Bool = false { didSet {
            boxLayer?.contents = selected ? checkImage?.CGImage:uncheckImage?.CGImage

        }
    }
    
    var titleLayer: CATextLayer!
    @IBInspectable var title: String = "" { didSet { titleLayer?.string = title }
    }
    @IBInspectable var titleColor:UIColor = UIColor.whiteColor(){
        didSet{
            titleLayer?.foregroundColor = titleColor.CGColor
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        initBgLayer()
        initBoxLayer()
//        initMarkLayer()
        initTitleLayer()
    }
    func update(){

    }
    func initTitleLayer(){
        if titleLayer == nil{
            titleLayer = CATextLayer()
            let fontSize = boxFrame.size.height * 0.75
            titleLayer.font = UIFont.systemFontOfSize(fontSize)
            titleLayer.fontSize = fontSize
            titleLayer.frame = CGRectMake(CGRectGetMaxX(boxFrame)+10, CGRectGetMinY(boxFrame)+boxFrame.size.height * 0.125 , bounds.size.width-CGRectGetMaxX(boxFrame)-10,   fontSize)
            titleLayer.string = title
            titleLayer.alignmentMode = kCAAlignmentLeft
            titleLayer.foregroundColor = titleColor.CGColor
            titleLayer.contentsScale = UIScreen.mainScreen().scale
            layer.addSublayer(titleLayer)
        }
    }
    func initMarkLayer(){
        if markLayer == nil {
            markLayer = CAShapeLayer()
            layer.addSublayer(markLayer)
            markLayer.hidden = !selected
            markLayer.frame = boxFrame
            drawMark(markLayer!)
            
        }
    }
    private func drawMark(layer:CAShapeLayer){
//        let group = CGRect(x: CGRectGetMinX(layer.bounds) + 3, y: CGRectGetMinY(layer.bounds) + 3, width: CGRectGetWidth(layer.bounds) - 6, height: CGRectGetHeight(layer.bounds) - 6)
        let group = layer.bounds
        
        let bezierPath = UIBezierPath()
        
        bezierPath.moveToPoint(CGPoint(x: CGRectGetMinX(group) + CGRectGetWidth(group)/4, y: CGRectGetMinY(group) +  CGRectGetHeight(group)/2))
        bezierPath.addLineToPoint(CGPoint(x: CGRectGetMinX(group) + 0.4 * CGRectGetWidth(group), y: CGRectGetMinY(group) + 0.7 * CGRectGetHeight(group)))
        bezierPath.addLineToPoint(CGPoint(x: CGRectGetMinX(group) + 0.75 * CGRectGetWidth(group), y: CGRectGetMinY(group) + 0.35 * CGRectGetHeight(group)))
        
        layer.lineWidth = markThickness
        layer.strokeColor = markColor.CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineCap = kCALineCapRound
        layer.path = bezierPath.CGPath

    }
    func initBoxLayer(){
        if boxLayer == nil {
            boxLayer = CAShapeLayer()
            boxLayer.contentsGravity = kCAGravityResize
            layer.addSublayer(boxLayer)
            boxLayer.contents = selected ? checkImage?.CGImage:uncheckImage?.CGImage
            
            boxLayer.frame = boxFrame
        }
        
    }
    func initBgLayer(){
        if bgLayer == nil {
            bgLayer = CAShapeLayer()
            layer.addSublayer(bgLayer)
            let path = UIBezierPath(rect: self.bounds)
            bgLayer.path = path.CGPath
            bgLayer.fillColor = bgColor.CGColor
        }
        bgLayer.frame = layer.bounds
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if touches.count == 1{
            let touch = touches.anyObject() as UITouch
            if boxLayer == layerForTouch(touch) {
                selected = !selected
            }
        }
    }
    func layerForTouch(touch:UITouch)->CALayer?{
        var point = touch.locationInView(self)
        point = self.layer.convertPoint(point, toLayer: self.layer.superlayer)
        
        let hitLayer = self.layer.presentationLayer().hitTest(point)
        return hitLayer?.modelLayer() as? CALayer
    }
}
