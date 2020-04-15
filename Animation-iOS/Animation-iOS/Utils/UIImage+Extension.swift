//
//  UIImage+Extension.swift
//  Animation-iOS
//
//  Created by Yebin Kim on 2020/04/15.
//  Copyright © 2020 Yebin Kim. All rights reserved.
//

import UIKit

extension UIImage {

    func rotate(_ radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        newImage = newImage?.withRenderingMode(.alwaysTemplate)
        
        return newImage
    }
    
}
