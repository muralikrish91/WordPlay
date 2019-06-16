//
//  ViewController.swift
//  WordPlay
//
//  Created by Murali Krishnan on 16/06/19.
//  Copyright © 2019 Murali Krishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var imvWrongBin: UIImageView!
    @IBOutlet weak var imvCorrectBin: UIImageView!
    let labelTag = 1757
    var gameControl = GameController()
    var scorerView: ScorerView!
    var dynamicAnimator : UIDynamicAnimator!
    var answer = false
    var chosenAnswer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Pattern")!)
        setScorerView()
        queryLabel.font = UIFont(name: "comic andy", size: 70)
        queryLabel.textColor = UIColor.white
        queryLabel.backgroundColor = UIColor(red: 246.0/255.0, green: 106.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        setUpGestureRecognizer()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        setQuestionPair()
    }
    
    func removeGravityBehaviors() {
        for behavior in dynamicAnimator.behaviors {
            if behavior is UIGravityBehavior {
                dynamicAnimator.removeBehavior(behavior)
            }
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
        label.font = UIFont(name: "comic andy", size: 70)//UIFont.systemFont(ofSize: 30)
        label.textColor = UIColor.white
        label.frame = CGRect(x: 0, y: queryLabel.frame.maxY, width: label.intrinsicContentSize.width + 20, height: label.intrinsicContentSize.height + 10)
        label.center.x = view.center.x
        //label.backgroundColor = UIColor.red
        label.clipsToBounds = true
        label.layer.cornerRadius = 6
        let gravityBehaviour = UIGravityBehavior(items: [label])
        gravityBehaviour.action = { [weak self] in
            if let strongSelf = self {
                if label.frame.origin.y > UIScreen.main.bounds.height {
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
    
    @objc func rightSwipe(recognizer: UISwipeGestureRecognizer){
        guard let gestureView = self.view.viewWithTag(labelTag) else { return }
        chosenAnswer = true
        dynamicAnimator.removeAllBehaviors()
        answer = gameControl.checkSolution(isCorrect:true)
        let path = UIBezierPath()
        path.move(to: gestureView.center)
        path.addQuadCurve(to: answer == false ? CGPoint(x: self.imvCorrectBin.frame.midX, y: self.imvCorrectBin.frame.minY) : self.imvCorrectBin.center, controlPoint: CGPoint(x:self.imvCorrectBin.frame.midX, y: gestureView.frame.midY - 20))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = 1.0
        animation.isRemovedOnCompletion = false
        gestureView.layer.add(animation, forKey: "pathAnimation")
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")//CAKeyframeAnimation(keyPath: "position")
        scaleAnimation.setValue("scale", forKey: "AnimationIdentifier")
        scaleAnimation.delegate = self
        scaleAnimation.fromValue = gestureView.transform.a
        scaleAnimation.toValue = 0.3
        scaleAnimation.duration = 1.0
        scaleAnimation.isRemovedOnCompletion = false
        gestureView.layer.add(scaleAnimation, forKey: "scale")
        gestureView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
    }
    
    @objc func leftSwipe(recognizer: UISwipeGestureRecognizer) {
        guard let gestureView = self.view.viewWithTag(labelTag) else { return }
        chosenAnswer = false
        dynamicAnimator.removeAllBehaviors()
        answer = gameControl.checkSolution(isCorrect:false)
        let path = UIBezierPath()
        path.move(to: gestureView.center)
        path.addQuadCurve(to: !answer ? CGPoint(x: self.imvWrongBin.frame.midX, y: self.imvWrongBin.frame.minY) : self.imvWrongBin.center, controlPoint: CGPoint(x:self.imvWrongBin.frame.midX, y: gestureView.frame.midY - 20))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = 0
        animation.duration = 1.0
        animation.isRemovedOnCompletion = false
        gestureView.layer.add(animation, forKey: "pathAnimation")
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")//CAKeyframeAnimation(keyPath: "position")
        scaleAnimation.setValue("scale", forKey: "AnimationIdentifier")
        scaleAnimation.delegate = self
        scaleAnimation.fromValue = gestureView.transform.a
        scaleAnimation.toValue = 0.3
        scaleAnimation.duration = 1.0
        scaleAnimation.isRemovedOnCompletion = false
        gestureView.layer.add(scaleAnimation, forKey: "scale")
        gestureView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
    }
    
    func setScorerView(){
        self.scorerView = ScorerView(frame:CGRect(x:150,y: 0,width: 300,height: 100))
        self.scorerView.value = 0
        view.addSubview(scorerView)
    }
    
    @IBAction func yesTapped(_ sender: UIButton) {
        submitSolution(true)
    }
    
    @IBAction func noTapped(_ sender: UIButton) {
        submitSolution(false)
    }
    
    func submitSolution(_ isCorrect:Bool){
        print(gameControl.checkSolution(isCorrect:isCorrect))
        scorerView.setValue(newValue: gameControl.points, duration: 1.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.setQuestionPair()
        })    }
    
    func setQuestionPair(){
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
                    label.removeFromSuperview()
                    setQuestionPair()
                }
            }
            else if value == "drop" {
                label.removeFromSuperview()
                setQuestionPair()
                
            }
        }
    }
}
