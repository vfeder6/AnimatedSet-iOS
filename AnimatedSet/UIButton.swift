//
//  UIButton.swift
//  Set
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

extension UIButton {
    func hide() {
        self.backgroundColor = UIColor.transparent
        self.isEnabled = false
    }
    
    func show(withBackground backgroundColor: UIColor = .systemGray6) {
        self.backgroundColor = backgroundColor
        self.isEnabled = true
    }
    
    func textColor(to color: UIColor) {
        self.setAttributedTitle(.init(string: self.title(for: .normal) ?? "",
                                      attributes: [.foregroundColor: color]),
                                for: .normal)
    }
    
    func deleteText(for state: UIButton.State = .normal) {
        self.setTitle(nil, for: state)
        self.setAttributedTitle(nil, for: state)
    }
    
    var disabled: Bool {
        get {
            !isEnabled
        }
        set {
            self.isEnabled = !newValue
            self.alpha = newValue ? 0.5 : 1.0
        }
    }
}
