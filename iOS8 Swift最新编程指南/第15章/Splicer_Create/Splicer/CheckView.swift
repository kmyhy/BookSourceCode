/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreGraphics

class CheckView: UIView {
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    drawRectChecked()
  }
  
  func drawRectChecked() {
    //// General Declarations
    let context = UIGraphicsGetCurrentContext()
    
    //// Color Declarations
    let checkmarkBlue2 = UIColor(red: 0.078, green: 0.435, blue: 0.875, alpha: 0.5)
    
    //// Shadow Declarations
    let shadow2 = UIColor.blackColor()
    let shadow2Offset = CGSize(width: 0.1, height: -0.1)
    let shadow2BlurRadius = 2.5
    
    //// Frames
    let frame = bounds
    
    //// Subframes
    let group = CGRect(x: CGRectGetMinX(frame) + 3, y: CGRectGetMinY(frame) + 3, width: CGRectGetWidth(frame) - 6, height: CGRectGetHeight(frame) - 6)
    
    //// CheckedOval Drawing
    let checkedOvalPath = UIBezierPath(ovalInRect:CGRect(x: CGRectGetMinX(group) + 0.5, y: CGRectGetMinY(group) + 0.5, width: CGRectGetWidth(group) + 1, height: CGRectGetHeight(group) + 1))
    CGContextSaveGState(context)
    CGContextSetShadowWithColor(context, shadow2Offset, CGFloat(shadow2BlurRadius), shadow2.CGColor)
    checkmarkBlue2.setFill()
    checkedOvalPath.fill()
    CGContextRestoreGState(context)
    
    UIColor.whiteColor().setStroke()
    checkedOvalPath.lineWidth = 1
    checkedOvalPath.stroke()
    
    
    //// Bezier Drawing
    let bezierPath = UIBezierPath()
    bezierPath.moveToPoint(CGPoint(x: CGRectGetMinX(group) + 0.27083 * CGRectGetWidth(group), y: CGRectGetMinY(group) + 0.54167 * CGRectGetHeight(group)))
    bezierPath.addLineToPoint(CGPoint(x: CGRectGetMinX(group) + 0.41667 * CGRectGetWidth(group), y: CGRectGetMinY(group) + 0.68750 * CGRectGetHeight(group)))
    bezierPath.addLineToPoint(CGPoint(x: CGRectGetMinX(group) + 0.75000 * CGRectGetWidth(group), y: CGRectGetMinY(group) + 0.35417 * CGRectGetHeight(group)))
    bezierPath.lineCapStyle = kCGLineCapSquare
    
    UIColor.whiteColor().setStroke()
    bezierPath.lineWidth = 1.3
    bezierPath.stroke()
  }
}
