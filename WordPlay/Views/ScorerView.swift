//
//  ScorerView.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

class ScorerView:UILabel{

    var value:Int = 0 {
        didSet {
            self.text = " \(value)"
        }
    }
    
    private var endValue: Int = 0
    private var timer: Timer? = nil
    
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
    }
    
    @objc func updateValue(timer:Timer) {
        if (endValue < value) {
            value -= 1
        } else {
            value += 1
        }
        if (endValue == value) {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    func setValue(newValue:Int, duration:Float) {
        endValue = newValue
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        let deltaValue = abs(endValue - value)
        if (deltaValue != 0) {
            var interval = Double(duration / Float(deltaValue))
            if interval < 0.01 {
                interval = 0.01
            }
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.updateValue), userInfo: nil, repeats: true)
        }
    }
}

