//
//  ProfileViewModel.swift
//  MyHHS_iOS
//
//  Created by Patel on 26/04/2023.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
class ProfileViewModel: ObservableObject {

  @Published var profileData: ProfileDataModel?
  @Published var profileMember: ProfileMemberModel?
  @Published var isLoading = false
  @Published var errorMessage = ""

  //    var dicData: [[String : Any]]?
  //    var dicMember: [[String : Any]]?

  func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
  }

  func fetchProfileDetails() {
    isLoading = true

    var dicUserDetails: [String: Any] = [:]

    let isKeyPresent = self.isKeyPresentInUserDefaults(key: "user_details")

    if !isKeyPresent {
      return
    }
    dicUserDetails = _userDefault.get(key: "user_details") as! [String: Any]

    var parameters: [String: Any] = [:]
    parameters["user_id"] = dicUserDetails["user_id"]
    parameters["member_id"] = dicUserDetails["member_id"]
    parameters["device"] = "I"
    if _userDefault.get(key: kDeviceToken) != nil {
      parameters["device_token"] = _userDefault.get(key: kDeviceToken) as! String
    } else {
      parameters["device_token"] = ""
    }

    print(parameters)

    APIManager.sharedInstance.callPostApi(url: APIUrl.get_profile, parameters: parameters) {
      (jsonData, error) in
      self.isLoading = false
      if error == nil {
        if let status = jsonData!["status"].int {
          if status == 1 {
            let dicResponse = jsonData?.dictionaryObject
            print(dicResponse!)
            self.profileData = ProfileDataModel.init(
              dicData: dicResponse!["data"] as! [[String: Any]])

            if let dic: [[String: Any]] = dicResponse!["member"] as? [[String: Any]] {
              self.profileMember = ProfileMemberModel.init(dicMember: dic)
            }

            NotificationCenter.default
              .post(
                name: NSNotification.Name("isShakhaTab"),
                object: nil)
          } else {
            if let strError = jsonData!["message"].string {
              self.errorMessage = strError
            }
          }
        } else {
          if let strError = jsonData!["message"].string {
            self.errorMessage = strError
          }
        }
      } else {
        self.errorMessage = error?.localizedDescription ?? "Unknown error occurred."
      }
    }
  }
}
