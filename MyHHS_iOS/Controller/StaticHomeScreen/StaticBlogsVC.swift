//
//  StaticBlogsVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 30/06/2021.
//

import UIKit

class StaticBlogsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imgArr = [  UIImage(named:"blog-1"),
                    UIImage(named:"blog-2") ,
                    UIImage(named:"blog-3") ,
                    UIImage(named:"blog-4") ,
                    UIImage(named:"blog-5") ,
                    UIImage(named:"blog-6") ]
    
    var titleArr = [  "Interactive Platforms",
                    "Timeless Values, Evolving Challenges, Dynamic Karyakartas" ,
                    "Sanskaar, Sewa, Sangathan" ,
                    "Sanskriti MahaShibir: Testimonial" ,
                    "HSS Testimonial" ,
                    "This is only the Beginning" ]
    
    var linksArr = ["https://hssuk.org/interactive-platforms/", "https://hssuk.org/sanskaar-sewa-sangathan/", "https://hssuk.org/sanskriti-mahashibir-testimonial/", "https://hssuk.org/this-is-only-the-beginning/", "https://hssuk.org/50-years-of-hss-uk-some-thoughts/",  "https://hssuk.org/celebration-of-guru-pooja-teachers-day-at-reading-balgokulum/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "HSS_Blog_title".localized, showbtn: "back")
    }


}

extension StaticBlogsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        }
        if let vc = cell.viewWithTag(222) as? UILabel {
            vc.text = titleArr[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = URL(string: linksArr[indexPath.row]) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension StaticBlogsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 2, height: size.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
