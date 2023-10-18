//
//  CommonFunctions.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import AVFoundation
import NVActivityIndicatorView
import RAGTextField

struct AppUtility {
    
    static func isLogin() -> Bool {
        if let isLogin = Singleton.shared.get(key: APP.isLogin) as? String, isLogin == "1" {
            return true
        }else{
            return false
        }
    }
    
    static func isBiometric() -> Bool {
        if let isBiometric = Singleton.shared.get(key: APP.isBiometric) as? String, isBiometric == "1" {
            return true
        }else{
            return false
        }
    }
}


func addNavigationBar(controller : UIView,rightbtn : UIButton,lbltitle : UILabel,leftbtn : UIButton)-> UIView
{
	let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: controller.frame.size.width, height: 50))
	vw.backgroundColor = Colors.txtAppDarkColor
	rightbtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
	leftbtn.frame = CGRect.init(x: controller.frame.size.width - 50, y: 0, width: 40, height: 40)
	lbltitle.frame = CGRect.init(x: controller.frame.size.width/2 - 20, y: 0, width: 40, height: 40)
	vw.addSubview(rightbtn)
	vw.addSubview(lbltitle)
	vw.addSubview(leftbtn)
	return vw
}

func showSettingsAlert() {
    let settingsAction: ((UIAlertAction) -> Void) = { action in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    let cancelAction: ((UIAlertAction) -> Void) = { action in }
    alertWithAction(title: "", message: "Please go to Settings and turn on the permissions", actionTitles: ["Setting", "cancel".localized], actions: [settingsAction, cancelAction])
}

func alertWithAction(title: String?, message: String?, actionTitles: [String?], actions: [((UIAlertAction) -> Void)?]) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
func createTextField(txtPlaceholder : String, txtfield : RAGTextField , Img : String) -> RAGTextField{
	let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
	img.image = UIImage.init(named: Img)
	txtfield.leftView = img
	txtfield.leftViewMode = .always
	txtfield.placeholder = txtPlaceholder
//	let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
//	let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
	let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
	let bgView = UnderlineView(frame: .zero)
            bgView.textField = txtfield
            bgView.backgroundLineColor = Colors.txtAppDarkColor
            
            bgView.foregroundLineColor = Colors.txtAppDarkColor
            bgView.foregroundLineWidth = 2.0
            bgView.expandDuration = 0.2

            if #available(iOS 11, *) {
                bgView.layer.cornerRadius = 4.0
                bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            txtfield.placeholderColor = Colors.txtBorderColor
            txtfield.textPadding = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
            txtfield.tintColor = overcastBlueColor
            txtfield.textBackgroundView = bgView
			txtfield.placeholderScaleWhenEditing = 0.8
			return txtfield
			
}
func showAlert(title : String?, message : String?) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok".localized, style: .default) { action in
        })
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(_ testStr:String) -> Bool {
    let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
//    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
//    return passwordTest.evaluate(with: testStr)
    return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: testStr)
}


func uicolorFromHex(rgbValue:UInt32)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
    let blue = CGFloat(rgbValue & 0xFF)/255.0
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
}

func getTextSize(textV : String, wdth : CGFloat , hght : CGFloat) -> CGRect{
    let font = UIFont(name: "HelveticaNeue", size: 16)!
    let textAttributes = [NSAttributedString.Key.font: font]
    let textRect = textV.boundingRect(with: CGSize(width: wdth, height: hght), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
    return textRect
}

func setDeviceToken(deviceToken: String?) {
    if let strToken = deviceToken {
        _userDefault.save(object: strToken, key: kDeviceToken)
    } else {
        _userDefault.delete(key: kDeviceToken)
    }
}

func getDeviceToken() -> String? {
    if let token = _userDefault.get(key: kDeviceToken) as? String{
        return token
    }
    return ""
}


