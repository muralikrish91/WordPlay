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
            print("Inside while loop")
        }
        let coinToss = Bool.random()
        return (queryIndex,randromIndex,coinToss);
    }
    
    func checkSolution(isCorrect:Bool){
        if(isCorrect == querySet?.toss){
            print("right option")
        }else{
            print("wrong option")
        }
    }
}

