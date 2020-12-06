//
//  CardsView.swift
//  GraphicalSet
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

class CardsView: UIView {
    weak var gestureDelegate: UIGestureRecognizerDelegate?
    var deckFrame: CGRect?
    private let standardAnimationDuration: TimeInterval = 0.5
    private lazy var grid: Grid = {
        createGrid()
    }()
    private var cards: [(CardView.Shape, UIColor, CardView.Shading, Int)] = .init() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        func rearrange(after delay: TimeInterval = 0.0) {
            for index in 0 ..< subviews.count {
                if let cell = grid[index] {
                    animate(subviews[index], after: delay) { self.subviews[index].frame = cell }
                }
            }
        }
        
        grid = createGrid()
        
        if cards.count > subviews.count {
            rearrange()
            
            for index in subviews.count ..< cards.count {
                if let cell = grid[index] {
                    let cardView = CardView(frame: deckFrame ?? CGRect.zero, shape: cards[index].0, color: cards[index].1, shading: cards[index].2, number: cards[index].3)
                    let tapGestureRecognizer = UITapGestureRecognizer(target: gestureDelegate, action: #selector(ViewController.handleTapGesture(_:)))
                    cardView.addGestureRecognizer(tapGestureRecognizer)
                    cardView.alpha = 0.0
                    cardView.frame = deckFrame ?? CGRect.zero
                    animate(cardView, withDuration: 2, after: standardAnimationDuration) { cardView.frame = cell; cardView.alpha = 1.0 }
                    self.addSubview(cardView)
                }
            }
        } else {
            subviews.forEach { subview in
                if let cardView = subview as? CardView, !cards.contains(where: { $0 == (cardView.shape, cardView.color, cardView.shading, cardView.number) }) {
                    animate(cardView) { cardView.alpha = 0.0 }
                    animate(cardView, after: standardAnimationDuration) { cardView.removeFromSuperview() }
                }
            }
            rearrange(after: standardAnimationDuration + 0.1)
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

extension CardsView {
    func animate(_ view: UIView,
                 withDuration duration: TimeInterval = 0.5,
                 options: UIView.AnimationOptions = [.curveEaseInOut],
                 after delay: TimeInterval? = nil,
                 _ animations: @escaping () -> Void,
                 completion: ((Bool) -> Void)? = nil) {
        let animation: (() -> Void) = {
            Self.transition(with: view,
                            duration: duration,
                            options: options,
                            animations: animations,
                            completion: completion)
            
        }
        
        if let time = delay {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in animation() }
        } else {
            animation()
        }
    }
}

extension Array where Element == (CardView.Shape, UIColor, CardView.Shading, Int) {
    mutating func remove(_ element: Element) {
        self.removeAll(where: { $0 == element })
    }
}
