//
//  ViewController.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,InfoViewDelegate {
    
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var imvWrongBin: UIImageView!
    @IBOutlet weak var imvCorrectBin: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scorerLabel: ScorerView!
    var infoView:InfoView!
    let labelTag = 1757
    var gameControl = GameController()
    var dynamicAnimator : UIDynamicAnimator!
    var answer = false
    var chosenAnswer = false
    var isPauseTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Pattern")!)
        setQueryLabel()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        scorerLabel.value = 0
        infoView = InfoView(frame: CGRect(x:100,y:(view.bounds.height/2 - 100),width:200,height:200))
        infoView.delegate = self
        infoView.center.x  = -view.center.x
        view.addSubview(infoView)
        showInfoView()
        levelLabel.text = "\(gameControl.level.currentLevel)"
        playPauseButton.isHidden = true
        setUpGestureRecognizer()
    }
    
    
    func restartButtonTapped() {
        gameControl.restartGame()
        scorerLabel.value = 0
        levelLabel.text = "\(gameControl.level.currentLevel)"
        answer = false
        setQuestionPair()
        hideInfoView()
    }
    
    
    func setQueryLabel() {
        queryLabel.textColor = UIColor.white
        queryLabel.backgroundColor = UIColor(red: 246.0/255.0, green: 106.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        queryLabel.clipsToBounds = true
        queryLabel.layer.cornerRadius = 20
        queryLabel.layer.shadowRadius = 2
        queryLabel.layer.borderColor = UIColor.white.cgColor
        queryLabel.text = "WORD PLAY"
    }
    
    func removeGravityBehaviors() {
        for behavior in dynamicAnimator.behaviors {
            if behavior is UIGravityBehavior {
                dynamicAnimator.removeBehavior(behavior)
            }
        }
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        isPauseTapped = !isPauseTapped
        configurePauseButton()
        if isPauseTapped{
            dynamicAnimator.removeAllBehaviors()
        }else{
            UIView.animate(withDuration: 0.5) {
                self.infoView.center.x -= self.view.bounds.width
            }
            
            addGravityBehaviour()
        }
    }
    
    func showInfoView(){
        playPauseButton.isHidden = true
        isPauseTapped = true
        UIView.animate(withDuration: 0.5) {
            self.infoView.center.x = self.view.center.x
        }
    }
    
    func hideInfoView(){
        playPauseButton.isHidden = false
        isPauseTapped = false
        UIView.animate(withDuration: 0.5) {
            self.infoView.center.x = -self.view.center.x
        }
    }
    
    func setupAnswerLabel(text : String?) {
        let label = UILabel()
        label.tag = labelTag
        label.preferredMaxLayoutWidth = 0.7 * self.view.bounds.width
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        label.text = text
        label.font = UIFont(name: "comic andy", size: 70)
        label.textColor = UIColor.white
        label.frame = CGRect(x: 0, y: queryLabel.frame.maxY, width: label.intrinsicContentSize.width + 20, height: label.intrinsicContentSize.height + 10)
        label.center.x = view.center.x
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        addGravityBehaviour()
    }
    
    func addGravityBehaviour(){
        guard let label = self.view.viewWithTag(labelTag) else { return }
        let gravityBehaviour = UIGravityBehavior(items: [label])
        gravityBehaviour.action = { [weak self] in
            if let strongSelf = self {
                if label.frame.origin.y > UIScreen.main.bounds.height {
                    strongSelf.scorerLabel.setValue(newValue: strongSelf.gameControl.answerSkipped(), duration: 0.5)
                    gravityBehaviour.action = nil
                    label.removeFromSuperview()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        strongSelf.setQuestionPair()
                    })
                }
            }
        }
        gravityBehaviour.magnitude = 0.08
        dynamicAnimator.removeAllBehaviors()
        dynamicAnimator.addBehavior(gravityBehaviour)
    }
    
    func setUpGestureRecognizer(){
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.rightSwipe))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.leftSwipe))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    
    private func checkAnswer() -> Bool {
        return answer
    }
    
    func configurePauseButton(){
        if isPauseTapped{
            playPauseButton.setImage(UIImage(named: "play-button"), for: .normal)
        }else{
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc func rightSwipe(recognizer: UISwipeGestureRecognizer){
        if isPauseTapped{
            return
        }
        chosenAnswer = true
        answer = gameControl.checkSolution(isCorrect: true)
        addDropAnimationForView(self.imvCorrectBin, isSolutionCorrect: answer)
    }
    
    @objc func leftSwipe(recognizer: UISwipeGestureRecognizer) {
        if isPauseTapped{
            return
        }
        chosenAnswer = false
        answer = gameControl.checkSolution(isCorrect: false)
        addDropAnimationForView(self.imvWrongBin, isSolutionCorrect: answer)
    }
    
    func addDropAnimationForView(_ refView:UIImageView,isSolutionCorrect:Bool){
        guard let gestureView = self.view.viewWithTag(labelTag) else { return }
        // chosenAnswer = true
        dynamicAnimator.removeAllBehaviors()
        // answer = gameControl.checkSolution(isCorrect:true)
        let path = UIBezierPath()
        path.move(to: gestureView.center)
        path.addQuadCurve(to: isSolutionCorrect ? refView.center : CGPoint(x: refView.frame.midX, y: refView.frame.minY), controlPoint: CGPoint(x:refView.frame.midX, y: gestureView.frame.midY - 20))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = 1.0
        animation.isRemovedOnCompletion = false
        gestureView.layer.add(animation, forKey: "pathAnimation")
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.setValue("scale", forKey: "AnimationIdentifier")
        scaleAnimation.delegate = self
        scaleAnimation.fromValue = gestureView.transform.a
        scaleAnimation.toValue = 0.3
        scaleAnimation.duration = 1.0
        scaleAnimation.isRemovedOnCompletion = false
        gestureView.layer.add(scaleAnimation, forKey: "scale")
        gestureView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    }
    
    func setQuestionPair(){
        if(gameControl.checkIfGameOver()){
            infoView.state = .restart
            self.showInfoView()
            return
        }
        if answer {
            if(gameControl.checkForLevelChange()){
                levelLabel.text = "\(gameControl.level.currentLevel)"
            }
        }
        gameControl.setQuerySet()
        print(gameControl.points)
        queryLabel.text = gameControl.wordSet.wordList[gameControl.querySet!.queryIndex].textEnglish
        
        let answerLabelText = gameControl.querySet!.toss ?  gameControl.wordSet.wordList[gameControl.querySet!.queryIndex].textSpanish : gameControl.wordSet.wordList[gameControl.querySet!.randomIndex].textSpanish
        setupAnswerLabel(text: answerLabelText)
    }
}

extension ViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let label = self.view.viewWithTag(labelTag) else {
            return
        }
        if let value = anim.value(forKey: "AnimationIdentifier") as? String {
            if value == "scale" {
                if checkAnswer() == false {
                    if(chosenAnswer){
                        label.center = CGPoint(x: self.imvCorrectBin.frame.midX, y: self.imvCorrectBin.frame.minY)
                    }else{
                        label.center = CGPoint(x: self.imvWrongBin.frame.midX, y: self.imvWrongBin.frame.minY)
                    }
                    //if get == false {
                    let path = UIBezierPath()
                    path.move(to: label.center)
                    path.addQuadCurve(to: CGPoint(x: UIScreen.main.bounds.width/2, y: self.view.frame.maxY + 30), controlPoint: CGPoint(x:self.view.frame.midX, y: label.frame.midY - 20))
                    let animation = CAKeyframeAnimation(keyPath: "position")
                    animation.setValue("drop", forKey: "AnimationIdentifier")
                    animation.delegate = self
                    animation.path = path.cgPath
                    animation.repeatCount = 0
                    animation.duration = 1.0
                    animation.isRemovedOnCompletion = false
                    label.layer.add(animation, forKey: "pathAnimation")
                }
                else {
                    scorerLabel.setValue(newValue: gameControl.points, duration: 1)
                    label.removeFromSuperview()
                    setQuestionPair()
                }
            }
            else if value == "drop" {
                scorerLabel.setValue(newValue: gameControl.points, duration: 1)
                label.removeFromSuperview()
                setQuestionPair()
            }
        }
    }
}

