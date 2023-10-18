//
//  ProfileModel.swift
//  MyHHS_iOS
//
//  Created by Patel on 01/05/2021.
//

import Foundation

class ProfileDataModel {
    var first_name          : String?
    var middle_name         : String?
    var last_name           : String?
    var biometric_key       : String?
    var created_at          : String?
    var device              : String?
    var device_token        : String?
    var email               : String?
    var email_verification_code : String?
    var email_verified_at   : String?
    var facebook_id         : String?
    var google_id           : String?
    var id                  : String?
    var member_id           : String?
    var otp                 : String?
    var password            : String?
    var password_changed_at : String?
    var phone               : String?
    var privileges          : String?
    var profile_word        : String?
    var role                : String?
    var status              : String?
    var token               : String?
    var username            : String?
    
    init(dicData : [[String : Any]]) {
        let dic = dicData[0]
        first_name          = dic["first_name"] as? String
        middle_name         = dic["middle_name"] as? String
        last_name           = dic["last_name"] as? String
        biometric_key       = dic["biometric_key"] as? String
        created_at          = dic["created_at"] as? String
        device              = dic["device"] as? String
        device_token        = dic["device_token"] as? String
        email               = dic["email"] as? String
        email_verification_code = dic["email_verification_code"] as? String
        email_verified_at   = dic["email_verified_at"] as? String
        facebook_id         = dic["facebook_id"] as? String
        google_id           = dic["google_id"] as? String
        id                  = dic["id"] as? String
        member_id           = dic["member_id"] as? String
        otp                 = dic["otp"] as? String
        password            = dic["password"] as? String
        password_changed_at = dic["password_changed_at"] as? String
        phone               = dic["phone"] as? String
        privileges          = dic["privileges"] as? String
        profile_word        = dic["profile_word"] as? String
        role                = dic["role"] as? String
        status              = dic["status"] as? String
        token               = dic["token"] as? String
        username            = dic["username"] as? String
    }
}


