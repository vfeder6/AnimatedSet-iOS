//
//  SetGame.swift
//  Set
//
//  Created by Federico Veronesi on 21/11/2020.
//

struct SetGame {
    private let cards: [Card]
    private var nextCardIndex: Int
    var isDeckFinished: Bool {
        cards.count - nextCardIndex == 0
    }
    
    weak var delegate: SetGameDelegate?
    
    init() {
        var cards = [Card]()
        
        for numberValue in Card.Value.all {
            for shapeValue in Card.Value.all {
                for shadingValue in Card.Value.all {
                    for colorValue in Card.Value.all {
                        cards.append(.init(number: numberValue, shape: shapeValue, shading: shadingValue, color: colorValue))
                    }
                }
            }
        }
        cards.shuffle()
        self.cards = cards
        nextCardIndex = 0
    }
    
    mutating func cardsFromDeck(_ quantity: Int) -> [Card] {
        var cards = [Card]()
        
        for index in nextCardIndex ..< nextCardIndex + quantity {
            if self.cards.count != nextCardIndex {
                cards.append(self.cards[index])
                nextCardIndex += 1
            }
        }
        
        return cards
    }
    
    func start() -> [Card] {
        return delegate!.gameDidStart()
    }
    
    func cardSelected(_ card: Card) {
        delegate!.didSelectCard(card)
    }
    
    func dealCards() -> [Card] {
        return delegate!.didSelectDealCards()
    }
    
    func isSet(for cards: [Card]) -> Bool {
        return delegate!.didMakeSet(cards)
    }
    
    func end() {
        delegate!.gameDidEnd()
    }
}
