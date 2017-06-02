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
    
    @IBOutlet var logInTitle: UILabel!
    @IBOutlet var welcomeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.layer.cornerRadius = 8
        welcomeUser.textColor = goButton.backgroundColor
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // This will let us acces and modify CoreData
        let context = appDelegate.persistentContainer.viewContext
        
        // Adding values to newUser manually (Currently not in use)
        // newUser.setValue("Sebastian Crossa", forKey: "username")
        
        // Lets us communicate with CoreData and analize sotored data on the "Users" entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        // By default the requests will return as "Faults", which are not what we want
        // We want the requests to return the exact information stored
        request.returnsObjectsAsFaults = false
        
        do {
            // Constant in charge of fetching the results
            let results = try context.fetch(request)
            
            // Will see if there is currently a username registered in CoreData
            // If a connection can be established, welcome screen will welcome the
            // user. If not, it will stay the same
            for results in results as! [NSManagedObject] {
                if let username = results.value(forKey: "username") {
                    logInTitle.isHidden = true
                    textField.isHidden = true
                    goButton.isHidden = true
                    welcomeUser.isHidden = false
                    welcomeTitle.isHidden = false
                    
                    welcomeUser.text = "\(username)"
                }
            }
          
        } catch {
            // Error handling goes here
            print("** Corenter : Results could not be fetched")
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        // Creating the basic connections for CoreData, same as before (explained above)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newValues = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        // Create a new value in CoreData with the text entered by the user
        newValues.setValue(textField.text, forKey: "username")
        
        // Saving the new values in CoreData
        do {
            try context.save()
            
            logInTitle.isHidden = true
            textField.isHidden = true
            goButton.isHidden = true
            welcomeUser.isHidden = false
            welcomeTitle.isHidden = false
            
            welcomeUser.text = "\(textField.text!)"
            
        } catch {
            // Error handling goes here
            print("** Corenter : Data could not be saved")
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

