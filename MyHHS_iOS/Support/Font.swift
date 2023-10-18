//
//  Font.swift
//  TowJamDriver
//
//  Created by jagdish on 31/01/20.
//  Copyright © 2020 Jagdish Mer. All rights reserved.
//

import Foundation
import UIKit

enum Font: String {
    case Regular    = "SourceSansPro-Regular"
    case Midium     = "SourceSansPro-SemiBold"
    case Bold       = "SourceSansPro-Bold"
    case Light      = "Roboto-Light"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
