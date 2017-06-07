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
    
    @IBOutlet var updateUsernameTextField: UITextField!
    
    @IBOutlet var logInTitle: UILabel!
    @IBOutlet var updateTitle: UIButton!
    @IBOutlet var logOutTitle: UIButton!
    @IBOutlet var welcomeTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.layer.cornerRadius = 8
        welcomeUser.textColor = goButton.backgroundColor
        
        updateTitle.layer.cornerRadius = 8
        logOutTitle.layer.cornerRadius = 8
        
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
                    
                    logInTitle.alpha = 0
                    textField.alpha = 0
                    goButton.alpha = 0
                    
                    updateTitle.alpha = 1
                    logOutTitle.alpha = 1
                    welcomeUser.alpha = 1
                    welcomeTitle.alpha = 1
                    updateUsernameTextField.alpha = 1
                    
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
        
        print("-- Corenter: \(textField.text!) has created")
        
        // Saving the new values in CoreData
        do {
            try context.save()
            
            logInTitle.alpha = 0
            textField.alpha = 0
            goButton.alpha = 0
            
            updateTitle.alpha = 1
            logOutTitle.alpha = 1
            welcomeUser.alpha = 1
            welcomeTitle.alpha = 1
            updateUsernameTextField.alpha = 1
            
            welcomeUser.text = "\(textField.text!)"
            
            print("-- Corenter: \(textField.text!) has been succesfully saved.")
            
        } catch {
            // Error handling goes here
            print("** Corenter : Data could not be saved")
        }
    }

    @IBAction func updateButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        request.predicate = NSPredicate(format: "username = %@", welcomeUser.text!)
        
        request.returnsObjectsAsFaults = false
        
        do {
            /*  
                Variable in charge of the results made by the fetching the request
                In this case we added a specific predicate that will select the username
                that the user currently has selected so he/she can change it
            */
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                // Loop through the results as an array of NSManagedObjects
                for results in results as! [NSManagedObject] {
                    if let username = results.value(forKey: "username") as? String {
                        
                        do {
                            // Deletes the username the user previously had
                            context.delete(results)
                            
                            print("-- Corenter : Username has been deleted.")
                            
                            // Creates a new username based on what the user has typed
                            newValue.setValue(updateUsernameTextField.text!, forKey: "username")
                            
                            print("-- Corenter : \(newValue.value(forKey: "username")!) has been created.")
                            
                            try context.save()
                            
                            welcomeUser.text = "\(updateUsernameTextField.text!)"
                            print("-- Corenter : \(updateUsernameTextField.text!) has succesfully saved and updated")
                            
                            updateUsernameTextField.text = ""
                            
                        } catch {
                            // Error processing
                            print("** Corenter : An error has ocurred. Data could not be updated succesfully")
                        }
                    }
                }
            }
            
        } catch {
            // Error handling
            print("** Corenter : An error has ocurred. DData could not be retrieved")
        }
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

