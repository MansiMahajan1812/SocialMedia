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
import FacebookShare
import FBSDKShareKit
import Foundation

protocol TwitterFollowerDelegate{
    func finishedDownloading(follower:TwitterFollower)
}

class ViewController: UIViewController,  GIDSignInDelegate, GIDSignInUIDelegate {
    
     var delegate:TwitterFollowerDelegate?
    let consumerKey = "vL7yiVrv79K71APxzYUG1u5FS"
    let consumerSecret = "a7R90Dlk2YPt3CNaHlHVSKfz4tVzy1ssvRlIPWZ9LNnt6EQjpS"
    var userIdText: String!
    let host = "://api.twitter.com"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var results = NSMutableArray()
    var friends = NSArray()
    var followers = NSArray()

    
    func getBearerToken(completion:@escaping (_ bearerToken: String)-> Void){
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = "/oauth2/token"
        //let url = components.url
        let url = "https://api.twitter.com/oauth2/token"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("Basic " + getBase64EncodingString(), forHTTPHeaderField: "Authorization")
                request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
                let grantType =  "client_credentials"
        
        request.httpBody = grantType.data(using: String.Encoding.utf8, allowLossyConversion: true)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    do {
                        print(data)
                        if let results: Dictionary = try JSONSerialization .jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments  ) as? Dictionary<String, Any> {
                            print(results)
                            if let token = results["access_token"] as? String {
                                completion(token)
                            } else {
                                print(results["errors"])
                            }
                        }
                    } catch let error as Error {
                        print(error.localizedDescription)
                    }
                }).resume()
        
    }
    
    func getBase64EncodingString()-> String {
        let consumerKeyRFC1738 = consumerKey.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let consumerSecretRFC1738 = consumerSecret.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let concatinatingKeyAndSecret = consumerKeyRFC1738! + ":" + consumerSecretRFC1738!
        let secretAndKeyData = concatinatingKeyAndSecret.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let base64EncodKeyAndSecret = secretAndKeyData?.base64EncodedString()
        return base64EncodKeyAndSecret!
    }

    func loadFollowers()
    {
        getBearerToken(completion: { (bearerToken) -> Void in
        let url = "https://api.twitter.com/1.1/followers/list.json?screen_name=rshankra&skip_status=true&include_user_entities=false&count=50"
        //let url = "https://api.twitter.com/1.1/followers/list.json?cursor=-1&screen_name=twitterdev&skip_status=true&include_user_entities=false"

        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
         let token = "Bearer " + bearerToken
        var session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
//            do
//            {
//               // let dict = try JSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! Dictionary
//                let dict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
//                let friends = dict["ids"] as! NSArray
//                self.friends = friends
//            }
//            catch let error
//            {
//                print(error)
//            }
//             self.processResult(data, response: response!, error: error)
            print(data)
            print(response)
            print(error)
            self.processResult(data: data!, response: response!, error: error)
        }.resume()
        })
    }

    func processResult(data: Data?, response: URLResponse?, error: Error?){
        do{
            let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
            //if let user = result
            print(result)
            if let users = result["users"] as? NSArray {
                for user in users {
                    if let pref = user as? [String: Any] {
                        var prefToLoad = pref["name"] as! String
                        print(prefToLoad)
                        let follower = TwitterFollower(name: pref["name"] as! String, url: pref["profile_image_url"] as! String)
                          print(followers)
                        self.delegate?.finishedDownloading(follower: follower)
                        // The rest of your code
                    }
                    
                   // let follower = TwitterFollower(name: user["name"] as! String, url: user["profile_image_url"] as! String)
                
                }

            } else {
                print(result["errors"])
            }
        }
        catch{
            print(error.localizedDescription)
        }
       
        
    }
    
    @IBAction func twitterLogin(_ sender: UIButton) {
        TWTRTwitter.sharedInstance().logIn { session, error in
            
            if let unwrappedSession = session{
                let client = TWTRAPIClient()
                client.loadUser(withID: (unwrappedSession.userID), completion: { (user, error) in
                    self.userIdText = user?.name
                    print(user?.name)
                    self.loadFollowers()
                    
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
        }
    }
    
    
    @IBAction func shareData(_ sender: UIButton) {
        let composer = TWTRComposer()
        
        composer.setText("just setting up my Twitter Kit")
        composer.setImage(UIImage(named: "twitterImage"))
        
        // Called from a UIViewController
        print(self.navigationController)
        composer.show(from: self.navigationController!) { (result) in
            if (result == .done) {
                print("Successfully composed Tweet")
            } else {
                print("Cancelled composing")
            }
        }
    }
    
    
    //----------------------------------------/////////////////////////////////-------------------------------------
    
    
    
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
    
    @IBAction func facebookShare(_ sender: UIButton) {
        let photo = Photo(image: #imageLiteral(resourceName: "twitterImage"), userGenerated: true)
        var content = PhotoShareContent()
        content.photos = [photo]
        //content.referer = "just setting up my Facebook"
        do{
        try ShareDialog.show(from: ViewController(), content: content)
        }catch{
            print("Error")
        }
    
    }
    
    
    
    //----------------------------------------/////////////////////////////////---------------------------------------
    
    
    
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
        }
    }
   

    //SignOut
    @IBAction func LogOutGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        print("LogOut From Google")
    }
    
    
    @IBAction func GoogleShare(_ sender: UIButton) {
        
        let text = "This is the text...."
        let image = UIImage(named: "twitterImage")
        //let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
//        var shareDialog = GPPShare.sharedInstance().nativeShareDialog();
//
//        // This line will fill out the title, description, and thumbnail from
//        // the URL that you are sharing and includes a link to that URL.
//        shareDialog.setURLToShare(NSURL(fileURLWithPath: kShareURL));
//
//        shareDialog.open();
    }
}

