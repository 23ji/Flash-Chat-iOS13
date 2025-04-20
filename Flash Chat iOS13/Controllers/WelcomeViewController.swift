//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import CLTypingLabel
import UIKit


class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var titleLabel: CLTypingLabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.titleLabel.text = "⚡️Flash Chat"
//    self.titleLabel.text = ""
//    
//    let titleText = "⚡️Flash Chat"
//    
//    var charIndex = 0.0
//    
//    for char in titleText {
//      
//      // titleText를 돌면서 char 하나마다 delay를 준다
//      // delay를 char 마다 다르게 한다
//      
//      Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { _ in
//        self.titleLabel.text?.append(char)
//      }
//      charIndex += 1
//    }
  }
  
  
}
