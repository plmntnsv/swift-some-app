//
//  Concentration.swift
//  Concetration
//
//  Created by Plamen on 5.11.18.
//  Copyright © 2018 Plamen. All rights reserved.
//

import Foundation

  struct Concentration {
    private(set) var cards = [Card]()
    private(set) var points = 0
    private(set) var flipCount = 0
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex: Int?
//            for index  in cards.indices {
//                if cards[index].isFaceUp{
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//
//            return foundIndex
        }
        set {
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    init(numberOfParisOfCards: Int){
        for _ in 1...numberOfParisOfCards{
            let card = Card()
            cards += [card,card]
        }
        
        cards.shuffle()
    }
    
    mutating func chooseCard(at index:Int){
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    points += 2
                } else {
                    if cards[matchIndex].isSeen{
                        points -= 1
                    }else{
                        cards[matchIndex].isSeen = true
                    }
                    
                    if cards[index].isSeen{
                        points -= 1
                    } else {
                        cards[index].isSeen = true
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
            
            flipCount += 1
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
