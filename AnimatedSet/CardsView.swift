//
//  CardsView.swift
//  GraphicalSet
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

class CardsView: UIView {
    weak var gestureDelegate: UIGestureRecognizerDelegate?
    private lazy var grid: Grid = {
        createGrid()
    }()
    private var cards: [(CardView.Shape, UIColor, CardView.Shading, Int)] = .init() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        func rearrange() {
            for index in 0 ..< subviews.count {
                if let cell = grid[index] {
                    subviews[index].frame = cell
                }
            }
        }
        
        grid.cellCount = cards.count
        
        if cards.count > subviews.count {
            rearrange()
            
            for index in subviews.count ..< cards.count {
                if let cell = grid[index] {
                    let cardView = CardView(frame: cell, shape: cards[index].0, color: cards[index].1, shading: cards[index].2, number: cards[index].3)
                    let tapGestureRecognizer = UITapGestureRecognizer(target: gestureDelegate, action: #selector(ViewController.handleTapGesture(_:)))
                    cardView.addGestureRecognizer(tapGestureRecognizer)
                    self.addSubview(cardView)
                }
            }
        } else {
            subviews.forEach { subview in
                if let cardView = subview as? CardView, !cards.contains(where: { $0 == (cardView.shape, cardView.color, cardView.shading, cardView.number) }) {
                    cardView.removeFromSuperview()
                }
            }
            rearrange()
        }
    }
    
    private func createGrid() -> Grid {
        var grid = Grid(layout: .aspectRatio(bounds.width / bounds.height), frame: bounds)
        grid.cellCount = cards.count
        return grid
    }
    
    func updateCards(_ cards: [(CardView.Shape, UIColor, CardView.Shading, Int)]) {
        if cards.count > self.cards.count {
            cards.forEach { card in
                if !self.cards.contains(where: { $0 == card }) {
                    self.cards.append(card)
                }
            }
        } else {
            self.cards.forEach { card in
                if !cards.contains(where: { $0 == card }) {
                    self.cards.remove(card)
                }
            }
        }
    }
}

extension Array where Element == (CardView.Shape, UIColor, CardView.Shading, Int) {
    mutating func remove(_ element: Element) {
        self.removeAll(where: { $0 == element })
    }
}
