//
//  ViewController.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var existed = true
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldsInit()
        let url = databaseURL()
        let stylesheet = NSDictionary(contentsOfURL:url!)
        
        self.navigationController?.navigationBarHidden = true
        if self.revealViewController() != nil {
            self.revealViewController().panGestureRecognizer().enabled = false
        }
        
        if stylesheet!["AutoLogin"] as! Bool {
            let fetchRequest = NSFetchRequest(entityName: "UserModel")
            
            do {
                let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as! [UserModel]
                
                let result = fetchResults[safe: 0]
                
                self.emailTextField.text = result?.email
                self.passwordTextField.text = result?.password
                
                if result != nil {
                    self.loginButtonPressed(self.loginButton)
                } else {
                    self.existed = false
                }
            } catch let e {
                print(e)
            }
        }
    }

    func addUser(email: String, password: String) {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserModel", inManagedObjectContext: self.managedObjectContext) as! UserModel
        
        newItem.email = email
        newItem.password = password
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPopover" {
            let controller = segue.destinationViewController
            
            controller.popoverPresentationController!.delegate = self
            controller.preferredContentSize = CGSize(width: 320, height: 186)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        let Auth = AuthManager(email: emailTextField.text, password: passwordTextField.text)
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        Tools.startLoad(self.view, spinner: activityIndicator)
        
        Auth.GetCredentials() {
            dispatch_async(dispatch_get_main_queue()) {
                Tools.stopLoad(self.view, spinner: activityIndicator)
                
                if User.username != "" {
                    if !self.existed {
                        let url = self.databaseURL()
                        let stylesheet = NSDictionary(contentsOfURL:url!)
                        
                        if stylesheet!["AutoLogin"] as! Bool {
                            self.addUser(self.emailTextField.text!, password: self.passwordTextField.text!)
                        }
                    }
                    Config.debug("Success, moving on to home")
                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                } else {
                    let alert = UIAlertController(title: "Login Invalid", message: "Email or password incorrect", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func fieldsInit(){
        emailTextField.delegate = self
        emailTextField.tintColor = .whiteColor()
        passwordTextField.delegate = self
        passwordTextField.tintColor = .whiteColor()
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.alpha = 0.9
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email...", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password...", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    func databaseURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // If array of path is empty the document folder not found
        guard urls.count == 0 else {
            let finalDatabaseURL = urls.first!.URLByAppendingPathComponent("Settings.plist")
            // Check if file reachable, and if reacheble just return path
            guard finalDatabaseURL.checkResourceIsReachableAndReturnError(nil) else {
                // Check if file is exists in bundle folder
                if let bundleURL = NSBundle.mainBundle().URLForResource("Settings", withExtension: "plist") {
                    // if exist we will copy it
                    do {
                        try fileManager.copyItemAtURL(bundleURL, toURL: finalDatabaseURL)
                    } catch _ {
                        print("File copy failed!")
                    }
                } else {
                    print("Our file does not exist in bundle folder")
                    let filePath = NSBundle.mainBundle().pathForResource("Settings", ofType: ".plist")
                    do {
                        try fileManager.copyItemAtPath(filePath!, toPath: urls.first!.path!)
                    } catch let e {
                        print(e)
                    }
                    self.databaseURL()
                }
                return finalDatabaseURL
            }
            return finalDatabaseURL
        }
        return nil
    }
}

