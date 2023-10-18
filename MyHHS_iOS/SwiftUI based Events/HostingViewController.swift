//
//  HostingViewController.swift
//  MyHHS_iOS
//
//  Created by Patel on 17/04/2023.
// Using Hosting View controller for using SwiftUI in storyboard based project

import Foundation
import SwiftUI
// This code defines a custom UIViewController named HostingViewController that is used to host a SwiftUI view inside a UIKit app.
import UIKit

@available(iOS 13.0, *)
class HostingViewController: UIViewController {

  public let contentViewinHC = UIHostingController(rootView: MainView())

  var strNavigation = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarWithRightButtonDesign(
      txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: true)
    setupHC()
    setupConstraints()
  }

  public func setupConstraints() {
    contentViewinHC.view.translatesAutoresizingMaskIntoConstraints = false

    // This uses the view's safe area layout guide to constrain the UIHostingController's view to the edges of the screen.
    let guide = view.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
      contentViewinHC.view.topAnchor.constraint(
        equalTo: guide.topAnchor, constant: topPadding! + 30),
      contentViewinHC.view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
      contentViewinHC.view.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      contentViewinHC.view.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
    ])
  }

  public func setupHC() {
    addChild(contentViewinHC)
    view.addSubview(contentViewinHC.view)
    contentViewinHC.didMove(toParent: self)
  }

  //    @objc func backButtonAction() {
  //          self.dismiss(animated: true, completion: nil)
  //      }

}
