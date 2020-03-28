//
//  ViewController.swift
//  Flashcards
//
//  Created by Zoe Offermann on 2/12/20.
//  Copyright © 2020 Zoe Offermann. All rights reserved.
//

import UIKit

struct Flashcard{
    var question: String
    var answer_right: String
    var answer_wrong1: String
    var answer_wrong2: String
    
}

class ViewController: UIViewController {
            
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    func buttonSetUp(button: UIButton){
        button.layer.borderWidth = 3.0
        button.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 15.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // make destination of segue bc the nav controller
        let navigationController = segue.destination as! UINavigationController
        // make nav controller only contain a creation view controller
        let creationController = navigationController.topViewController as! CreationViewController
        // set flashcardsController property to self
        creationController.flashcardsController = self
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.shadowOpacity = 0.5
        card.layer.shadowRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        
        buttonSetUp(button: button1)
        buttonSetUp(button: button2)
        buttonSetUp(button: button3)
        
        readSavedFlashcards()
        
        if(flashcards.count == 0){
             updateFlashcard(question: "What is the capital of Argentina?", answer1: "Buenos Aires", answer2: "Córdoba", answer3: "Mar del Plata")
        }else{
            updateLables()
            updateNextPrev()
        }
    }

    @IBAction func button1Press(_ sender: Any) {
        
        flipFlashcard()
    }
    
    @IBAction func button2Press(_ sender: Any) {
        button2.isHidden = true
    }
    
    
    @IBAction func button3Press(_ sender: Any) {
        button3.isHidden = true
    }
    
    @IBAction func didTapCard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
       
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations:{
            self.frontLabel.isHidden = !self.frontLabel.isHidden
        })
    }
    
    func animateCardOutNext(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            
            self.updateLables()
            
            self.animateCardInNext()
            
        })
    }
    
    func animateCardInNext(){
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animateCardOutPrev(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            
            self.updateLables()
            
            self.animateCardInPrev()
            
        })
    }
    
    func animateCardInPrev(){
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapPrev(_ sender: Any) {
        currentIndex -= 1
//        updateLables()
        
        updateNextPrev()
        animateCardOutPrev()
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        currentIndex += 1
//        updateLables()
        updateNextPrev()
        animateCardOutNext()
    }
    
    func updateNextPrev(){
         if(currentIndex < flashcards.count - 1){
            nextButton.isEnabled = true
        }
         else{
            nextButton.isEnabled = false
        }
        
        if(currentIndex > 0){
            prevButton.isEnabled = true
        }
        else{
            prevButton.isEnabled = false
        }
        
        
    }
    
    func updateLables(){
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        frontLabel.isHidden = false
        backLabel.text = currentFlashcard.answer_right
        button1.setTitle(currentFlashcard.answer_right, for: .normal)
        button1.isHidden = false
        button2.setTitle(currentFlashcard.answer_wrong1, for: .normal)
        button2.isHidden = false

        button3.setTitle(currentFlashcard.answer_wrong2, for: .normal)
        button3.isHidden = false

    }
    
    func updateFlashcard(question:String,answer1:String, answer2: String, answer3: String){
        let flashcard =  Flashcard(question: question, answer_right: answer1, answer_wrong1: answer2, answer_wrong2: answer3)
       
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer_right
        button1.setTitle(flashcard.answer_right, for: .normal)
        button2.setTitle(flashcard.answer_wrong1, for: .normal)
        button2.isHidden = false
        button3.setTitle(flashcard.answer_wrong2, for: .normal)
        button3.isHidden = false
        
        flashcards.append(flashcard)
        currentIndex = flashcards.count - 1
        updateNextPrev()
        saveAllFlashcardsToDisk()

    }
    
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer_right": card.answer_right, "answer_wrong1": card.answer_wrong1, "answer_wrong2": card.answer_wrong2 ]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map{ dictionary ->	Flashcard in
                return Flashcard(question: dictionary["question"]!, answer_right: dictionary["answer_right"]!, answer_wrong1: dictionary["answer_wrong1"]!, answer_wrong2: dictionary["answer_wrong2"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
}

