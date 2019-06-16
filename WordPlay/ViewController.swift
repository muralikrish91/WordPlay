//
//  ViewController.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimerControlDelegate {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var queryLabel: UILabel!
    var gameControl = GameController()
    var timerView: TimerView!
    var scorerView: ScorerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimerView()
        setScorerView()
        setQuestionPair()
    }
    
    func setTimerView(){
        self.timerView = TimerView(frame:CGRect(x:50,y: 0,width: 300,height: 100))
        self.timerView.timerDelegate = self
        self.timerView.setSeconds(0)
        self.timerView.timeInterval = gameControl.level.currentTimeInterval
        view.addSubview(timerView)
    }
    
    func timerDidEnd() {
        scorerView.setValue(newValue:gameControl.answerSkipped(), duration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.setQuestionPair()
        })
    }
    
    func setScorerView(){
        self.scorerView = ScorerView(frame:CGRect(x:150,y: 0,width: 300,height: 100))
        self.scorerView.value = 0
        view.addSubview(scorerView)
    }
    
    @IBAction func yesTapped(_ sender: UIButton) {
        submitSolution(true)
    }
    
    @IBAction func noTapped(_ sender: UIButton) {
        submitSolution(false)
    }
    
    func submitSolution(_ isCorrect:Bool){
        timerView.stopTimer()
        print(gameControl.checkSolution(isCorrect:isCorrect))
        scorerView.setValue(newValue: gameControl.points, duration: 1.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.setQuestionPair()
        })
    }
    
    func setQuestionPair(){
        gameControl.setQuerySet()
        print(gameControl.points)
        queryLabel.text = gameControl.wordSet.wordList[gameControl.querySet!.queryIndex].textEnglish
        answerLabel.text = gameControl.querySet!.toss ?  gameControl.wordSet.wordList[gameControl.querySet!.queryIndex].textSpanish : gameControl.wordSet.wordList[gameControl.querySet!.randomIndex].textSpanish
        timerView.startTimer()
    }
}

