//
//  AppDelegate.swift
//  literaturlesen
//
//  Created by Kastanie Eins on 11.01.21.
//  Copyright © 2021 DLA Marbach. All rights reserved.
//  GNU GENERAL PUBLIC LICENSE
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var sharedURL:String?

    /**
     * Verarbeitung von Aufrufe über das URL-Schema
     */
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {

        print("Öffne \(url) mit der literaturlesen-app...");
        let urlcomponents = URLComponents( url: url, resolvingAgainstBaseURL: true);
        let host = urlcomponents?.host ?? "";
        print("Host  \(host)");
        self.sharedURL = "";
        if( host=="literaturlesen" )
        {

                var aid:String = "";
                var text:String = "";
                let items = urlcomponents?.queryItems ?? [];

                    for queryItem in items {
                        if( queryItem.name == "aid" )
                        {
                            aid = queryItem.value ?? "";
                        }
                        if( queryItem.name == "text" )
                        {
                            text = queryItem.value ?? "";
                        }
                    }
                
                if( aid != "" && aid.count < 26 && text != "" && text.count < 30 )
                {
                    /**
                    * Sanatizing von text und aid noch sinnvoll
                     */
                    
                    self.sharedURL = "https://app.literaturlesen.com/#reader/"+text+"/share/"+aid;
                    /*let storyboard = UIStoryboard(name:"Main", bundle: nil);
                    let view = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController;*/
                    let view = window?.rootViewController as? ViewController;
                    view?.apppage = self.sharedURL;
                    view?.restart();
                    
                    
                }              
            
            
        }
        else {
            print("Kein Sharing-Host gefunden.")
        }

        return true;
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

