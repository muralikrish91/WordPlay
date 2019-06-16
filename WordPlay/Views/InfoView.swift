//
//  InfoView.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

protocol InfoViewDelegate : class {
    func restartButtonTapped()
}

enum GameMode {
    case start
    case restart
    case paused
}
class InfoView: UIView {
    let kCONTENT_XIB_NAME = "InfoView"
    @IBOutlet var contentView: UIView!
    weak var delegate:InfoViewDelegate?
    var state:GameMode = .start {
        didSet{
            switch state {
            case .start:
                self.infoLabel.text = "Start";
            default:
                self.infoLabel.text = "Game Over";
            }
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func infoPlayTapped(_ sender: UIButton) {
        delegate?.restartButtonTapped()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.cgColor
    }
}
