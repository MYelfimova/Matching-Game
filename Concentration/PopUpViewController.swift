//
//  PopUpViewController.swift
//  Concentration
//
//  Created by Maria Yelfimova on 1/18/20.
//  Copyright © 2020 Hummus Inc. All rights reserved.
//
import UIKit
import AVFoundation





class PopUpViewController: UIViewController {
    
    let vc = ViewController()
    
//    private lazy var game = Concentration(numberOfPairsOfCards: vc.numberOfPairsOfCards)
//
//    var numberOfPairsOfCards: Int {
//        get {
//            return (cardButtons.count+1)/2
//        }
//    }
    
//    var audioPlayer = AVAudioPlayer()
//    let buttonClickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "btn_click", ofType: "wav")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.1418920159, green: 0.1418920159, blue: 0.1418920159, alpha: 0.5980413732)
    }
    
    @IBAction func resumeGame(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func newGame(_ sender: Any) {
        
        // TODO: rewrite this block of code with. Clue: maybe I should deal with lazy varibles.
        vc.playSound(soundName: vc.buttonClickSound)
        vc.game = Concentration(numberOfPairsOfCards: vc.numberOfPairsOfCards)
        vc.updateViewFromModel()
        vc.emojiTheme = vc.updateEmoji(5.arc4random)
        
        self.view.removeFromSuperview()
    }
    
    @IBAction func goToMenu(_ sender: Any) {
        vc.playSound(soundName: vc.buttonClickSound)
    }
    
}
