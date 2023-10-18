//
//  APIManager.swift
//  Little John
//
//  Created by Jack on 10/07/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

var API_Token = ""



class APIManager {
private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    class var sharedInstance : APIManager {
        struct Static {
            static let instance : APIManager = APIManager()
        }
        return Static.instance
    }
	var activityIndicatorView : NVActivityIndicatorView!
    func startAnimation(withMessage: String = "") {
    var window: UIWindow?
    
		 let indicatorType = presentingIndicatorTypes[23]
		let size = CGSize(width: 30, height: 30)
		let frame = window?.frame as! CGRect
		
		activityIndicatorView = NVActivityIndicatorView(frame: frame,type: indicatorType)
		
		activityIndicatorView.startAnimating()
		
        
    }
    
    func stopAnimation() {
        
        activityIndicatorView.stopAnimating()
    }
    
    func getData(requestUrl: String,parameters: [String:Any]?,header: [String:String]?,showActivityIndicator: Bool = false,callBack:@escaping (_ dataFromServer: JSON?, _ error:Error?) -> Void) -> DataRequest
    {
        print("url : \(requestUrl)")
        if showActivityIndicator == true
        {
            self.startAnimation()
        }
        
        let request2 =  Alamofire.request(requestUrl).responseJSON { (response:DataResponse<Any>) in
            vbprint(response)
            if showActivityIndicator == true
            {
                self.stopAnimation()
            }
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let finalJson = JSON(data)
                    callBack(finalJson,nil)
                }
                break
            case .failure(_):
                if let error = response.result.error
                {
                    callBack(nil,error)
                    print("Error",error.localizedDescription)
                }
                debugPrint("\nResponse ERROR:\n",response)
                break
            }
        }
        
       
        //debugPrint("Request:\n",request)
        return request2
        
    }

    
    
    func getPostData(requestUrl: String,parameters: [String:Any]?,header: [String:String]?,showActivityIndicator: Bool = false,callBack:@escaping (_ dataFromServer: JSON?, _ error:Error?) -> Void) -> DataRequest
    {
        
       /* let parameter = NSMutableDictionary.init(dictionary: parameters!)
        let lang = Locale.current.languageCode
        if(lang == "da")
        {
            parameter[ServiceKey.language] =  "da-DK"
        }else if(lang == "ku"){
            parameter[ServiceKey.language] =  "ku"
        }else if(lang == "fa"){
            parameter[ServiceKey.language] =  "fa"
        }else{
            parameter[ServiceKey.language] =  "en-GB"
        }*/
        
        print("url : \(requestUrl)")
        if showActivityIndicator == true
        {
           self.startAnimation()
        }
         
        let request =  Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            vbprint(response)
            if showActivityIndicator == true
            {
                self.stopAnimation()
            }
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let finalJson = JSON(data)
                    callBack(finalJson,nil)
                }
                break
            case .failure(_):
                if let error = response.result.error
                {
                    callBack(nil,error)
                    print("Error",error.localizedDescription)
                }
                debugPrint("\nResponse ERROR:\n",response)
                break
            }
        }
        
        //debugPrint("Request:\n",request)
        return request
    }

    func sendData(webservice: String,parameter: [String: Any]?, dataImage: UIImage?,showActivityIndicator: Bool = false,callBack:@escaping (_ dataFromServer: JSON?, _ error:Error?) -> Void) {
         print("url : \(webservice)")
        if showActivityIndicator == true {
            self.startAnimation()
        }
        
        DispatchQueue.global().async {
            let manager = BackgroundCommunicator.shared.manager
            manager.startRequestsImmediately = true
            //manager.session.configuration.timeoutIntervalForRequest = 10 * 60
            manager.upload(multipartFormData: { (multipartFormData) in
                if let dicUpload = parameter
                {
                    for (key , value) in dicUpload {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                if dataImage != nil{
                    if let imageDataFinal = dataImage!.pngData() {
                        multipartFormData.append(imageDataFinal, withName: "image", fileName: "myImage.png", mimeType: "image/png")
                        //[formData appendPartWithFileData:picturedata  name:@"file" fileName:@"testvideo.mov" mimeType:@"video/quickTime"];
                        //[formData appendPartWithFileData:tempData name:@"video_file" fileName:[path lastPathComponent] mimeType:@"video/mp4"];
                        
                    }
                }
                
                
            }, to: webservice) { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print(Float(progress.fractionCompleted))
                    }).responseJSON(completionHandler: { (response) in
                        if showActivityIndicator == true {
                            self.stopAnimation()
                        }
                        
                        switch(response.result) {
                        case .success(_):
                            if let data = response.result.value{
                                let finalJson = JSON(data)
                                callBack(finalJson, nil)
                            }
                            break
                            
                        case .failure(_):
                            print(response.result.error)
                            if let error = response.result.error {
                                callBack(nil, error)
                            }
                            break
                        }
                    })
                case .failure(let encodingError):
                   callBack(nil, encodingError)
                }
            }
            
        }
    }
    
    func sendDataWithImageVideo(webservice: String,parameter: [String: Any]?, data: Data?,showActivityIndicator: Bool = false,callBack:@escaping (_ dataFromServer: JSON?, _ error:Error?) -> Void) {
         print("url : \(webservice)")
        if showActivityIndicator == true {
            self.startAnimation()
        }
        
        DispatchQueue.global().async {
            let manager = BackgroundCommunicator.shared.manager
            manager.startRequestsImmediately = true
           //manager.session.configuration.timeoutIntervalForRequest = 10 * 60
            manager.upload(multipartFormData: { (multipartFormData) in
                if let dicUpload = parameter
                {
                    for (key , value) in dicUpload {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                if data != nil{
                    if isImageVideo == "0"{
                        multipartFormData.append(data!, withName: "image", fileName: "myImage.png", mimeType: "image/png")
                    }else if isImageVideo == "1"{
                        multipartFormData.append(data!, withName: "image", fileName: "video.mov", mimeType: "video/mp4")
                    }
                }
        }, to: webservice) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(Float(progress.fractionCompleted))
                }).responseJSON(completionHandler: { (response) in
                    if showActivityIndicator == true {
                        self.stopAnimation()
                    }
                    
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            let finalJson = JSON(data)
                            callBack(finalJson, nil)
                        }
                        break
                        
                    case .failure(_):
                        print(response.result.error)
                        if let error = response.result.error {
                            callBack(nil, error)
                        }
                        break
                    }
                })
            case .failure(let encodingError):
                callBack(nil, encodingError)
            }
        }
        
    }
    }
}
