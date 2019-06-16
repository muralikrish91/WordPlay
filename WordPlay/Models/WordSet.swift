//
//  WordSet.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import Foundation

struct Word {
    let textSpanish: String
    let textEnglish: String
    
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            textSpanish = ""; textEnglish="";
            return
        }
        textSpanish = dictionary["text_spa"] as! String
        textEnglish = dictionary["text_eng"] as! String
    }
}
class WordSet{
    var wordList = [Word]()
    
    init(){
        readFileFromJson()
    }
    
    func readFileFromJson(){
        if let path = Bundle.main.path(forResource: "words", ofType: "json"){
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options:.mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let wordArray = jsonResult as? [Any]{
                    for (word) in wordArray{
                        wordList.append(Word(with: word as? [String : Any]))
                    }
                }
                
            }catch{
                
            }
        }
    }
}
