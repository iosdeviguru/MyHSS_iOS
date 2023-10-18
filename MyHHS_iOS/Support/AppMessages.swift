//
//  AppMessages.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//


// MARK: Web Operation

struct Messages {
    
    struct API {
        static let noInternet           = "No internet connection available"
        static let timeOut              = "The request timed out"
        static let wrongCredential      = "Wrong Credentials"
        static let somethingWenWrong    = "Something went wrong. Please try again after some time."
    }
    
    struct Permission {
        static let cameraAccessDenied     = "You’ve denied access to your camera. You can allow access by going to your phone’s settings. Settings > Notifi App."
        static let photoAccessDenied      = "You’ve denied access to your photos. You can allow access by going to your phone’s settings. Settings > Notifi App."
        static let photoLibraryNotAvailable   = "Photos library not Available"
        static let cameraNotAvailable         = "Camera not Available"
    }
}
