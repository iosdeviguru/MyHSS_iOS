//
//  DictionaryExtention.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation

extension NSDictionary{
    
    func getDoubleValue(key: String) -> Double{
        
        if let any: AnyObject = self.object(forKey: key) as AnyObject?{
            if let number = any as? NSNumber{
                return number.doubleValue
            }else if let str = any as? NSString{
                return str.doubleValue
            }
        }
        return 0
    }
    
    func getFloatValue(key: String) -> Float{
        
        if let any: AnyObject = self.object(forKey: key) as AnyObject? {
            if let number = any as? NSNumber{
                return number.floatValue
            }else if let str = any as? NSString{
                return str.floatValue
            }
        }
        return 0
    }
    
    func getIntValue(key: String) -> Int{
        
        if let any: Any = self.object(forKey: key) as Any? {
            if let number = any as? NSNumber{
                return number.intValue
            }else if let str = any as? NSString{
                return str.integerValue
            }
        }
        return 0
    }
    
    
    func getStringValue(key: String) -> String{
        
        if let any: AnyObject = self.object(forKey: key) as AnyObject? {
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }
    
    func getBooleanValue(key: String) -> Bool {
        
        if let any:AnyObject = self.object(forKey: key) as AnyObject? {
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return false
    }
    
    func getStringArrayValue(key: String) -> [String]{
        
        if let any:AnyObject = self.object(forKey: key) as AnyObject? {
            if let ary = any as? [String] {
                return ary
            }
        }
        return []
    }
    
    func getStringDictionaryValue(key : String) -> NSDictionary {
        if let any:AnyObject = self.object(forKey: key) as AnyObject? {
            if let ary = any as? NSDictionary {
                return ary
            }
        }
        return [:]
    }
    
    func getArrayValue(key : String) -> NSArray {
        if let any:AnyObject = self.object(forKey: key) as AnyObject? {
            if let ary = any as? NSArray {
                return ary
            }
        }
        return []
    }
    
}

