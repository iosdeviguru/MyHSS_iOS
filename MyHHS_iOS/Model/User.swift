//
//  User.swift
//  OFO
//
//  Created by jagdish on 17/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserResponse : Mappable {
    var code : Int?
    var message : String?
    var user : User?

    init() {
        
    }
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        user <- map["data"]
    }
}

struct User : Mappable {
    var status : Int?
    var accessToken : String?
    var roles : String?
    var iD : String?
    var user_login : String?
    var user_pass : String?
    var user_nicename : String?
    var user_email : String?
    var user_url : String?
    var user_registered : String?
    var user_activation_key : String?
    var user_status : String?
    var display_name : String?
    var phone_number : String?
    var city : String?
    var profile_image : String?
    init() {
        
    }
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        accessToken <- map["accessToken"]
        roles <- map["roles"]
        iD <- map["ID"]
        user_login <- map["user_login"]
        user_pass <- map["user_pass"]
        user_nicename <- map["user_nicename"]
        user_email <- map["user_email"]
        user_url <- map["user_url"]
        user_registered <- map["user_registered"]
        user_activation_key <- map["user_activation_key"]
        user_status <- map["user_status"]
        display_name <- map["display_name"]
        phone_number <- map["phone_number"]
        city <- map["city"]
        profile_image <- map["profile_image"]
    }

}