class ProfileMemberModel {
    var address_id          : String?
    var address_line_1      : String?
    var address_line_2      : String?
    var admin_approved_at   : String?
    var age                 : String?
    var age_category        : String?
    var building_name       : String?
    var city                : String?
    var country             : String?
    var county              : String?
    var created_at          : String?
    var created_by          : String?
    var date_of_first_aid_qualification : String?
    var dbs_certificate_date: String?
    var dbs_certificate_file: String?
    var dbs_certificate_number          : String?
    var dob                 : String?
    var email               : String?
    var email_verification_code         : String?
    var email_verified_at   : String?
    var emergency_address_id: String?
    var emergency_name      : String?
    var emergency_phone     : String?
    var emergency_email     : String?
    var emergency_relatioship           : String?
    var family_group_id     : String?
    var first_aid_date      : String?
    var first_aid_qualification_file    : String?
    var first_name          : String?
    var gender              : String?
    var guardian_approved_at: String?
    var indian_connection_state         : String?
    var is_admin_approved   : String?
    var is_email_verified   : String?
    var is_guardian_approved: String?
    var is_parent_approved  : String?
    var is_qualified_in_first_aid       : String?
    var land_line           : String?
    var last_name           : String?
    var medical_details     : String?
    var medical_information_declare     : String?
    var member_age          : String?
    var member_id           : String?
    var middle_name         : String?
    var mobile              : String?
    var nagar               : String?
    var nagar_id            : String?
    var occupation          : String?
    var other_emergency_relationship    : String?
    var other_relationship  : String?
    var parent_approved_at  : String?
    var parse_dob           : String?
    var postal_code         : String?
    var rejection_msg       : String?
    var relationship        : String?
    var root_language       : String?
    var safeguarding_certificate        : String?
    var safeguarding_training_complete  : String?
    var safeguarding_training_completed_on: String?
    var secondary_email     : String?
    var shakha              : String?
    var shakha_id           : String?
    var shakha_sankhya_avg  : String?
    var shakha_tab          : String?
    var special_med_dietry_info         : String?
    var status              : String?
    var university_id       : String?
    var update_by           : String?
    var updated_at          : String?
    var user_id             : String?
    var vibhag              : String?
    var vibhag_id           : String?
    var whatsapp            : String?
    
    
    init(dicMember : [[String : Any]]) {
        let dic = dicMember[0]
        address_id          = dic["address_id"] as? String
        address_line_1      = dic["address_line_1"] as? String
        address_line_2      = dic["address_line_2"] as? String
        admin_approved_at   = dic["admin_approved_at"] as? String
        age                 = dic["age"] as? String
        age_category        = dic["age_category"] as? String
        building_name       = dic["building_name"] as? String
        city                = dic["city"] as? String
        country             = dic["country"] as? String
        county              = dic["county"] as? String
        created_at          = dic["created_at"] as? String
        created_by          = dic["created_by"] as? String
        date_of_first_aid_qualification     = dic["date_of_first_aid_qualification"] as? String
        dbs_certificate_date                = dic["dbs_certificate_date"] as? String
        dbs_certificate_file                = dic["dbs_certificate_file"] as? String
        dbs_certificate_number              = dic["dbs_certificate_number"] as? String
        dob                 = dic["dob"] as? String
        email               = dic["email"] as? String
        email_verification_code             = dic["email_verification_code"] as? String
        email_verified_at   = dic["email_verified_at"] as? String
        emergency_address_id                = dic["emergency_address_id"] as? String
        emergency_email     = dic["emergency_email"] as? String
        emergency_name      = dic["emergency_name"] as? String
        emergency_phone     = dic["emergency_phone"] as? String
        emergency_relatioship               = dic["emergency_relatioship"] as? String
        family_group_id     = dic["family_group_id"] as? String
        first_aid_date      = dic["first_aid_date"] as? String
        first_aid_qualification_file        = dic["first_aid_qualification_file"] as? String
        first_name          = dic["first_name"] as? String
        gender              = dic["gender"] as? String
        guardian_approved_at                = dic["guardian_approved_at"] as? String
        indian_connection_state             = dic["indian_connection_state"] as? String
        is_admin_approved   = dic["is_admin_approved"] as? String
        is_email_verified   = dic["is_email_verified"] as? String
        is_guardian_approved                = dic["is_guardian_approved"] as? String
        is_parent_approved  = dic["is_parent_approved"] as? String
        is_qualified_in_first_aid           = dic["is_qualified_in_first_aid"] as? String
        land_line           = dic["land_line"] as? String
        last_name           = dic["last_name"] as? String
        medical_details     = dic["medical_details"] as? String
        medical_information_declare         = dic["medical_information_declare"] as? String
        member_age          = "\(dic["member_age"] ?? "")"
        member_id           = dic["member_id"] as? String
        middle_name         = dic["middle_name"] as? String
        mobile              = dic["mobile"] as? String
        nagar               = dic["nagar"] as? String
        nagar_id            = dic["nagar_id"] as? String
        occupation          = dic["occupation"] as? String
        other_emergency_relationship        = dic["other_emergency_relationship"] as? String
        other_relationship  = dic["other_relationship"] as? String
        parent_approved_at  = dic["parent_approved_at"] as? String
        parse_dob           = dic["parse_dob"] as? String
        postal_code         = dic["postal_code"] as? String
        rejection_msg       = dic["rejection_msg"] as? String
        relationship        = dic["relationship"] as? String
        root_language       = dic["root_language"] as? String
        safeguarding_certificate            = dic["safeguarding_certificate"] as? String
        safeguarding_training_complete      = dic["safeguarding_training_complete"] as? String
        safeguarding_training_completed_on  = dic["safeguarding_training_completed_on"] as? String
        secondary_email     = dic["secondary_email"] as? String
        shakha              = dic["shakha"] as? String
        shakha_id           = dic["shakha_id"] as? String
        shakha_sankhya_avg  = dic["shakha_sankhya_avg"] as? String
        shakha_tab          = dic["shakha_tab"] as? String
        special_med_dietry_info             = dic["special_med_dietry_info"] as? String
        status              = dic["status"] as? String
        university_id       = dic["university_id"] as? String
        update_by           = dic["update_by"] as? String
        updated_at          = dic["updated_at"] as? String
        user_id             = dic["user_id"] as? String
        vibhag              = dic["vibhag"] as? String
        vibhag_id           = dic["vibhag_id"] as? String
        whatsapp            = dic["whatsapp"] as? String
    }
}
