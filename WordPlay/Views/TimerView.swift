//
//  TimerView.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

protocol TimerControlDelegate {
    func timerDidEnd()
}

class TimerView : UILabel {
    var secondsLeft = 0
    var timer:Timer?
    var timeInterval = 0
    var timerDelegate:TimerControlDelegate?
    
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    func setSeconds(_ seconds:Int) {
        self.text = String(format: " %02i : %02i", seconds/60, seconds % 60)
    }
    
    func startTimer() {
        secondsLeft = timeInterval
        self.setSeconds(secondsLeft)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.ticker), userInfo: nil, repeats: true)
    }
    
    @objc func ticker(_ timer: Timer) {
        secondsLeft -= 1
        self.setSeconds(secondsLeft)
        if secondsLeft == 0 {
            self.stopTimer()
            timerDelegate?.timerDidEnd()
        }
    }
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
}
