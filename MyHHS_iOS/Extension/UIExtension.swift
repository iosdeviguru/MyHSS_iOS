//
//  UIExtension.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import SDWebImage
import NVActivityIndicatorView
import CoreLocation
import Firebase

//MARK:- UITextField
extension SkyFloatingLabelTextField {
    func setupUI(placeholderTxt: String, fontSize: CGFloat) {
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        placeholderColor = Colors.bglightGray
        titleColor = Colors.bglightGray
        font = Font.Regular.of(size: fontSize)
        selectedLineColor = Colors.txtbolddarkGray
        selectedTitleColor = Colors.txtbolddarkGray
    }
}
extension UITextField {
    func setupUIForNormalTXT(placeholderTxt: String, fontSize: CGFloat) {
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
    }
    
    func setupUIForAddVehicle(placeholderTxt: String, fontSize: CGFloat) {
        self.setLeftPaddingPoints()
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
        backgroundColor = Colors.txtBG
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = Colors.txtBorderColor.cgColor
        self.layer.borderWidth = 1.0
    }
    func setupUIForDestination(placeholderTxt: String, fontSize: CGFloat, borderColor: UIColor, bgColor:UIColor) {
        self.setLeftPaddingPoints()
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
        backgroundColor = bgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
    }
}

//MARK:- UIButton
extension UIButton {
    func setupRoundedUI(title: String, fontSize: CGFloat) {
        cornerRadius = self.frame.size.height / 2
        setTitle(title, for: .normal)
        titleLabel?.font = Font.Regular.of(size: fontSize)
        setTitleColor(#colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1), for: .normal)
        self.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    }
    
    func setupRoundedUI(title: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor) {
        cornerRadius = self.frame.size.height / 2
        setTitle(title, for: .normal)
        titleLabel?.font = Font.Regular.of(size: fontSize)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
    }
    
    func embossShadow(color: UIColor){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 1.0;
        self.layer.shadowOffset = CGSize(width: 0, height: 3);
    }
}

//MARK:- UILabel
extension UILabel {
    func setupHeader(title: String, fontSize: CGFloat) {
        text = title
        backgroundColor = .clear
        font = Font.Regular.of(size: fontSize)
        textColor = Colors.yellow
    }
    
    func setupIntroTitle(title: String, fontSize: CGFloat) {
        text = title
        backgroundColor = .clear
        font = Font.Bold.of(size: fontSize)
        textColor = Colors.txtbolddarkGray
    }
    func setupIntroDescription(title: String, fontSize: CGFloat) {
        text = title
        backgroundColor = .clear
        font = Font.Regular.of(size: fontSize)
        textColor = Colors.txtdarkGray
    }
}

//MARK:- UITextView
extension UITextView {
    func setPlaceholder(placeholderTxt: String, fontSize: CGFloat){
        text = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
    }
}
//MARK:- UITextField
extension UITextField {
    
    func setPlaceholder(placeholderTxt: String, fontSize: CGFloat){
        setLeftPaddingPoints()
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
        self.layer.cornerRadius = 10
        self.layer.borderColor = Colors.txtBorderColor.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setLeftPaddingPoints(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightPaddingWithImage(placeholderTxt: String, img : UIImage, fontSize: CGFloat, isLeftPadding:Bool){
        if isLeftPadding{
            setLeftPaddingPoints()
        }
        let imgHW:CGFloat = 20
        let imgY = (self.frame.size.height / 2) - (imgHW / 2)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
        let imgv = UIImageView(frame:  CGRect(x: 5, y: imgY, width: imgHW, height: imgHW))
        imgv.image = img
        imgv.contentMode = UIView.ContentMode.scaleAspectFit
        paddingView.addSubview(imgv)
        self.rightView = paddingView
        self.rightViewMode = .always
        
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = Colors.txtBorderColor.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func setLeftPaddingWithImage(placeholderTxt: String, img : UIImage, fontSize: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        let imgv = UIImageView(frame:  CGRect(x: 15, y: 10, width: 30, height: 30))
        imgv.image = img
        imgv.contentMode = UIView.ContentMode.scaleAspectFit
        paddingView.addSubview(imgv)
        self.leftView = paddingView
        self.leftViewMode = .always
        
        placeholder = placeholderTxt
        textColor = Colors.txtbolddarkGray
        font = Font.Regular.of(size: fontSize)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = Colors.txtBorderColor.cgColor
        self.layer.borderWidth = 1.0
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set(hasDone){
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}

//MARK:- UIView
extension UIView {
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    @IBInspectable
    open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set(value) {
            layer.shadowPath = value
        }
    }
    
    @IBInspectable
    open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            layer.cornerRadius = value
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor? {
        get {
            guard let v = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: v)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: [Corner], radius: CGFloat) {
        layer.cornerRadius = radius
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createMask(corners: corners))
        if #available(iOS 11.0, *) {
            layer.maskedCorners = maskedCorners
            layer.opacity = Float(maskedCorners.rawValue)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundedTopView(){
        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    private func createMask(corners: [Corner]) -> UInt {
        return corners.reduce(0, { (a, b) -> UInt in
            return a + parseCorner(corner: b).rawValue
        })
    }
    
    private func parseCorner(corner: Corner) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[corner.rawValue]
    }
    
    func roundCornersView(corners: [Corner], amount: CGFloat) {
        layer.cornerRadius = amount
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createMask(corners: corners))
        if #available(iOS 11.0, *) {
            layer.maskedCorners = maskedCorners
            layer.opacity = Float(maskedCorners.rawValue)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}

//MARK:- UIImage
extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ quality: JPEGQuality) -> UIImage? {
        let imgData : Data = self.jpegData(compressionQuality: quality.rawValue)!
        let image : UIImage = UIImage(data: imgData)!
        return image
    }
    
    func jpegWithData(_ quality: JPEGQuality) -> Data? {
        let imgData : Data = self.jpegData(compressionQuality: quality.rawValue)!
        return imgData
    }
}

//MARK:- UIApplication
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

//MARK:- UIImageView
extension UIImageView {
    
    public func imageFromURL(_ urlString : String, placeHolder : UIImage){
        if let url = URL(string: urlString) {
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_setImage(with: url, placeholderImage: placeHolder, options: SDWebImageOptions(rawValue: 8), completed: { (image, error, cacheType, imageURL) in
            })
        }
    }
}

//MARK:- UIViewController
extension UIViewController {
    
    func hideNavigationBar()  {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func firebaseAnalytics(_eventName: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: _eventName,
          AnalyticsParameterItemName: _eventName
          ])
    }
}

let window = UIApplication.shared.keyWindow

