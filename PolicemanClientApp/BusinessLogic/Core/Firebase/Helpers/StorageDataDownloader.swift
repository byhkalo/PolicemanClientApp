//
//  StorageDataDownloader.swift
//
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class StorageDataDownloader {
  func downloadImage(imageUrl: String, completionHandler: @escaping CompletionResponseHandler<UIImage>) {
    // Create a reference to the file you want to download
    let imageRef = Storage.storage().reference(forURL: imageUrl)
    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
      var image: UIImage?
      if let data = data {
        image = UIImage(data: data)
      }
      completionHandler(image, error)
    }
  }
  func downloadVideo(videoUrl: String, completionHandler: @escaping CompletionResponseHandler<URL>) {
    let videoRef = Storage.storage().reference(forURL: videoUrl)
    videoRef.getData(maxSize: INT64_MAX) { (videoData, error) in
      guard let videoData = videoData,
        var fileName = videoUrl.components(separatedBy: "=").last
        else { completionHandler(nil, error); return }
      fileName += ".mp4"
      let filePathUrl = self.documentsPathForFileName(fileName)
      do {
        try videoData.write(to: filePathUrl)
        completionHandler(filePathUrl, error)
      } catch {
        completionHandler(nil, error)
      }
    }
  }
  func documentsPathForFileName(_ name: String) -> URL {
    if var appDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
      appDirectory.appendPathComponent(name)
      return appDirectory.absoluteURL
    } else {
      return URL(fileURLWithPath: "")
    }
  }

}
