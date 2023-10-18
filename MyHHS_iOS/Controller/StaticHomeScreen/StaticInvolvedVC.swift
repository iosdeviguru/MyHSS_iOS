//
//  StaticInvolvedVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 28/06/2021.
//

import UIKit

class StaticInvolvedVC: UIViewController {

    var strHeader = ""
    @IBOutlet var strTitile: UILabel!
    @IBOutlet var strDetails: UILabel!
    
    @IBOutlet var viewAmrutVachan: UIView!
    @IBOutlet var viewSubhashitas: UIView!
    @IBOutlet var viewAboutUS: UIView!
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    var imgArr = [UIImage(named:"samiti_banner1")]
    var imgArrSamiti = [  UIImage(named:"samiti_banner1"),
                    UIImage(named:"samiti_banner2") ,
                    UIImage(named:"samiti_banner3") ]
    var imgArrBalagokulam = [ UIImage(named:"balagokulam_banner1") ,
                    UIImage(named:"balagokulam_banner2") ,
                    UIImage(named:"balagokulam_banner3") ]
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if strHeader == "hindu_sevika_samiti".localized {
            imgArr = imgArrSamiti
        } else if strHeader == "balgoculam".localized  {
            imgArr = imgArrBalagokulam
        }
        
        navigationBarDesign(txt_title: strHeader.localized, showbtn: "back")
     
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.viewAmrutVachan.isHidden = true
        self.viewSubhashitas.isHidden = true
        self.viewAboutUS.isHidden = true
        if strHeader == "hindu_sevika_samiti".localized {
            self.strTitile.text = "hindu_sevika_samiti_title".localized
            self.strDetails.text = "hindu_sevika_samiti_description".localized
        } else if strHeader == "balgoculam".localized  {
            self.strTitile.text = "balgoculam_title".localized
            self.strDetails.text = "balgoculam_description".localized
        } else if strHeader == "AMRUT_VACHAN_title".localized  {
            self.viewAmrutVachan.isHidden = false
            self.viewSubhashitas.isHidden = true
            self.viewAboutUS.isHidden = true
        } else if strHeader == "SUBHASHITAS_title".localized  {
            self.viewAmrutVachan.isHidden = true
            self.viewSubhashitas.isHidden = false
            self.viewAboutUS.isHidden = true
        } else if strHeader == "ABOUT_HSS_title".localized {
            self.viewAmrutVachan.isHidden = true
            self.viewSubhashitas.isHidden = true
            self.viewAboutUS.isHidden = false
        }
    }

    @objc func changeImage() {
     
     if counter < imgArr.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         pageView.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         pageView.currentPage = counter
         counter = 1
     }
         
     }

}

extension StaticInvolvedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        }
        return cell
    }
}

extension StaticInvolvedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
//        return CGSize(width: size.width / 2, height: size.width)
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