 let topPadding = window?.safeAreaInsets.top

 let bottomPadding = window?.safeAreaInsets.bottom

 let guide = window?.safeAreaLayoutGuide

 let height = guide?.layoutFrame.size.height

 let safeAreaWidth = guide?.layoutFrame.size.width

 let width = UIScreen.main.bounds.width/4

 let parentView = UIView(frame: CGRect(x: 0 , y:( UIScreen.main.bounds.height - 65) - bottomPadding!   , width: safeAreaWidth!, height: 65))

 let blurparentView = UIView(frame: CGRect(x: 0, y: 0, width: safeAreaWidth!, height: 60))

 let backImage = UIImageView(frame: CGRect(x: 0 , y: 10, width: 35, height: 35))
 
 let menuImage = UIImageView(frame: CGRect(x: 5 , y: 15, width: 25, height: 20))

 let homeImage = UIImageView(frame: CGRect(x: 6.5 , y: 13, width: 25, height: 27))

 let cartImage = UIImageView(frame: CGRect(x: 0 , y: 10, width: 35, height: 35))

 let cartLabel = UILabel(frame: CGRect(x: 14, y: -4, width: 14, height: 14))

let lblWidth = UIScreen.main.bounds.width/1.5


 extension UIViewController {

    func createButton(btn: UIButton) -> UIButton {
        btn.addTarget(self, action: #selector(clickMenu), for: .touchUpInside)
    return btn
    }
    
    func navigationBarDesign(txt_title : String, showbtn: String) {
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: safeAreaWidth!, height: topPadding! + 55))
        parentView.backgroundColor = Colors.txtAppDarkColor
        let back = UIView(frame: CGRect(x: 10, y:  topPadding! + 5, width: 40, height: 60))
        let title = UIView(frame: CGRect(x: (lblWidth - lblWidth/2)/2, y: 0, width: lblWidth, height: 60))
        let cart = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 50, y:  topPadding! + 5, width: 40, height: 60))
        
        blurparentView.backgroundColor = Colors.txtBlack
        backImage.image = UIImage.init(named: "Backbtn")
        menuImage.image = UIImage.init(named: "BurgerMenu_icn")
        homeImage.image = UIImage.init(named: "Dashboard_white")
        cartImage.image = nil
        
        let titlelabel = UILabel(frame: CGRect(x: 0, y: topPadding!, width: lblWidth, height: 60))
        titlelabel.font = Font.Regular.of(size: 20)
        titlelabel.text = txt_title
        titlelabel.textAlignment = .center
        titlelabel.textColor = .white
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let cartButton = UIButton(frame: CGRect(x: 0, y:  0, width: 50, height: 50))
//        backButton = self.createButton(btn: backButton)
        cartLabel.textAlignment = .center
        cartLabel.textColor = .white
        cartLabel.font = UIFont.boldSystemFont(ofSize: 8.0)
        cartLabel.backgroundColor = .black
        cartLabel.isHidden = true
        
