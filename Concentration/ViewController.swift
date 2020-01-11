//
//  ViewController.swift
//  Concentration
//
//  Created by Air on 22.11.2019.
//  Copyright © 2019 Hummus Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count+1)/2
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var pointsCountLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        print("New Game button is clicked")
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        game.flipsCount = 0
        updateViewFromModel()
        emojiTheme = updateEmoji(5.arc4random)
    }
    
    //BASICALLY allows me to generate as many cards as I want and to display on top of then whatever content I want
    @IBOutlet private var cardButtons: [UIButton]!
    
    //BASICALLY this func allows me to react on the clicks on the cards
    @IBAction private func touchCard(_ sender: UIButton) {

        //we find the index of the Button that was just clicked
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else{
            print("this card is not in the cardButtons array!!")
        }
    }
    
    // here I collate button(ui-element) and card(concentration element)
    private func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                if card.isMatched {
                    button.setBackgroundImage(nil, for: .normal)
                } else {
                    button.setBackgroundImage(UIImage(named: "btn_card.png"), for: .normal)
                }
            }
        }
        updateLabels(flips: game.flipsCount, points: game.pointsCount)
    }
    private func updateLabels(flips: Int, points: Int ) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if points < 0 {
            attributes = [.foregroundColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
        } else if points >= 5 {
            attributes = [
                .foregroundColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),
                .strokeWidth: 5.0]
        } else {
            attributes = [.foregroundColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
        }
        let attributeString = NSAttributedString(string: "Points: \(points)", attributes: attributes)
        pointsCountLabel.attributedText = attributeString
            
        flipCountLabel.text = "Flips: \(game.flipsCount)"
    }
      
    private lazy var emojiTheme = updateEmoji(5.arc4random)
    
    private var emoji = Dictionary<Card, String>()
    
    private func updateEmoji(_ numberOfTheme:Int) -> [String] {
           return ([0: ["⚽","🥎","🏀","🏈","🎾","🎳","🏓","🎣","🥊","⛸"],
           1 :["🍇","🍈","🍉","🍊","🍋","🍌","🍍","🥭","🍎","🍑"],
           2: ["🥞","🍗","🥓","🍔","🍟","🍕","🌭","🥪","🌮","🌯"],
           3: ["🐹","🐰","🐽","🐮","🦄","🐺","🦊","🐈","🦁","🐶"],
           4: ["👻","🦇","🍎","🍬","🍪","😈","💀","🎃", "🧙🏻‍♀️","💨"]])[numberOfTheme]!
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiTheme.count > 0 {
            emoji[card] = emojiTheme.remove(at: emojiTheme.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}

// BASICALLY I extend the functionality of Int class. Now I can call the computed variable "arc4random" from any instance variable of class Int: ex 5.arc4random
extension Int {
    var arc4random: Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
