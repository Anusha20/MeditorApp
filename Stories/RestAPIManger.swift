
import Foundation
import Cocoa

class RestAPIManger: NSObject{
    static let sharedInstance = RestAPIManger()
    
    let userDetailsEndPoint: String = "https://api.medium.com/v1/me"
    let unAuthorizedErrorMsg : String  = "Invalid Integration Token"
    let connectionRefusedErrorMsg :String  = "Connection Refused. Please try Later"
    
    func getUserDetails(popOverController : PopOverController?,sender: AnyObject, authIdSrc:String){
        
        let request = NSMutableURLRequest(URL: NSURL(string: userDetailsEndPoint)!)
        let session = NSURLSession.sharedSession()
        let authId = authIdSrc.isEmpty ? getAuthId() : authIdSrc;

        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer "+authId, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request, completionHandler:{(data:NSData?,response:NSURLResponse?, error:NSError?) -> Void in
            var msg : String = self.connectionRefusedErrorMsg
            if let _ = error
            {
                popOverController?.showErrorMessage(msg)
                // got an error in getting the data, need to handle it
                print("error calling GETUSERDETAILS on /posts/1 Failure: %@", error!.localizedDescription)
            }
            else // no error returned by URL request
            {
                let responseCode = (response as! NSHTTPURLResponse).statusCode
                if(responseCode == 200){
                    let get = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let authorId = get["data"]?["id"] as? String
                    {
                        setAuthorId(authorId)
                    }
                    if let name = get["data"]?["name"] as? String
                    {
                        setName(name)
                    }
                    if let username = get["data"]?["username"] as? String
                    {
                        setUserName(username)
                    }
                    if let url = get["data"]?["url"] as? String
                    {
                        setProfileUrl(url)
                    }
                    if let imageUrl = get["data"]?["imageUrl"] as? String
                    {
                        setImageUrl(imageUrl)
                    }
                    popOverController?.onSuccessFulUpdateUserDetails(sender)
                }else{
                    if(responseCode == 401){
                        msg =  self.unAuthorizedErrorMsg
                    }
                    popOverController?.showErrorMessage(msg)
                }
            }
        })
        task.resume()
    }
    
    func publishDraft(authorId:String,params:NSDictionary, app : AppDelegate?) {

        let publishEndpoint: String = "https://api.medium.com/v1/users/"+authorId+"/posts"
        let request = NSMutableURLRequest(URL: NSURL(string: publishEndpoint)!)
        let session = NSURLSession.sharedSession()
        let authId = getAuthId()

        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer "+authId, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request, completionHandler:{(data:NSData?,response:NSURLResponse?, error:NSError?) -> Void in
            if let _ = error
            {
                app?.onPublishFailure()
                // got an error in getting the data, need to handle it
                print("error calling GET on /posts/1")
            }
            else // no error returned by URL request
            {
                print(response)
                let responseCode = (response as! NSHTTPURLResponse).statusCode
                if(responseCode == 201){
                    let lastPost = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print("The post is: " + lastPost.description)
                    
                    app!.infoField.showProgress("Published Draft to medium.com", progressValue: 1)
                    app?.postPublish(lastPost)
                }else{
                    app?.onPublishFailure()
                }
            }
        })
        task.resume()
    }
    
    func constructParams(title:String,contentFormat:String,content:String,tags:[String],publishStatus:String )-> NSDictionary{
        let params = ["title":title,"contentFormat":contentFormat,"content":content,"tags":tags,"publishStatus":publishStatus] as NSDictionary
        return params
    }
}