        cartButton.addTarget(self, action: #selector(rightBarItemClicked(_:)), for: .touchUpInside)
        
        
        if showbtn == "back" {
            back.addSubview(backImage)
            back.addSubview(backButton)
            backButton.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        } else if showbtn == "menu" {
            back.addSubview(menuImage)
            back.addSubview(backButton)
            backButton.addTarget(self, action: #selector(clickMenu), for: .touchUpInside)
        } else if showbtn == "Dashboard_white" {
            back.addSubview(homeImage)
            back.addSubview(backButton)
            backButton.addTarget(self, action: #selector(clickHome), for: .touchUpInside)
        }
        
        title.addSubview(titlelabel)
        
        cart.addSubview(cartImage)
        cart.addSubview(cartButton)
        cartImage.addSubview(cartLabel)
        
        parentView.addSubview(back)
        parentView.addSubview(title)
        parentView.addSubview(cart)
        parentView.addSubview(blurparentView)
        
        blurparentView.isHidden = true
        
        view.addSubview(parentView)
    }
     
     func navigationBarDesignForPasscode() {
         self.navigationItem.setHidesBackButton(true, animated: true)
         
     }

    func navigationBarWithRightButtonDesign(txt_title : String, showbtn: String, rightImg: String, bagdeVal: String, isBadgeHidden: Bool) {
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: safeAreaWidth!, height: topPadding! + 55))
        parentView.backgroundColor = Colors.txtAppDarkColor
        let back = UIView(frame: CGRect(x: 10, y:  topPadding! + 5, width: 40, height: 60))
        let title = UIView(frame: CGRect(x: (lblWidth - lblWidth/2)/2, y: 0, width: lblWidth, height: 60))
        let rightView = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 50, y:  topPadding! + 5, width: 50, height: 60))
        rightView.layer.cornerRadius = 7.0
        rightView.layer.masksToBounds = true
        
        blurparentView.backgroundColor = Colors.txtBlack
        backImage.image = UIImage.init(named: "Backbtn")
        menuImage.image = UIImage.init(named: "BurgerMenu_icn")
        rightImg == "" ? (cartImage.image = nil) : (cartImage.image = UIImage(named:rightImg))
        
        
        let titlelabel = UILabel(frame: CGRect(x: 0, y: topPadding!, width: lblWidth, height: 60))
        titlelabel.font = Font.Regular.of(size: 20)
        titlelabel.text = txt_title
        titlelabel.textAlignment = .center
        titlelabel.textColor = .white
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let cartButton = UIButton(frame: CGRect(x: 0, y:  0, width: 50, height: 50))
//        backButton = self.createButton(btn: backButton)
        
        cartLabel.textAlignment = .center
        cartLabel.textColor = .black
        cartLabel.font = UIFont.boldSystemFont(ofSize: 8.0)
        cartLabel.backgroundColor = .white
        cartLabel.isHidden = isBadgeHidden
        bagdeVal == "" ? (cartLabel.text = "0") : (cartLabel.text = bagdeVal)
        
         cartButton.addTarget(self, action: #selector(rightBarItemClicked(_:)), for: .touchUpInside)
        
        if(showbtn == "back"){
            back.addSubview(backImage)
            back.addSubview(backButton)
            backButton.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        }else if(showbtn == "menu"){
            back.addSubview(menuImage)
            back.addSubview(backButton)
            backButton.addTarget(self, action: #selector(clickMenu), for: .touchUpInside)
        }else{
            
        }
        
        title.addSubview(titlelabel)
        
        rightView.addSubview(cartImage)
        rightView.addSubview(cartButton)
        cartImage.addSubview(cartLabel)
        
        parentView.addSubview(back)
        parentView.addSubview(title)
        parentView.addSubview(rightView)
        parentView.addSubview(blurparentView)
        
        blurparentView.isHidden = true
        
        view.addSubview(parentView)
    }
    
    
   @objc func clickBack(){

//        parentView.isHidden = false
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
   }
   
    @objc func clickMenu(){
//        parentView.isHidden = false
//        navigationController?.popViewController(animated: true)
        sideMenuController?.revealMenu()
    }
    
    @objc func clickHome(_ sender : UIButton){
//        parentView.isHidden = false
//        navigationController?.popViewController(animated: true)

    }
    
    @objc func rightBarItemClicked(_ sender : UIButton) {
        print("here...")
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = Font.Regular.of(size: _lblTextSize + 2)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

enum Device {
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11ProMax
    
    static let baseScreenSize: Device = .iPhoneSE
}


extension Device: RawRepresentable {
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iPhoneSE
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        default:
            return nil
        }
    }
    
    var rawValue: CGSize {
        switch self {
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        }
    }
    
}

extension String {

    public func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]

        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }
        return false
    }
    
    public func isPDF() -> Bool {
        // Add here your pdf formats.
        let pdfFormats = ["pdf"]

        if let ext = self.getExtension() {
            return pdfFormats.contains(ext)
        }
        return false
    }

    public func getExtension() -> String? {
       let ext = (self as NSString).pathExtension

       if ext.isEmpty {
           return nil
       }
       return ext
    }

    public func isURL() -> Bool {
       return URL(string: self) != nil
    }

}


extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

