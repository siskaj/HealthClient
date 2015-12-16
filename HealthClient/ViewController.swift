//
//  ViewController.swift
//  HealthClient
//
//  Created by Jaromir on 07.12.15.
//  Copyright © 2015 baltoro. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
  
  var logInViewController: PFLogInViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //      let testObject = PFObject(className: "TestObject")
    //      testObject["foo"] = "bar"
    //      testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
    //        print("Object has been saved.")
    //      }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if (PFUser.currentUser() != nil) {
      // TODO:
      performSegueWithIdentifier("ClientList", sender: self)
      return
    }
    
    // No user logged in
    let signupButtonBackgroundImage: UIImage = getImageWithColor(UIColor.blueColor(), size: CGSize(width: 10.0, height: 10.0))
    
    // Create the log in view controller
    logInViewController = PFLogInViewController()
    logInViewController.logInView!.passwordForgottenButton!.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
    logInViewController.logInView!.signUpButton!.setBackgroundImage(signupButtonBackgroundImage, forState: .Normal)
    logInViewController.logInView!.signUpButton?.backgroundColor = UIColor.blueColor()
    logInViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    logInViewController.fields = ( [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten])
    logInViewController.delegate = self
    
    
    // Create the sign up view controller
    let signUpViewController: PFSignUpViewController = PFSignUpViewController()
    signUpViewController.signUpView!.signUpButton!.setBackgroundImage(signupButtonBackgroundImage, forState: .Normal)
    logInViewController.signUpController = signUpViewController
    signUpViewController.delegate = self
    
    presentViewController(logInViewController, animated: true, completion: nil)
    
  }
  
  // MARK - PFLogInViewControllerDelegate
  
  // Sent to the delegate to determine whether the log in request should be submitted to the server.
  func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
    if (!username.isEmpty && !password.isEmpty) {
      return true
    }
    
    let title = NSLocalizedString("Missing Information", comment: "")
    let message = NSLocalizedString("Make sure you fill out all of the information!", comment: "")
    let cancelButtonTitle = NSLocalizedString("OK", comment: "")
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let action = UIAlertAction(title: cancelButtonTitle, style: .Default, handler: { (act : UIAlertAction) in
      return
    })
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
    //    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
    
    return false // Interrupt login process
  }
  
  // Sent to the delegate when a PFUser is logged in.
  func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
    self.dismissViewControllerAnimated(true, completion: nil)
    performSegueWithIdentifier("ClientList", sender: self)
  }
  
  func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
    if let description = error?.localizedDescription {
      let cancelButtonTitle = NSLocalizedString("OK", comment: "")
      let alert = UIAlertController(title: description, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
      let action = UIAlertAction(title: cancelButtonTitle, style: .Default, handler: { (act : UIAlertAction) in
        return
      })
      alert.addAction(action)
      logInController.presentViewController(alert, animated: true, completion: nil)
      //      UIAlertView(title: description, message: nil, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
    }
    print("Failed to log in...")
  }
  
  // MARK: - PFSignUpViewControllerDelegate
  
  // Sent to the delegate to determine whether the sign up request should be submitted to the server.
  func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
    var informationComplete: Bool = true
    
    // loop through all of the submitted data
    for (key, _) in info {
      if let field = info[key] as? String {
        if field.isEmpty {
          informationComplete = false
          break
        }
      }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
      let title = NSLocalizedString("Signup Failed", comment: "")
      let message = NSLocalizedString("All fields are required", comment: "")
      let cancelButtonTitle = NSLocalizedString("OK", comment: "")
      UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
    }
    
    return informationComplete;
  }
  
  // Sent to the delegate when a PFUser is signed up.
  func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
    self.dismissViewControllerAnimated(true, completion: nil)
    performSegueWithIdentifier("ClientList", sender: self)
  }
  
  func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
    print("Failed to sign up...")
  }
  
  
  // MARK - Helper function
  func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect = CGRectMake(0, 0, size.width, size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
}

