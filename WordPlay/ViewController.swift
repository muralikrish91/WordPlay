//
//  ViewController.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var queryLabel: UILabel!
    var gameControl = GameController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setQuestionPair()
        print(gameControl.level.currentTimeInterval);
    }
    
    @IBAction func yesTapped(_ sender: UIButton) {
        gameControl.checkSolution(isCorrect:true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.setQuestionPair()
        })
    }
    
    @IBAction func noTapped(_ sender: UIButton) {
        gameControl.checkSolution(isCorrect:false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.setQuestionPair()
        })
    }
    
    func setQuestionPair(){
        gameControl.setQuerySet()
        queryLabel.text = gameControl.wordSet.wordList[gameControl.querySet!.queryIndex].textEnglish
        answerLabel.text = gameControl.querySet!.toss ?  gameControl.wordSet.wordList[gameControl.querySet!.queryIndex].textSpanish : gameControl.wordSet.wordList[gameControl.querySet!.randomIndex].textSpanish
    }
}

