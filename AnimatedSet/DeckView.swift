//
//  DeckView.swift
//  AnimatedSet
//
//  Created by Federico Veronesi on 06/12/2020.
//

import UIKit

class DeckView: UIView {
    var dealingEnabled = false {
        didSet {
            if dealingEnabled {
                animate(self) { self.backgroundColor = .setGameBackground }
            } else {
                animate(self) { self.backgroundColor = .brown }
            }
        }
    }
}
