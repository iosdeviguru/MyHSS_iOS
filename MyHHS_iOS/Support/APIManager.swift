//
//  APIManager.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

var API_Token = ""

class APIManager {
    class var sharedInstance : APIManager {
        struct Static {
            static let instance : APIManager = APIManager()
        }
        return Static.instance
    }
    
    
    func callGetApi(url: String, showActivityIndicator: Bool = false,callBack:@escaping (_ dataFromServer: JSON?, _ error:Error?) -> Void){
        
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP.title, message: Messages.API.noInternet)
            return
        }
        
        let headers: HTTPHeaders = [
            //.authorization(username: "test@email.com", password: "testpassword"),
            //.accept("application/json")
        ]
        print("URL : \(url)")
        print("header : \(headers)")
        
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            debugPrint("\nResponse:\n",response)
            
            switch response.result {
            case .success(let value):
                let finalJson = JSON(value)
                callBack(finalJson,nil)

            case .failure(let error):
                callBack(nil,error)
                print("\nResponse ERROR:\n",error.localizedDescription)
            }
        }
    }
    
    func callPostApi(url: String, parameters: [String:Any], callBack:@escaping (_ data: JSON?, _ error:Error?) -> Void){
        
        if !Connectivity.isConnectedToInternet() {
            showAlert(title: APP.title, message: Messages.API.noInternet)
            return
        }

		let headers: HTTPHeaders = [
            //"Content-Type":"application/json",
            //"Accept": "application/json"
        ]

        print("URL : \(url)")
        print("header : \(headers)")
        print("parameters : \(parameters)")


        AF.request(url, method: .post , parameters: parameters, headers: headers).responseJSON { response in
            debugPrint("\nResponse:\n",response)

            switch response.result {
            case .success(let value):
                let finalJson = JSON(value)
                callBack(finalJson,nil)

            case .failure(let error):
                callBack(nil,error)
                print("\nResponse ERROR:\n",error.localizedDescription)
            }
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
