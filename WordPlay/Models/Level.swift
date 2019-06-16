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
    var currentLevel:Int = 0
    var currentPoints:Int!
    var currentTimeInterval:Int!
    init(level:Int) {
        setLevel(level: level)
    }
    
    func setLevel(level:Int){
        currentLevel = level
        currentTimeInterval = timeArray[currentLevel]
        currentPoints = pointsArray[currentLevel]
    }
    
}
