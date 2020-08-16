//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false //this is so the Navigation Bar will appear again when we transition to another screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = K.appName
        
//        titleLabel.text = ""
//        var charIndex = 0.0 //charIndex has to be a Double in order to multiply by 0.1 in withTimeInterval
//        let titleText = "⚡️FlashChat"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            } //every letter in titleText has a timer created for it
//            charIndex += 1 // (refer to withTimeInterval code) this will ensure that each subsequent letter's timer is delayed by 0.1 seconds for the animation to occur as we want it to
//        }
       
    }

}
