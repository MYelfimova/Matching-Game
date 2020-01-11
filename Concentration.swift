//
//  Concentration.swift
//  Concentration
//
//  Created by Air on 30.11.2019.
//  Copyright © 2019 Hummus Inc. All rights reserved.
//

import Foundation

struct Concentration {
    
    //initialising a set of cards
    private(set) var cards = [Card]()
    
    var flipsCount = 0
    private(set) var pointsCount = 0
    
    private var indexOfOneAndOnlyCardFaceUp: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
 //           return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp{
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    

    // since I changed it to be a struct - so I have to make this function mutable.
    // Meaning that this function can "mutate" the instance variable of Concentration struct
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)")
        
        flipsCount += 1 // flipsCounter
        if !cards[index].isMatched{
            // HERE I SET hasBeenMatched PROPERTY
            if let matchIndex = indexOfOneAndOnlyCardFaceUp, matchIndex != index {
                
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    pointsCount = pointsCount+2 //+2 points when matched
                } else{
                    if cards[index].hasBeenSeen && cards[matchIndex].hasBeenSeen {
                        pointsCount = pointsCount-2
                        
                    } else if cards[index].hasBeenSeen || cards[matchIndex].hasBeenSeen {
                        
                        pointsCount = pointsCount-1
                    } else {
                        cards[index].hasBeenSeen = true
                        cards[matchIndex].hasBeenSeen = true
                    }
                }
                cards[index].isFaceUp = true
            }
            else {
                // else no card or 2 cards are faceup
                indexOfOneAndOnlyCardFaceUp = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards): Number of pairs of cards has to be for than 1")
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        
        // TODO: Shuffle cards
        cards = cards.shuffled()
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
