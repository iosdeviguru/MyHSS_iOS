//
//  NewHostingViewController.swift
//  MyHHS_iOS
//
//  Created by Patel on 01/05/2023.
//
import Foundation
import SwiftUI
import UIKit

//

@available(iOS 13.0, *)
struct NewHostingView: UIViewControllerRepresentable {
  typealias UIViewControllerType = NewHostingViewController
  let strNavigation = ""

  func makeUIViewController(context: Context) -> NewHostingViewController {
    let viewController = NewHostingViewController()
    viewController.strNavigation = "Events"

    viewController.contentViewinHC.rootView = MainView()
    return viewController
  }

  func updateUIViewController(_ uiViewController: NewHostingViewController, context: Context) {
    // Do nothing
  }
}

@available(iOS 13.0, *)
class NewHostingViewController: HostingViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    //        navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: true)
    //        setupHC()
    //        setupConstraints()
    // Add any additional setup code here
  }
}
