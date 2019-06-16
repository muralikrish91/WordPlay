//
//  GameController.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import Foundation

class GameController {
    let wordSet : WordSet
    var level : Level
    var points : Int = 0
    var wrongAnswerCount = 0
    var querySet:(queryIndex:Int,randomIndex:Int,toss:Bool)?
    init() {
        self.wordSet = WordSet();
        level = Level(level:1)
    }
    
    func setQuerySet(){
        querySet = chooseRandom(from: self.wordSet.wordList.count)
    }
    
    func chooseRandom(from:Int) -> (Int,Int,Bool){
        let queryIndex = Int.random(in: 0..<from)
        var randromIndex = Int.random(in: 0..<from)
        while (randromIndex == queryIndex){
            randromIndex = Int.random(in: 0..<from)
        }
        let coinToss = Bool.random()
        return (queryIndex,randromIndex,coinToss);
    }
    
    func checkSolution(isCorrect:Bool) -> Bool{
        if(isCorrect == querySet?.toss){
            points += level.currentPoints
            return true
        }
        wrongAnswerCount += 1
        points -= level.currentPoints/2
        return false
    }
    
    func checkIfGameOver() -> Bool {
        if wrongAnswerCount == level.getWrongAnswerCount(){
            return true
        }
        return false
    }
    
    func answerSkipped() -> Int{
        points =  points - (level.currentLevel+1)*2
        wrongAnswerCount += 1
        return points
    }
    
    func restartGame(){
        points = 0
        wrongAnswerCount = 0
        level.setLevel(level: 1)
    }
    
    func checkForLevelChange()->Bool{
        switch level.currentLevel {
        case 1:
            if points>=50{
                print("Level change")
                level.setLevel(level: 2)
                wrongAnswerCount = 0
                return true
            }
        case 2:
            if points>=120{
                print("Level change")
                level.setLevel(level: 3)
                wrongAnswerCount = 0
                return true
            }
        default:
            print("default")
        }
        return false
    }
}

