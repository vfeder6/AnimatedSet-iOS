//
//  UIColor.swift
//  Set
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

extension UIColor {
    static var transparent: Self {
        Self(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    static var setGameRed: Self {
        Self(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
    }
    
    static var setGamePurple: Self {
        Self(red: 0.6, green: 0.30, blue: 1.0, alpha: 1.0)
    }
    
    static var setGameGreen: Self {
        Self(red: 0.4, green: 0.6, blue: 0.2, alpha: 1.0)
    }
    
    static var setGameBackground: Self {
        Self(red: 1.0, green: 0.97, blue: 0.68, alpha: 1.0)
    }
    
    static var setGameSelected: Self {
        Self(red: 0.94, green: 0.35, blue: 0.19, alpha: 1.0)
    }
}
