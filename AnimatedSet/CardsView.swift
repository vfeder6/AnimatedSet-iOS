//
//  CardsView.swift
//  GraphicalSet
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

class CardsView: UIView {
    private weak var delegate: UIGestureRecognizerDelegate?
    private var cards: [(CardView.Shape, UIColor, CardView.Shading, Int)] = .init() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        subviews.forEach { $0.removeFromSuperview() }
        
        var grid = Grid(layout: .aspectRatio(bounds.width / bounds.height), frame: bounds)
        grid.cellCount = cards.count
        
        for index in 0 ..< cards.count {
            if let cell = grid[index] {
                let cardView = CardView(frame: cell, shape: cards[index].0, color: cards[index].1, shading: cards[index].2, number: cards[index].3)
                let tapGestureRecognizer = UITapGestureRecognizer(target: delegate, action: #selector(ViewController.handleTap(_:)))
                cardView.addGestureRecognizer(tapGestureRecognizer)
                self.addSubview(cardView)
            }
        }
    }
    
    func updateCards(cards: [(CardView.Shape, UIColor, CardView.Shading, Int)], delegate: UIGestureRecognizerDelegate) {
        self.delegate = delegate
        self.cards = cards
    }
}
