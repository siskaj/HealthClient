//
//  AppDelegate.swift
//  HealthClient
//
//  Created by Jaromir on 07.12.15.
//  Copyright © 2015 baltoro. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  // JSTestCore IDs
  let ParseAppIDString: String = "Au5mGSzqxfGoH6asVQumzJ074CNA0UvuokoduG4B"
  let ParseClientKeyString: String = "YueEO1czAoIFuO33W3zKErQ826bTO96FOdjBYWRz"

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    setupParse()
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      self.setupTestData()
    }
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func setupParse() {
    // Enable Parse local data store for user persistence
    Parse.enableLocalDatastore()
    Parse.setApplicationId(ParseAppIDString, clientKey: ParseClientKeyString)
    
    // Set default ACLs
    let defaultACL: PFACL = PFACL()
    defaultACL.publicReadAccess = true
    PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
  }

  // MARK: Test Data
  
  private func setupTestData() {
    let todoTitles = [
      "Build Parse",
      "Make everything awesome",
      "Go out for the longest run",
      "Do more stuff",
      "Conquer the world",
      "Build a house",
      "Grow a tree",
      "Be awesome",
      "Setup an app",
      "Do stuff",
      "Buy groceries",
      "Wash clothes"
    ];
    
    var objects: [PFObject] = Array()
    
    do {
      let todos = try PFQuery(className: "Todo").findObjects()
      if todos.count == 0 {
        for (index, title) in todoTitles.enumerate() {
          let todo = PFObject(className: "Todo")
          todo["title"] = title
          todo["priority"] = index % 3
          objects.append(todo)
        }
      }
    } catch {}
    
    let appNames = [ "Anypic", "Anywall", "f8" ]
    do {
      let apps = try PFQuery(className: "App").findObjects()
      if apps.count == 0 {
        for (index, appName) in appNames.enumerate() {
          let bundle = NSBundle.mainBundle()
          if let fileURL = bundle.URLForResource(String(index), withExtension: "png") {
            if let data = NSData(contentsOfURL: fileURL) {
              let file = PFFile(name: fileURL.lastPathComponent, data: data)
              let object = PFObject(className: "App")
              object["icon"] = file
              object["name"] = appName
              objects.append(object)
            }
          }
        }
      }
    } catch {}
    
    if objects.count != 0 {
      do {
        try PFObject.saveAll(objects)
      } catch {}
    }
  }

}
