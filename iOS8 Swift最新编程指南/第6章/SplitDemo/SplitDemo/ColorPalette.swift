//
//  ColorPalette.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-5.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class ColorPalette: NSObject {
    var name:String!=nil
    var children:[ColorPalette]!=nil
    var hasColors:Bool!=false
}

func dataSource()->[ColorPalette]{
    let vibrant=ColorPalette()
    vibrant.name="Vibrant"
    
    let logis4=ColorPalette()
    logis4.name="Logis 4"
    vibrant.children=[logis4]
    logis4.hasColors=true
    
    var color1=ColorPalette()
    color1.name="#ff590d"
    var color2=ColorPalette()
    color2.name="#ff9900"
    var color3=ColorPalette()
    color3.name="#f2db00"
    var color4=ColorPalette()
    color4.name="#99cc00"
    var color5=ColorPalette()
    color5.name="#07938c"
    
    logis4.children=[color1,color2,color3,color4,color5]
    
    let candyCoated=ColorPalette()
    candyCoated.name="Candy Coated"
    vibrant.children!.append(candyCoated)
    candyCoated.hasColors=true
    
    color1=ColorPalette()
    color1.name="#f41c54"
    color2=ColorPalette()
    color2.name="#ff9f00"
    color3=ColorPalette()
    color3.name="#fbd506"
    color4=ColorPalette()
    color4.name="#a8bf12"
    color5=ColorPalette()
    color5.name="#00aab5"
    candyCoated.children=[color1,color2,color3,color4,color5]
    
    let monochrome=ColorPalette()
    monochrome.name="Monochrome"
    
    let blues=ColorPalette()
    blues.name="Blues"
    monochrome.children=[blues]
    blues.hasColors=true
    
    color1=ColorPalette()
    color1.name="#f41c54"
    color2=ColorPalette()
    color2.name="#ff9f00"
    color3=ColorPalette()
    color3.name="#fbd506"
    color4=ColorPalette()
    color4.name="#a8bf12"
    color5=ColorPalette()
    color5.name="#00aab5"
    blues.children=[color1,color2,color3,color4,color5]
    
    let smooth=ColorPalette()
    smooth.name="Smooth"
    
    return [vibrant,monochrome,smooth]
}
func UIColorFromHexString(hex:String)->UIColor{
    var rgbValue:CUnsignedInt = 0
    let scanner:NSScanner = NSScanner(string: hex)
    
    scanner.scanLocation=1 // bypass '#' character
    scanner.scanHexInt(&rgbValue)
    return UIColorFromUInt32(rgbValue);
}
func UIColorFromUInt32(rgbHex:CUnsignedInt)->UIColor{
    let red:CGFloat = CGFloat((rgbHex & 0xFF0000) >> 16) / 255.0
    let green:CGFloat = CGFloat((rgbHex & 0x00FF00) >> 8) / 255.0
    let blue:CGFloat = CGFloat(rgbHex & 0x0000FF) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
}






