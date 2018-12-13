//
//  MainViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 11/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RxSwift
import RxGesture

class MainViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var myCharactersButton: UIButton!
    @IBOutlet weak var myLevelsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserLabel()
    }
    
    func setUserLabel() {
        if UserRepository.shared.getUser() != nil {
            self.userLabel.text = "Hi, " + (UserRepository.shared.getUser()?.displayName)!
        }
        
        print(UserRepository.shared.getUserProperties()?.Role)
    }
}