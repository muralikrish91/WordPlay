//
//  WordPlayTests.swift
//  WordPlayTests
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import XCTest
@testable import WordPlay

class WordPlayTests: XCTestCase {

    var gameControlObj:GameController!
    override func setUp() {
        super.setUp()
        gameControlObj = GameController()
    }
    
    override func tearDown() {
        gameControlObj = nil
        super.tearDown()
    }
    
    func testQuerySetParams() {
        gameControlObj.setQuerySet()
        XCTAssert(gameControlObj.querySet?.queryIndex != gameControlObj.querySet?.randomIndex, "Query Set can't have same question and answer pair")
    }
    
    func testCheckCorrectSolution() {
        let oldPoints = gameControlObj.points
        gameControlObj.setQuerySet()
        let solution = gameControlObj.checkSolution(isCorrect: gameControlObj.querySet!.toss)
        XCTAssert(solution == true , "Solution not matched")
        XCTAssert(gameControlObj.points == (oldPoints+gameControlObj.level.currentPoints), "Points doesnt match")
    }
    
    func testCheckWrongSolution() {
        let oldPoints = gameControlObj.points
        gameControlObj.setQuerySet()
        let solution = gameControlObj.checkSolution(isCorrect: !gameControlObj.querySet!.toss)
        XCTAssert(solution == false , "Solution not matched")
        XCTAssert(gameControlObj.points == (oldPoints-gameControlObj.level.currentPoints/2), "Points doesnt match")
    }
    
    func testWhenGameSkipped(){
        let oldPoints = gameControlObj.points
        let wrongPointCount = gameControlObj.wrongAnswerCount
        gameControlObj.setQuerySet()
        let newPoints = gameControlObj.answerSkipped()
        XCTAssert(newPoints == (oldPoints - (gameControlObj.level.currentLevel+1)*2) , "Points wrongly calculated")
        XCTAssert(wrongPointCount == gameControlObj.wrongAnswerCount-1, "Wrong answer count is not matched")
    }
    
    func  testCheckIfGameOver() {
        gameControlObj.level.currentLevel = 1
        gameControlObj.wrongAnswerCount = 3
        XCTAssert(gameControlObj.checkIfGameOver() , "Game over not recognized")
    }
    
    func testIfWordSetIsAvailable() {
        let wordList = gameControlObj.wordSet.wordList
        print(wordList.count)
        XCTAssert(wordList.count == 297, "Wordlist array not matched")
    }
    
    func testLevelObject(){
        gameControlObj.level.setLevel(level: 3)
        XCTAssert(gameControlObj.level.currentPoints == 30, "Level Points not set properly")
    }
    
    func testForLevelChange(){
        gameControlObj.points = 55
        gameControlObj.level.currentLevel = 1
        XCTAssert(gameControlObj.checkForLevelChange(), "Points doesnt matched")
        XCTAssert(gameControlObj.level.currentLevel == 2, "Level not incremented")
    }
    

}
