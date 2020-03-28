//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Zoe Offermann on 2/29/20.
//  Copyright © 2020 Zoe Offermann. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {

    @IBOutlet weak var QuestionText: UITextField!
        
    @IBOutlet weak var RightAnswerText: UITextField!
    
    @IBOutlet weak var Wrong1AnswerText: UITextField!
    
    @IBOutlet weak var Wrong2AnswerText: UITextField!
    
    var flashcardsController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapOnCalcel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        let qText = QuestionText.text
        let aText = RightAnswerText.text
        let wa1Text = Wrong1AnswerText.text
        
        let wa2Text = Wrong2AnswerText.text

        flashcardsController.updateFlashcard(question: qText!, answer1: aText!, answer2: wa1Text!, answer3: wa2Text!)
        dismiss(animated: true)
    }

}
