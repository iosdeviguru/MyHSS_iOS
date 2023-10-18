//
//  ApiConstant.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation
let bundleID = Bundle.main.bundleIdentifier


// ********* <<<VERY IMPORTANT to switch environment before app publish on appstore connect/ testflight/ relese. Use prodURL for every new build/launch. Rest of the development and testing locally should be carried out on stgURL(More preferable) or devURL  >>>************

let devURL = "https://dev.myhss.org.uk/"
let stgURL = "https://stg.myhss.org.uk/"
let prodURL = "https://myhss.org.uk/"
//let BaseURL = prodURL   //stgURL
//let BaseURL = stgURL
let BaseURL = stgURL

let BaseURL_member = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/member/" : "\(BaseURL)api/v1/member/"
let BaseURL_user = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/user/" : "\(BaseURL)api/v1/user/"
let BaseURL_login = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/auth/" : "\(BaseURL)api/v1/auth/"
let BaseURL_guru_dakshina = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/guru_dakshina/" : "\(BaseURL)api/v1/guru_dakshina/"
let BaseURL_sankhya = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/sankhya/" : "\(BaseURL)api/v1/sankhya/"
let BaseURL_karyakarta = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/karyakarta/" : "\(BaseURL)api/v1/karyakarta/"
let BaseURL_suryanamaskar = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)api/v1/suryanamaskar" : "\(BaseURL)api/v1/suryanamaskar"
let PrivacyWebUrl = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)page/privacy-policy/1" : "\(BaseURL)page/privacy-policy/1"
let TermsConditionsWebUrl = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)page/terms-conditions/2" : "\(BaseURL)page/terms-conditions/2"
let MembershipWebUrl = bundleID == "com.uk.MyHSS.MyHSS" ? "\(BaseURL)page/hss-uk-membership-agreement/7" : "\(BaseURL)page/hss-uk-membership-agreement/7"
let BaseURL_download = "\(BaseURL)assets/qualification_file/"

var userInfo : User!

struct APIKey {

    static let Header           = ""
    static let message          = "message"
    static let fail             = "error"
    static let success          = "code"  // 200 success
    static let data             = "Data"
    static let error            = "ERROR"

    struct Register {
        static let fname            = "fname"
        static let lname            = "lname"
        static let email            = "email"
        static let password         = "password"
        static let phone_number     = "phone_number"
        static let city             = "city"
        static let deviceType       = "deviceType"
        static let deviceToken      = "deviceToken"
        static let profile_image    = "profile_image"
    }

    struct Response {
        static let message          = "message"
        static let status           = "code"
        static let data             = "data"
    }

}

struct APIUrl {
    static let latest_update        = BaseURL_user + "latest_update"
    static let change_password      = BaseURL_user + "change_password"
    
    static let register             = BaseURL_login + "register"
    static let login                = BaseURL_login + "login"
    static let forgot_password      = BaseURL_login + "forgot_password"
    static let welcome              = BaseURL_member + "welcome"
    static let get_relationship     = BaseURL_member + "get_relationship"
    static let get_Occuptions       = BaseURL_member + "get_occupations"
    static let get_vibhag           = BaseURL_member + "get_vibhag"
    static let get_nagar            = BaseURL_member + "get_nagar_by_vibhag"
    static let get_shakha           = BaseURL_member + "get_shakha_by_nagar"
    static let get_address_pincode  = BaseURL_member + "find_address_by_pincode"
    static let get_address_by_id    = BaseURL_member + "find_address_info_by_id"
    static let get_dietaries        = BaseURL_member + "get_dietaries"
    static let get_languages        = BaseURL_member + "get_languages"
    static let get_indian_states    = BaseURL_member + "get_indianstates"
    static let create_member        = BaseURL_member + "create_membership"
    static let update_member        = BaseURL_member + "update_membership"
    static let get_profile          = BaseURL_member + "profile"
    static let get_listing          = BaseURL_member + "listing"
    static let get_membershipApplications = BaseURL_member + "memberlist"

    static let get_approve          = BaseURL_member + "approve"
    static let get_inactive         = BaseURL_member + "inactive"
    static let get_delete           = BaseURL_member + "delete"
    static let get_reject           = BaseURL_member + "reject"
    static let get_shakha_list      = BaseURL_member + "get_shakha_list"
    static let get_shakha_detail    = BaseURL_member + "get_shakha_detail"
    static let check_username_exist = BaseURL_member + "check_username_exist"
    static let get_suchana_by_member = BaseURL_member + "get_suchana_by_member"
    static let seen_suchana_by_member = BaseURL_member + "seen_suchana_by_member"

    static let create_onetime       = BaseURL_guru_dakshina + "create_onetime"
    static let create_regular       = BaseURL_guru_dakshina + "create_regular"
    static let family_members       = BaseURL_guru_dakshina + "family_members"
    static let get_dakshina_list    = BaseURL_guru_dakshina + "listing"
    
    static let get_sankhya_list     = BaseURL_sankhya + "listing"
    static let get_utsav            = BaseURL_sankhya + "utsav"
    static let get_sankhya_members  = BaseURL_sankhya + "members"
    static let add_sankhya          = BaseURL_sankhya + "add"
    static let delete_sankhya       = BaseURL_sankhya + "delete"
    static let get_record           = BaseURL_sankhya + "get_record"

    static let get_members          = BaseURL_karyakarta + "get_members"
    
    static let get_suryanamaskar    = BaseURL_suryanamaskar + "get_suryanamaskar_count"
    static let save_suryanamaskar   = BaseURL_suryanamaskar + "save_suryanamaskar_count"
}


struct APP {
    
    static let title    = "MyHss"
    static let isLogin  = "isLogin"
    static let isBiometric  = "isBiometric"
    static let isIntro  = "isIntro"
    static let userData = "userData"
    static let accessToken = "accessToken"
    static let appleID = 1566351540
    static let isForceUpdate = "isForceUpdate"
}

struct PreferenceKey {
    static let LoginUser  = "loginUser"
    static let IsFirstTime  = "installApp"
}
