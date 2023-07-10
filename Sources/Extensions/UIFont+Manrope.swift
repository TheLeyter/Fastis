//
//  File.swift
//  
//
//  Created by Leyter on 10.07.2023.
//

import UIKit
extension UIFont {
    enum ManropeType: String {
        case bold = "Manrope-Bold"
        case semiBold = "Manrope-SemiBold"
        case regular = "Manrope-Regular"
        case medium = "Manrope-Medium"
        case extraBold = "Manrope-ExtraBold"
    }
    
    static func manrope(ofSize: CGFloat, weight: ManropeType) -> UIFont {
        guard let font = UIFont(name: weight.rawValue, size: ofSize) else {
            fatalError("Font \(weight.rawValue) not found")
        }
        
        return font
    }
}
