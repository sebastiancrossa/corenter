//
//  ViewController.swift
//  Corenter
//
//  Created by Sebastian Crossa on 5/31/17.
//  Copyright © 2017 CROSS-A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.layer.cornerRadius = 8
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

