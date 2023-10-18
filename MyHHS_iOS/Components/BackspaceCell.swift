//
//  BackspaceCell.swift
//  MyHHS_iOS
//
//  Created by IOS-Dev iGuru on 09/08/23.
//

import Foundation
import UIKit

class BackspaceCell: UICollectionViewCell {

    let imageView = UIImageView(image: #imageLiteral(resourceName: "back_arrow"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 40, height: 40))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
