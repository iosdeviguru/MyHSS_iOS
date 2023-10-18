//
//  Constant.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

//MARK: - Important Enums
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

enum PickerType: Int {
    case list = 1
    case date
}

enum Corner:Int {
    case bottomRight = 0,
    topRight,
    bottomLeft,
    topLeft
}


let kDeviceToken = "DeviceToken"
let kUserInfo = "UserInfo"
let kIsLogedIn = "kIsLogedIn"

var _navSize: CGFloat = 30
var _hederSize: CGFloat = 17
var _btnTitleSize: CGFloat = 15
var _txtTitleSize: CGFloat = 17
var _lblTextSize: CGFloat = 17


//MARK: - Global constant
let _screenFrame            = UIScreen.main.bounds
let _screenSize             = _screenFrame.size
let _defaultCenter          = NotificationCenter.default
let _appDelegator           = UIApplication.shared.delegate as! AppDelegate
let _appName                = Bundle.main.infoDictionary!["CFBundleName"] as! String
let _statusBarHeight        = UIApplication.shared.statusBarFrame.height
let _userDefault            = Singleton.shared
let _imgPlaceHolder         = #imageLiteral(resourceName: "placeholder")
let _mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)

var userData : NSMutableDictionary = [:]
var deviceID                = "Simulator"
var deviceflag              = "2" // 2 = iOS
var isRequireToUpdate       = 0
var selectedMenuIndex       = 0
var fromScreen              = Screens.Login

struct Preferance {
    struct global {
        static var user: User = User()
    }
}

struct APPKeys {
    static let google  = ""
}

struct Screens {
    static let Login  = "Login"
    static let Home  = "Home"
}
