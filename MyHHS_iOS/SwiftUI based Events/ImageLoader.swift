//
//  ImageLoader.swift
//  MyHHS_iOS
//
//  Created by Patel on 25/04/2023.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct AsyncImage: View {
  @StateObject private var imageLoader: ImageLoader

  init(urlString: String) {
    if #available(iOS 14.0, *) {
      _imageLoader = StateObject(wrappedValue: ImageLoader(urlString: urlString))
    } else {
      _imageLoader = StateObject(wrappedValue: ImageLoader(urlString: ""))
    }
  }

  var body: some View {
    Group {
      if let image = imageLoader.image {
        Image(uiImage: image)
          .resizable()
      } else {
        if #available(iOS 14.0, *) {
          ProgressView()
        } else {
          // Fallback on earlier versions
        }
      }
    }
  }
}

@available(iOS 13.0, *)
class ImageLoader: ObservableObject {
  @Published var image: UIImage?
  private let urlString: String

  init(urlString: String) {
    self.urlString = urlString
    loadImage()
  }

  private func loadImage() {
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data else { return }
      DispatchQueue.main.async {
        self.image = UIImage(data: data)
      }
    }.resume()
  }
}
