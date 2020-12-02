//
//  SetGameDelegate.swift
//  Set
//
//  Created by Federico Veronesi on 21/11/2020.
//

protocol SetGameDelegate: AnyObject {
    func gameDidStart() -> [Card]
    func didSelectCard(_ card: Card)
    func didSelectDealCards() -> [Card]
    func didMakeSet(_ cards: [Card]) -> Bool
    func gameDidEnd()
}
