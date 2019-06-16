//
//  Level.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import Foundation

class Level {
    let pointsArray = [10,20,30]
    let timeArray = [10,8,6]
    let wrongAnswer = [3,2,1]
    var currentLevel:Int = 1
    var currentPoints:Int!
    var currentTimeInterval:Int!
    init(level:Int) {
        setLevel(level: level)
    }
    
    func setLevel(level:Int){
        currentLevel = level
        currentTimeInterval = timeArray[currentLevel-1]
        currentPoints = pointsArray[currentLevel-1]
    }
    
    func getWrongAnswerCount() -> Int{
        return wrongAnswer[currentLevel-1]
    }
    
}
