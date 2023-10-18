//
//  Singleton.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//


import Foundation

class Singleton{
    
    class var shared: Singleton {
        struct Static {
            static var onceToken: Int = 0
            static var instance = Singleton()
        }
        return Static.instance
    }
    
    //MARK:- Prefrence
    func save(object: Any, key:String){
        let userDefault = UserDefaults.standard
        userDefault.set(object, forKey: key)
        userDefault.synchronize()
    }
    
    
    func isSaved(object: Any, key:String) -> Bool {
        let userDefault = UserDefaults.standard
        userDefault.set(object, forKey: key)
        return userDefault.synchronize()
    }
    
    func get(key:String) -> Any? {
        let userDefault = UserDefaults.standard
        return userDefault.object(forKey: key)
    }
    
    func delete(key:String) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
    
    func getUser() -> User? {
        if let user = self.get(key: APP.userData) as? [String:Any], let userObj = User(JSON: user){
            print(user)
            return userObj
        }else{
            return nil
        }
    }
}
