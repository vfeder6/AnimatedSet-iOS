//
//  ViewController.swift
//  Set
//
//  Created by Federico Veronesi on 21/11/2020.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    private let maxDealingCards = 3
    private let initialCards = 12
    private var game = SetGame()
    private var currentCards = [Card]()
    private var selectedCards = [Int: Card]()
    private var matchedCards = [Int: Card]()
    private var startingDatetime = Date()
    private var scoreMultiplier: Int {
        switch -Int(startingDatetime.timeIntervalSinceNow) {
        case 0 ..< 120:
            return 10
        case 120 ..< 249:
            return 5
        case 240 ..< 360:
            return 2
        default:
            return 1
        }
    }
    private var scoreCount = 0 {
        didSet {
            scoreLabel.text = "Score: \(scoreCount * scoreMultiplier)"
            winningLabel.text = "You win! 🥳\nScore: \(scoreCount * scoreMultiplier)"
        }
    }
    private var gameEnded: Bool = false {
        didSet {
            dealCardsButton.isHidden = gameEnded
            scoreLabel.isHidden = gameEnded
            newGameButton.isHidden = gameEnded
            
            winningLabel.isHidden = !gameEnded
            winningNewGameButton.isHidden = !gameEnded
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cardsView: CardsView! {
        didSet {
            let swipeGestureRegognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture(_:)))
            swipeGestureRegognizer.direction = .down
            swipeGestureRegognizer.delegate = self
            let rotationRestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
            rotationRestureRecognizer.delegate = self
            
            cardsView.addGestureRecognizer(swipeGestureRegognizer)
            cardsView.addGestureRecognizer(rotationRestureRecognizer)
            cardsView.gestureDelegate = self
        }
    }
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.setTitle("New game", for: .normal)
        }
    }
    @IBOutlet weak var winningNewGameButton: UIButton! {
        didSet {
            winningNewGameButton.setTitle("New game", for: .normal)
        }
    }
    @IBOutlet weak var dealCardsButton: UIButton! {
        didSet {
            dealCardsButton.setAttributedTitle(NSAttributedString(string: "Deal cards"), for: .normal)
            cardsView.deckFrame = dealCardsButton.frame
        }
    }
    @IBOutlet weak var winningLabel: UILabel! {
        didSet {
            winningLabel.numberOfLines = 0
        }
    }
    
    // MARK: Lifecycle ovverides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        currentCards = game.start()
        updateCardsView()
    }
    
    // MARK: UI Methods
    private func updateCardsView() {
        cardsView.updateCards(convertForView(currentCards))
    }
    
    private func cardView(for card: Card) -> CardView {
        return cardsView.subviews.filter { view in
            let cardView = view as! CardView
            let convertedCard = convertForModel((cardView.shape!, cardView.color!, cardView.shading!, cardView.number!))
            return convertedCard == card
        }[0] as! CardView
    }
    
    // TODO Refactor
    private func convertForView(_ cards: [Card]) -> [(CardView.Shape, UIColor, CardView.Shading, Int)] {
        var convertedCards = [(CardView.Shape, UIColor, CardView.Shading, Int)]()
        
        cards.forEach { card in
            var shape: CardView.Shape
            
            switch card.shape {
            case .first:
                shape = .diamond
            case .second:
                shape = .oval
            case .third:
                shape = .squiggle
            }
            
            var color: UIColor
            
            switch card.color {
            case .first:
                color = .setGameRed
            case .second:
                color = .setGameGreen
            case .third:
                color = .setGamePurple
            }
            
            var shading: CardView.Shading
            
            switch card.shading {
            case .first:
                shading = .open
            case .second:
                shading = .solid
            case .third:
                shading = .striped
            }
            
            var number: Int
            
            switch card.number {
            case .first:
                number = 1
            case .second:
                number = 2
            case .third:
                number = 3
            }
            
            convertedCards.append((shape, color, shading, number))
        }
        return convertedCards
    }
    
    private func convertForModel(_ card: (CardView.Shape, UIColor, CardView.Shading, Int)) -> Card {
        var shape: Card.Value
        
        switch card.0 {
        case .diamond:
            shape = .first
        case .oval:
            shape = .second
        case .squiggle:
            shape = .third
        }
        
        var color: Card.Value?
        
        switch card.1 {
        case .setGameRed:
            color = .first
        case .setGameGreen:
            color = .second
        case .setGamePurple:
            color = .third
        default:
            color = nil
        }
        
        var shading: Card.Value
        
        switch card.2 {
        case .open:
            shading = .first
        case .solid:
            shading = .second
        case .striped:
            shading = .third
        }
        
        var number: Card.Value?
        
        switch card.3 {
        case 1:
            number = .first
        case 2:
            number = .second
        case 3:
            number = .third
        default:
            number = nil
        }
        return Card(number: number!, shape: shape, shading: shading, color: color!)
    }
    
    // MARK: Actions
    @IBAction func dealCardsSelected(_ sender: UIButton) {
        currentCards += game.dealCards()
        updateCardsView()
    }
    
    @IBAction func newGameSelected(_ sender: UIButton) {
        scoreCount = 0
        
        game = .init()
        game.delegate = self
        currentCards = game.start()
        selectedCards = .init()
        matchedCards = .init()
        dealCardsButton.disabled = false
        
        updateCardsView()
        gameEnded = false
    }
}

