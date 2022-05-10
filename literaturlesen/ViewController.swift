//
//  ViewController.swift
//  literaturlesen
//
//  Created by Kastanie Eins on 11.07.21.
//  Copyright © 2021 DLA Marbach. All rights reserved.
//  GNU GENERAL PUBLIC LICENSE
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {

    public var webView: WKWebView!
    public var apppage: String!
    public var baseURL: String!
    
    
    override func viewDidLoad() {
        
        //self.baseURL =  "https://app.literaturlesen.com";
        self.baseURL =  "https://app.literaturlesen.com";
        self.apppage =  self.baseURL;
        let appdelegate = UIApplication.shared.delegate as! AppDelegate;
        if( appdelegate.sharedURL ?? "" != "" )
        {
            self.apppage = appdelegate.sharedURL;
        }
        
        let value = UIInterfaceOrientation.portraitUpsideDown.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        super.viewDidLoad()
        
        //Preparing Config
        let contentController = WKUserContentController();
        
        
        let config = WKWebViewConfiguration();
        config.userContentController = contentController;
        
        //Erstellen des WebViews
        self.webView = WKWebView(frame: self.view.bounds, configuration: config )
        self.webView.navigationDelegate = self;     
     
        contentController.add(self, name: "command");

        
        self.restart();
        
        
    }
    

    @IBAction func zurueckBtn(_ sender: Any) {
        print("Klick");
        self.apppage = self.baseURL+"#home"
        self.restart();
    }
    
    /**
     * Neustart der App
     */
    public func restart()
    {
        let url = self.apppage;
        
        
        if( URL( string: url! ) != nil )
        {
            let request = URLRequest( url: URL(string:url!)! );
            self.webView.load( request );
            self.view.addSubview( self.webView);
            self.view.bringSubviewToFront(self.webView);            
        }
    }

    /**
     * Verarbeitet die Scripteingaben (Sendungen an den Appwrapper) von der WebApp
     */
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if message.name == "command", let messageBody = message.body as? String {
            
            let commandcombination : [String] = messageBody.components(separatedBy: "|")
            let command = commandcombination[0];
            switch command
            {
            case "load": print(command);break;
            case "debug": print(""+String(commandcombination[1]));break;
            case "save": /*print(command);*/break;
            case "restart": self.restart(); break;
            case "update":
                //Löschen des Caches, wenn eine Aktualisierung statt findet
                print("Aktualisiere App auf Version "+String(commandcombination[1]));
                appalert("Aktualisierung", msg:"Aktualisiere App auf Version "+String(commandcombination[1]) );
                WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        
                        var types: Set <String> = record.dataTypes;
                        print("Lösche "+record.dataTypes.joined(separator: ",") )
                        types.remove("WKWebsiteDataTypeLocalStorage");
                        WKWebsiteDataStore.default().removeData(ofTypes: types, for: [record], completionHandler: {})
                    }
                }
                self.restart();
                break;
            default:
                print("Unknown WebCommand");
                
            }
        }
    }

    /**
     * Öffnet eine Alert-Box
     */
    public func appalert(_ title:String, msg:String)
    {
        // Create new Alert
        let dialogMessage = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //
        })       
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    public func webViewDidFinishLoad(_ webView: WKWebView) {
        if let text = webView.url?.absoluteString{
             print(text)
        }
    }
    

    /**
     * Handling von Mail-Links und Sharing-Links
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard
            let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
        }
        
        
        
        let string = url.absoluteString
        if (string.contains("mailto:")) {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)

            return
        }
        else if (!string.contains(self.baseURL)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)

            return
        }
        decisionHandler(.allow)
    }
    
    
}

