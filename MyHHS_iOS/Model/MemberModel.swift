//
//  MemberModel.swift
//  MyHHS_iOS
//
//  Created by Patel on 11/03/2021.
//

import Foundation

class memberModel {
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var gender: String?
    var dob: String?
    var age: String?
    var relationship: String?
    var otherRelationship: String?
    var occupation: String?
    var occupationName: String?
    var shakha: String?
    var mobile: String?
    var landLine: String?
    var postCode: String?
    var buildingName: String?
    var addressLine1: String?
    var addressLine2: String?
    var postTown: String?
    var county: String?
    var country: String?
    var emergencyName: String?
    var emergencyPhone: String?
    var emergencyEmail: String?
    var emergencyRelatioship: String?
    var otherEmergencyRelationship: String?
    var medicalInformation: String?
    var provideDetails: String?
    var isQualifiedInFirstAid: String?
    var dateOfFirstAidQualification: String?
    var specialMedDietryInfo: String?
    var language: String?
    var state: String?
    var parentMemberId: String?
    var type: String?
    var isLinked: String?
    var isSelf: String?

    init(dic : [String : Any]) {
        firstName = dic["first_name"] as? String
        middleName = dic["middle_name"] as? String
        lastName = dic["last_name"] as? String
        gender = dic["username"] as? String
        gender = dic["gender"] as? String
        dob = dic["dob"] as? String
        age = dic["age"] as? String
        relationship = dic["relationship"] as? String
        otherRelationship = dic["other_relationship"] as? String
        occupation = dic["occupation"] as? String
        occupationName = dic["occupation_name"] as? String
        shakha = dic["shakha"] as? String
        mobile = dic["mobile"] as? String
        landLine = dic["land_line"] as? String
        postCode = dic["post_code"] as? String
        buildingName = dic["building_name"] as? String
        addressLine1 = dic["address_line_1"] as? String
        addressLine2 = dic["address_line_2"] as? String
        postTown = dic["post_town"] as? String
        county = dic["county"] as? String
        country = dic["country"] as? String
        emergencyName = dic["emergency_name"] as? String
        emergencyPhone = dic["emergency_phone"] as? String
        emergencyEmail = dic["emergency_email"] as? String
        emergencyRelatioship = dic["emergency_relatioship"] as? String
        otherEmergencyRelationship = dic["other_emergency_relationship"] as? String
        medicalInformation = dic["medical_information"] as? String
        provideDetails = dic["provide_details"] as? String
        isQualifiedInFirstAid = dic["is_qualified_in_first_aid"] as? String
        dateOfFirstAidQualification = dic["date_of_first_aid_qualification"] as? String
        specialMedDietryInfo = dic["special_med_dietry_info"] as? String
        language = dic["language"] as? String
        state = dic["state"] as? String
        parentMemberId = dic["parent_member_id"] as? String
        type = dic["type"] as? String
        isLinked = dic["is_linked"] as? String
        isSelf = dic["is_self"] as? String
    }
}