// MARK: Delegation conformance
extension ViewController: SetGameDelegate {
    func gameDidStart() -> [Card] {
        dealCardsButton.setAttributedTitle(NSAttributedString(string: "No more space!"), for: .disabled)
        scoreCount = 0
        startingDatetime = .init()
        gameEnded = false
        return game.cardsFromDeck(initialCards)
    }
    
    func didSelectCard(_ card: Card) {
        let index = currentCards.firstIndex(of: card)!
        let view = cardView(for: currentCards[index])
        
        // Deselecting card if it was already selected
        if selectedCards[index] == currentCards[index] {
            scoreCount -= 1
            selectedCards.removeValue(forKey: index)
            view.selected = false
        } else {
            selectedCards[index] = currentCards[index]
            view.selected = true
        }
        
        if selectedCards.count == 3 {
            if game.isSet(for: selectedCards.values.map { $0 }) {
                scoreCount += 3
                
                selectedCards.forEach { card in
                    currentCards.removeAll(where: { $0 == card.value })
                }
                updateCardsView()
                
                if !game.isDeckFinished {
                    dealCardsButton.textColor(to: .systemRed)
                    dealCardsButton.disabled = false
                }
            } else {
                scoreCount -= 5
            }
            // TODO: set selected to false from cardViews before emptying selectedCards
            selectedCards.values.forEach { card in
                cardView(for: card).selected = false
            }
            selectedCards = [:]
        }
    }
    
    func didSelectDealCards() -> [Card] {
        if matchedCards.count != 0 {
            let keys = matchedCards.keys.sorted(by: { $0 > $1 })
            for key in keys {
                currentCards.remove(at: key)
                matchedCards.removeValue(forKey: key)
            }
        }
        let newCards = game.cardsFromDeck(maxDealingCards)
        
        if game.isDeckFinished {
            dealCardsButton.disabled = true
        }
        
        dealCardsButton.textColor(to: .systemBlue)
        if game.isDeckFinished {
            dealCardsButton.setAttributedTitle(NSAttributedString(string: "Deck is over!"), for: .disabled)
        }
        return newCards
    }
    
    // TODO refactor
    func didMakeSet(_ cards: [Card]) -> Bool {
        if cards[0].number == cards[1].number {
            if cards[1].number != cards[2].number {
                return false
            }
        } else if cards[1].number == cards[2].number {
            return false
        } else if cards[0].number == cards[2].number {
            return false
        }
        
        if cards[0].color == cards[1].color {
            if cards[1].color != cards[2].color {
                return false
            }
        } else if cards[1].color == cards[2].color {
            return false
        } else if cards[0].color == cards[2].color {
            return false
        }
        
        if cards[0].shape == cards[1].shape {
            if cards[1].shape != cards[2].shape {
                return false
            }
        } else if cards[1].shape == cards[2].shape {
            return false
        } else if cards[0].shape == cards[2].shape {
            return false
        }
        
        if cards[0].shading == cards[1].shading {
            if cards[1].shading != cards[2].shading {
                return false
            }
        } else if cards[1].shading == cards[2].shading {
            return false
        } else if cards[0].shading == cards[2].shading {
            return false
        }
        
        return true
    }
    
    func gameDidEnd() {
        gameEnded = true
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        guard let cardView = sender.view as? CardView else {
            return
        }
        
        let convertedCard = convertForModel((cardView.shape!, cardView.color!, cardView.shading!, cardView.number!))
        
        switch sender.state {
        case .ended:
            game.cardSelected(convertedCard)
        default:
            break
        }
        
        if currentCards.count == matchedCards.count && game.isDeckFinished {
            game.end()
        }
    }
    
    @objc func handleSwipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            currentCards += game.dealCards()
            updateCardsView()
        default:
            break
        }
    }
    
    @objc func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            currentCards.shuffle()
            updateCardsView()
        default:
            break
        }
    }
}
