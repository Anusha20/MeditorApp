//
//  Store.swift
//  Meditor
//
//  Created by Sivaprakash Ragavan on 10/10/15.
//  Copyright © 2015 Sivaprakash Ragavan. All rights reserved.
//

import Foundation

struct defaultsKeys {
    static let authorId = "authorId"
    //  static let keyTwo = "secondStringKey"
    static let authId = "authId"
    
    static let userId = "userId"
    
    static let userName = "userName"
    
    static let name = "name"
    
    static let imageUrl = "imageUrl"
    
    static let profileUrl = "profileUrl"
    
    
}



//Setting AuthorId

func setAuthorId( value:String){
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.authorId+getUserId())
    
    defaults.synchronize()
}
//Getting AuthorId
func getAuthorId()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = ""
    if let stringOne = defaults.stringForKey(defaultsKeys.authorId+getUserId()) {
        print(stringOne) // Some String Value
        res = stringOne
    }
    return res
    
}

func setAuthId( value:String){
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.authId+getUserId())
    
    defaults.synchronize()
}
//Getting AuthorId
func getAuthId()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = ""
    if let stringOne = defaults.stringForKey(defaultsKeys.authId+getUserId()) {
        print(stringOne) // Some String Value
        res = stringOne
    }
    return res
    
}

func setUserId( value:String){
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.userId)
    
    defaults.synchronize()
}
//Getting AuthorId
func getUserId()->String{
    /* let defaults = NSUserDefaults.standardUserDefaults()
    var res = "empty"
    if let stringOne = defaults.stringForKey(defaultsKeys.userId) {
    print("UserId:"+stringOne) // Some String Value
    res = stringOne
    }*/
    return   NSHost.currentHost().localizedName!
    
}

func setUserName( value:String){
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.userName+defaultsKeys.userId)
    
    defaults.synchronize()
}
//Getting AuthorId
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
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.imageUrl+defaultsKeys.userId)
    
    defaults.synchronize()
}
//Getting AuthorId
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
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.profileUrl+defaultsKeys.userId)
    
    defaults.synchronize()
}
//Getting AuthorId
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
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setValue(value, forKey: defaultsKeys.name+defaultsKeys.userId)
    
    defaults.synchronize()
}
//Getting AuthorId
func getName()->String{
    let defaults = NSUserDefaults.standardUserDefaults()
    var res = "empty"
    if let stringOne = defaults.stringForKey(defaultsKeys.name+defaultsKeys.userId) {
        print("name"+stringOne) // Some String Value
        res = stringOne
    }
    return res
    
}








