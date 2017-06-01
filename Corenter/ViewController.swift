//
//  ViewController.swift
//  Corenter
//
//  Created by Sebastian Crossa on 5/31/17.
//  Copyright © 2017 CROSS-A. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet var goButton: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var welcomeUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.layer.cornerRadius = 8
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // This will let us acces and modify CoreData
        let context = appDelegate.persistentContainer.viewContext
        
        // Creates a profile for the user of the app
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        // Lets us communicate with CoreData and analize sotored data on the "Users" entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        // By default the requests will return as "Faults", which are not what we want
        // We want the requests to return the exact information stored
        request.returnsObjectsAsFaults = false
        
        do {
            // Constant in charge of fetching the results
            let results = try context.fetch(request)
            
            if results.count > 0 {
                goButton.isHidden = true
                textField.isHidden = true
                welcomeUser.isHidden = false
                
                welcomeUser.text = "Welcome, user :)"
            }
            
        } catch {
            // Error handling goes here
            print("** Corenter : Results could not be fetched")
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        /*
        if results.count == 0 {
            newUser.setValue("\(textField.text)", forKey: "username")
            
            print("** Corenter has received new data **")
            print()
        }
        */
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

