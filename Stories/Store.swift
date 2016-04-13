
import Foundation

struct defaultsKeys {
    static let authorId = "authorId"
    static let authId = "authId"
    static let userId = "userId"
    static let userName = "userName"
    static let name = "name"
    static let imageUrl = "imageUrl"
    static let profileUrl = "profileUrl"
}

let defaults = NSUserDefaults.standardUserDefaults()

func setAuthorId(value:String) {
    defaults.setValue(value, forKey: defaultsKeys.authorId+getUserId())
    defaults.synchronize()
}

func getAuthorId()->String {
    if let stringOne = defaults.stringForKey(defaultsKeys.authorId+getUserId()) {
        return stringOne
    }
    return ""
}

func setAuthId( value:String){
    defaults.setValue(value, forKey: defaultsKeys.authId+getUserId())
    defaults.synchronize()
}

func getAuthId()->String{
    if let stringOne = defaults.stringForKey(defaultsKeys.authId+getUserId()) {
        return stringOne
    }
    return ""
}

func setUserId( value:String){
    defaults.setValue(value, forKey: defaultsKeys.userId)
    defaults.synchronize()
}

func getUserId()->String{
    return   NSHost.currentHost().localizedName!
}

func setUserName( value:String){
    defaults.setValue(value, forKey: defaultsKeys.userName+defaultsKeys.userId)
    defaults.synchronize()
}

func getUserName()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = "empty"
    if let stringOne = defaults.stringForKey(defaultsKeys.userName+defaultsKeys.userId) {
        print("userName:"+stringOne) // Some String Value
        res = stringOne
    }
    return res
}


func setImageUrl( value:String){
    defaults.setValue(value, forKey: defaultsKeys.imageUrl+defaultsKeys.userId)
    defaults.synchronize()
}

func getImageUrl()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = "empty"
    if let stringOne = defaults.stringForKey(defaultsKeys.imageUrl+defaultsKeys.userId) {
        print("imageUrl:"+stringOne) // Some String Value
        res = stringOne
    }
    return res
}

func setProfileUrl( value:String){
    defaults.setValue(value, forKey: defaultsKeys.profileUrl+defaultsKeys.userId)
    defaults.synchronize()
}

func getProfileUrl()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = "empty"
    if let stringOne = defaults.stringForKey(defaultsKeys.profileUrl+defaultsKeys.userId) {
        print("profileUrl"+stringOne) // Some String Value
        res = stringOne
    }
    return res
}

func setName( value:String){
    defaults.setValue(value, forKey: defaultsKeys.name+defaultsKeys.userId)
    defaults.synchronize()
}

func getName()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = "empty"
    if let stringOne = defaults.stringForKey(defaultsKeys.name+defaultsKeys.userId) {
        print("name"+stringOne) // Some String Value
        res = stringOne
    }
    return res
}