
//  GitClient
//
//  Created by Alexey Galaev on 24/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import SwiftHTTP
import JSONJoy

struct App: JSONJoy {
    var url: String?
    var name: String?
    var clientId: String?
    
    init(_ decoder: JSONDecoder) {
        url = decoder["url"].string
        name = decoder["name"].string
        clientId = decoder["client_id"].string
    }
}

struct Authorization: JSONJoy {
    var id: Int?
    var url: String?
    var app: App?
    var token: String?
    var note: String?
    var noteUrl: String?

    init(_ decoder: JSONDecoder) {
        id = decoder["id"].integer
        url = decoder["url"].string
        app = App(decoder["app"])
        token = decoder["token"].string
        note = decoder["note"].string
        noteUrl = decoder["note_url"].string
    }
}

struct Login {
    let clientId = "843071a9105202968a94"
    let clientSecret = "8d7e64f9bc87570bdfdbebbc114f1878bba62611"
    var basicAuth = ""
    
    init(username: String, password: String) {
        let optData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        if let data = optData {
            basicAuth = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
    }
    
    func auth(completionHandler: (Bool -> Void)) -> Void {
        
        let params = ["scopes":"repo", "note": "dev", "client_id": clientId, "client_secret": clientSecret]
        
        do {
            let opt = try HTTP.POST("https://api.github.com/authorizations", parameters: params, headers: ["Authorization": "Basic \(basicAuth)"] ,requestSerializer: JSONParameterSerializer())
            opt.start { response in
                if let error = response.error {
                    print("got an error: \(error)")
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler(false)
                    })
                    
                    return //also notify app of failure as needed
                }
                let auth = Authorization(JSONDecoder(response.data))
                if let token = auth.token {
                    print("token: \(token)")
                    defaults.setObject(token, forKey: "token")
                    defaults.synchronize()
                    manager.loadCurrentUser(){ completion in
                        currentUser.savedUser = completion.first! as? User
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler(true)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler(false)
                    })
                }
                
            }
            
        } catch let error {
            dispatch_async(dispatch_get_main_queue(),{
                completionHandler(false)
            })
            print("got an error creating the request: \(error)")
        }
    }
}