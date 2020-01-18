//
//  ViewController.swift
//  Concentration
//
//  Created by Air on 22.11.2019.
//  Copyright © 2019 Hummus Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // defining all my sounds <
    var audioPlayer = AVAudioPlayer()
    var queuePlayer = AVQueuePlayer()
    var playerLooper: AVPlayerLooper?
    var bgMusicIsPlaying = true
    
    let buttonClickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "btn_click", ofType: "wav")!)
    let cardFlipSound = URL(fileURLWithPath: Bundle.main.path(forResource: "card_flip", ofType: "wav")!)
    let cardMatchSound = URL(fileURLWithPath: Bundle.main.path(forResource: "card_match", ofType: "wav")!)
    // >finished defining all my sounds

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = Bundle.main.url(forResource: "bg_music", withExtension: "mp3") else { return }
        let playerItem = AVPlayerItem(asset: AVAsset(url: url))
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        queuePlayer.play()
    }
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons == nil) ? 10 : (cardButtons.count+1)/2
        }
    }
    
    @IBAction func SoundOnOff(_ sender: UIButton) {
        playSound(soundName: buttonClickSound)
        if bgMusicIsPlaying == true{
            queuePlayer.pause()
            bgMusicIsPlaying = false
            sender.setBackgroundImage(UIImage(named: "btn_sound_off.png"), for: .normal)
        }
        else {
            queuePlayer.play()
            bgMusicIsPlaying = true
            sender.setBackgroundImage(UIImage(named: "btn_sound_on.png"), for: .normal)
        }
    }
    
    @IBOutlet weak var pointsCountLabel: UILabel!
    
    @IBAction func pausePopUp(_ sender: UIButton) {
        playSound(soundName: buttonClickSound)
//        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
//        updateViewFromModel()
//        emojiTheme = updateEmoji(5.arc4random)
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pausePopUpID") as! PopUpViewController
        
        self.addChild(popOverVC)
        
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    //BASICALLY allows me to generate as many cards as I want and to display on top of then whatever content I want
    @IBOutlet var cardButtons: [UIButton]!
    
    //BASICALLY this func allows me to react on the clicks on the cards
    @IBAction func touchCard(_ sender: UIButton) {
        //sound effect:
        playSound(soundName: cardFlipSound)
        //we find the index of the Button that was just clicked
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            if game.makeMatchSound {
                playSound(soundName: cardMatchSound)
                game.makeMatchSound = false
            }
            updateViewFromModel()
        } else{
            print("this card is not in the cardButtons array!!")
        }
        
    }
    
    // here I collate button(ui-element) and card(concentration element)
    func updateViewFromModel(){
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
        updateLabels(points: game.pointsCount)
    }
    func updateLabels(points: Int ) {
        pointsCountLabel.text = "\(points)"
    }
    
    func playSound(soundName:URL){
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: soundName)
             audioPlayer.play()
        } catch {
           print("couldn't load file :\(soundName)")
        }
    }
      
    lazy var emojiTheme = updateEmoji(5.arc4random)
    
    var emoji = Dictionary<Card, String>()
    
    func updateEmoji(_ numberOfTheme:Int) -> [String] {
           return ([0: ["⚽","🥎","🏀","🏈","🎾","🎳","🏓","🎣","🥊","⛸"],
           1 :["🍇","🍈","🍉","🍊","🍋","🍌","🍍","🥭","🍎","🍑"],
           2: ["🥞","🍗","🥓","🍔","🍟","🍕","🌭","🥪","🌮","🌯"],
           3: ["🐹","🐰","🐽","🐮","🦄","🐺","🦊","🐈","🦁","🐶"],
           4: ["👻","🦇","🍎","🍬","🍪","😈","💀","🎃", "🧙🏻‍♀️","💨"]])[numberOfTheme]!
    }
    
    func emoji(for card: Card) -> String {
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
