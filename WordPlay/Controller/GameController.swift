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
        points -= level.currentPoints/2
        return false
    }
    
    func answerSkipped() -> Int{
        points =  points - (level.currentLevel+1)*2
        return points
    }
}

