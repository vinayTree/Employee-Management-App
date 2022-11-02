//
//  UIColor.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    static let backgroundColor = UIColor.rgb(r: 10, g: 14, b: 33)
    
    static let activeColor = UIColor.rgb(r: 29, g: 30, b: 51)
    static let inactiveColor = UIColor.rgb(r: 17, g: 19, b: 40)
    
    static let primaryColor = UIColor.rgb(r: 235, g: 21, b: 85)
    static let primaryColorFaded = UIColor.rgb(r: 66, g: 26, b: 59)

}
