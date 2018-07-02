//
//  ViewController.swift
//  SocialMedia
//
//  Created by Mansi Mahajan on 6/29/18.
//  Copyright © 2018 Mansi Mahajan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import TwitterKit

class ViewController: UIViewController,  GIDSignInDelegate, GIDSignInUIDelegate {
    
    var userIdText: String!
    override func viewDidLoad() {
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func twitterLogin(_ sender: UIButton) {
        TWTRTwitter.sharedInstance().logIn { session, error in
            
            if let unwrappedSession = session{
                let client = TWTRAPIClient()
                client.loadUser(withID: (unwrappedSession.userID), completion: { (user, error) in
                    self.userIdText = user?.name
                    print(user?.name)
                })
            }
            else{
                print(error?.localizedDescription)
            }
        }
    
    }
    
    @IBAction func twitterLogout(_ sender: UIButton) {
        
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            print(userID)
            store.logOutUserID(userID)
            print("LogOut From Twitter")
        }    }
    
    
    
    //-----------------------------------------/////////////////////////////////-------------------------------------
    
    
    
    //FaceBook SignIn, get user data, SignOut
    //Login with FaceBook
    @IBAction func facebookLogin(_ sender: UIButton) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
        
    }
    
    //Get user data
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let info = result as! [String : AnyObject]
                    print(info["email"] as! String)
                }
            })
        }
        
    }
    
    //SignOut
    @IBAction func LogOut(_ sender: UIButton) {
        let manager = FBSDKLoginManager()
        manager.logOut()
        print("LogOut From Facebook")
    }
    
    
    
    //------------------------------//////////////////////////////---------------------------------------
    
    
    
    //Google SignIn, UserData, SignOut
    //SignIn with Google
    @IBAction func gmailLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().clientID = "1057967692586-fkkc0t5mkprp9bug34eknmj6g31q5jgd.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Get User Data
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print(email, userId)
            // ...
        }
    }
   

    //SignOut
    @IBAction func LogOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        print("LogOut From Google")
    }
}

