//
//  BubbleChatView.swift
//  PruebaChat
//
//  Created by Brayam Alberto Mora Arias on 13/05/20.
//  Copyright © 2020 Brayam Alberto Mora Arias. All rights reserved.
//

import Foundation
import UIKit

class BubbleChatView: UIView {
    
    var isIncoming = false
    var lastIn = false
    // var incomingColor = UIColor(white: 0.9, alpha: 1)
    //  var outgoingColor = UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        
        if !isIncoming{
            //// Color Declarations
            let fillColor2 = Colors.blue_007AFF//UIColor(red: 0.929, green: 0.953, blue: 0.973, alpha: 1.000)
            let x1 = width * 0.9982
            let x2 = width * 0.9484
            let x3 = width * 0.9410
            let x4 = width * 0.9146
            let x5 = width * 0.0250
            let x6 = width * 0.0265
            let x7 = width * 0.9160
            let x8 = width * 0.9425
            let x9 = width * 0.9601
            let x10 = width * 0.9440
            let x11 = width * 0.0118
            let x12 = width * 0.9307
            let x13 = width * 0.9997
            let x14 = width * 0.9392
            let x15 = width * 0.9499
            let x16 = width * 1.0012
            
            
            let y1 = height * 0.8018
            let y2 = height * 0.7368
            let y3 = height * 0.7100
            let y4 = height * 0.0532
            let y5 = height * 0.9468
            let y6 = height * 0.9024
            let y7 = height * 0.8491
            let y8 = height * 0.8135
            let y9 = height * 0.7309
            let y10 = height * 0.0235
            let y11 = height * 0.9765
            let y12 = height * 0.8285
            let y13 = height * 0.8165
            let y14 = height * 0.7188
            let y15 = height * 0.8047
            
            
            //// Bezier Drawing
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: x1, y: y1))
            bezierPath.addLine(to: CGPoint(x: x2, y: y2))
            bezierPath.addCurve(to: CGPoint(x: x3, y: y3), controlPoint1: CGPoint(x: x10, y: y9), controlPoint2: CGPoint(x: x3, y: y14))
            
            bezierPath.addLine(to: CGPoint(x: x3, y: y4))
            bezierPath.addCurve(to: CGPoint(x: x4, y: 0), controlPoint1: CGPoint(x: x3, y: y10), controlPoint2: CGPoint(x: x14, y: 0))
            bezierPath.addLine(to: CGPoint(x: x5, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 0, y: y4), controlPoint1: CGPoint(x: x11, y: 0), controlPoint2: CGPoint(x: 0, y: y10))
            bezierPath.addLine(to: CGPoint(x: 0, y: y5))
            bezierPath.addCurve(to: CGPoint(x: x6, y: height), controlPoint1: CGPoint(x: 0, y: y11), controlPoint2: CGPoint(x: x11, y: height))
            
            bezierPath.addLine(to: CGPoint(x: x7, y: height))
            bezierPath.addCurve(to: CGPoint(x: x8, y: y5), controlPoint1: CGPoint(x: x12, y: height), controlPoint2: CGPoint(x: x8, y: y11))
            bezierPath.addLine(to: CGPoint(x: x8, y: y6))
            bezierPath.addLine(to: CGPoint(x: x8, y: y7))
            bezierPath.addCurve(to: CGPoint(x: x9, y: y8), controlPoint1: CGPoint(x: x8, y: y12), controlPoint2: CGPoint(x: x15, y: y8))
            bezierPath.addLine(to: CGPoint(x: x1, y: y8))
            bezierPath.addCurve(to: CGPoint(x: x1, y: y1), controlPoint1: CGPoint(x: x13, y: y13), controlPoint2: CGPoint(x: x16, y: y15))
            bezierPath.close()
            fillColor2.setFill()
            bezierPath.fill()
            
            //################
            /*
             let bezierPath = UIBezierPath()
             bezierPath.move(to: CGPoint(x: x1, y: y1))
             bezierPath.addLine(to: CGPoint(x: x2, y: 15))
             bezierPath.addCurve(to: CGPoint(x: x3, y: 17), controlPoint1: CGPoint(x: x10, y: 17), controlPoint2: CGPoint(x: x3, y: 17))
             
             bezierPath.addLine(to: CGPoint(x: x3, y: y4))
             bezierPath.addCurve(to: CGPoint(x: x4, y: 0), controlPoint1: CGPoint(x: x3, y: y10), controlPoint2: CGPoint(x: x14, y: 0))
             bezierPath.addLine(to: CGPoint(x: x5, y: 0))
             bezierPath.addCurve(to: CGPoint(x: 0, y: y4), controlPoint1: CGPoint(x: x11, y: 0), controlPoint2: CGPoint(x: 0, y: y10))
             bezierPath.addLine(to: CGPoint(x: 0, y: y5))
             bezierPath.addCurve(to: CGPoint(x: x6, y: height), controlPoint1: CGPoint(x: 0, y: y11), controlPoint2: CGPoint(x: x11, y: height))
             
             bezierPath.addLine(to: CGPoint(x: x7, y: height))
             bezierPath.addCurve(to: CGPoint(x: x8, y: y5), controlPoint1: CGPoint(x: x12, y: height), controlPoint2: CGPoint(x: x8, y: y11))
             bezierPath.addLine(to: CGPoint(x: x8, y: y6))
             bezierPath.addLine(to: CGPoint(x: x8, y: y7))
             bezierPath.addCurve(to: CGPoint(x: x9, y: 27), controlPoint1: CGPoint(x: x8, y: 10), controlPoint2: CGPoint(x: x15, y: 26))
             bezierPath.addLine(to: CGPoint(x: x1, y: y8))
             bezierPath.addCurve(to: CGPoint(x: x1, y: 27), controlPoint1: CGPoint(x: x13, y: 27), controlPoint2: CGPoint(x: x16, y: 27))
             bezierPath.close()
             fillColor2.setFill()
             bezierPath.fill()
             */
            
            
            //################
            
            
            
            /*
             let bezierPath = UIBezierPath()
             bezierPath.move(to: CGPoint(x: 67.88, y: 27.26))//punta de la pestana
             bezierPath.addLine(to: CGPoint(x: 64.49, y: 25.05))//esquina superior pestana
             bezierPath.addCurve(to: CGPoint(x: 63.99, y: 24.14), controlPoint1: CGPoint(x: 64.19, y: 24.85), controlPoint2: CGPoint(x: 63.99, y: 24.44))//curva pesta
             bezierPath.addLine(to: CGPoint(x: 63.99, y: 1.81))//curva pesta
             bezierPath.addCurve(to: CGPoint(x: 62.19, y: 0), controlPoint1: CGPoint(x: 63.99, y: 0.8), controlPoint2: CGPoint(x: 63.19, y: 0)) //bsd p3
             bezierPath.addLine(to: CGPoint(x: 2, y: 0)) //bsi p2
             bezierPath.addCurve(to: CGPoint(x: 0, y: 1.81), controlPoint1: CGPoint(x: 1.1, y: 0), controlPoint2: CGPoint(x: 0, y: 0.8))//bsi p1
             bezierPath.addLine(to: CGPoint(x: 0, y: 32.19))
             bezierPath.addCurve(to: CGPoint(x: 1.8, y: 34), controlPoint1: CGPoint(x: 0, y: 33.2), controlPoint2: CGPoint(x: 0.8, y: 34))
             bezierPath.addLine(to: CGPoint(x: 62.29, y: 34))//bid
             bezierPath.addCurve(to: CGPoint(x: 64.09, y: 32.19), controlPoint1: CGPoint(x: 63.29, y: 34), controlPoint2: CGPoint(x: 64.09, y: 33.2))//bisd
             bezierPath.addLine(to: CGPoint(x: 64.09, y: 30.68))//primer punto arribade laderecha
             bezierPath.addLine(to: CGPoint(x: 64.09, y: 28.87))//segundo punto arriba la derecha
             bezierPath.addCurve(to: CGPoint(x: 65.29, y: 27.66), controlPoint1: CGPoint(x: 64.09, y: 28.87), controlPoint2: CGPoint(x: 64.59, y: 27.66)) //inicio de curva
             bezierPath.addLine(to: CGPoint(x: 67.88, y: 27.66))//esquina de la pestana
             bezierPath.addCurve(to: CGPoint(x: 67.88, y: 27.26), controlPoint1: CGPoint(x: 67.98, y: 27.76), controlPoint2: CGPoint(x: 68.08, y: 27.36))//borde pesta
             bezierPath.close()
             fillColor2.setFill()
             bezierPath.fill()
             */
        }else{
            
            //// Color Declarations
            let fillColor3 = Colors.gray_7688AA//UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.000)
            let x1 = width * 0.9709
            let x2 = width * 0.0850
            let x3 = width * 0.0575
            let x4 = width * 0.0399
            let x5 = width * 0.0040
            let x6 = width * 0.0029
            let x7 = width * 0.0472
            let x8 = width * 0.0560
            let x9 = width * 0.0871
            let x10 = width * 0.9709
            let x11 = width * 1.0019
            let x12 = width * 0.0709
            let x13 = width * 0.0575
            let x14 = width * 0.0015
            let x15 = width * 0.0531
            let x16 = width * 0.9885
            let x17 = width * 1.0034
            let x18 = width * 0.0501
            let x19 = width * 0.0709
            
            
            let y1 = height * 0.0029
            let y2 = height * 0.0653
            let y3 = height * 0.7797
            let y4 = height * 0.8153
            let y5 = height * 0.8244
            let y6 = height * 0.8779
            let y7 = height * 0.9076
            let y8 = height * 0.9404
            let y9 = height * 1.0029
            let y10 = height * 0.9406
            let y11 = height * 0.0653
            let y12 = height * 0.7976
            let y13 = height * 0.8838
            let y14 = height * 0.9762
            let y15 = height * 0.0297
            let y16 = height * 0.0326
            let y17 = height * 0.8215
            let y18 = height * 0.8959
            let y19 = height * 0.9732
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: x1, y: y1))
            bezierPath.addLine(to: CGPoint(x: x2, y: y1))
            bezierPath.addCurve(to: CGPoint(x: x3, y: y2),   controlPoint1: CGPoint(x: x12, y: y1), controlPoint2: CGPoint(x: x13, y: y16))
            if lastIn{
                bezierPath.addLine(to: CGPoint(x: x3, y: y3))
                bezierPath.addCurve(to: CGPoint(x: x4, y: y4),  controlPoint1: CGPoint(x: x13, y: y12), controlPoint2: CGPoint(x: x18, y: y4))
                bezierPath.addLine(to: CGPoint(x: x5, y: y4))
                bezierPath.addCurve(to: CGPoint(x: x6, y: y5),  controlPoint1: CGPoint(x: x14, y: y4), controlPoint2: CGPoint(x: x14, y: y17))
                bezierPath.addLine(to: CGPoint(x: x7, y: y6))
                bezierPath.addCurve(to: CGPoint(x: x8, y: y7),  controlPoint1: CGPoint(x: x15, y: y13), controlPoint2: CGPoint(x: x8, y: y18))
            }
            bezierPath.addLine(to: CGPoint(x: x8, y: y8))
            bezierPath.addCurve(to: CGPoint(x: x9, y: y9),   controlPoint1: CGPoint(x: x8, y: y14), controlPoint2: CGPoint(x: x19, y: y9))
            bezierPath.addLine(to: CGPoint(x: x10, y: y9))
            bezierPath.addCurve(to: CGPoint(x: x11, y: y10), controlPoint1: CGPoint(x: x16, y: y9), controlPoint2: CGPoint(x: x11, y: y19))
            bezierPath.addLine(to: CGPoint(x: x11, y: y11))
            bezierPath.addCurve(to: CGPoint(x: x10, y: y1),   controlPoint1: CGPoint(x: x17, y: y15), controlPoint2: CGPoint(x: x16, y: y1))
            bezierPath.close()
            fillColor3.setFill()
            bezierPath.fill()
            
        }
    }
    
    
    
}
