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

    
    var userLimit : Bool = false
    
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
        
        // Adding values to newUser manually
        // newUser.setValue("Sebastian Crossa", forKey: "username")
        
        // Lets us communicate with CoreData and analize sotored data on the "Users" entity
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        // By default the requests will return as "Faults", which are not what we want
        // We want the requests to return the exact information stored
        request.returnsObjectsAsFaults = false
        
        do {
            // Constant in charge of fetching the results
            let results = try context.fetch(request)
            
            for results in results as! [NSManagedObject] {
                if let username = results.value(forKey: "username") {
                    textField.isHidden = true
                    goButton.isHidden = true
                    welcomeUser.isHidden = false
                    
                    welcomeUser.text = "Welcome, \(username)!"
                }
            }
            
        } catch {
            // Error handling goes here
            print("** Corenter : Results could not be fetched")
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newValues = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        newValues.setValue(textField.text, forKey: "username")
        
        // Saving the new values in CoreData
        do {
            try context.save()
            
            textField.isHidden = true
            goButton.isHidden = true
            welcomeUser.isHidden = false
            
            welcomeUser.text = "Welcome, \(textField.text!)!"
            
        } catch {
            // Error handling goes here
            print("** Corenter : Data could not be saved")
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

