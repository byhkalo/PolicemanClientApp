//
//  StorageDataLoader.swift
//
//

import FirebaseStorage
import FirebaseDatabase

final class StorageDataUploader {
  // MARK: - Properties
  static var currentUploadTasks: [String: StorageUploadTask] { return uploadTasks }
  fileprivate static var uploadTasks = [String: StorageUploadTask]()
  // MARK: - Public
  //swiftlint:disable:next line_length
  func uploadImage(data: Data, with metadata: StorageMetadata? = nil, to reference: StorageReference, uploadingProgress: CompletionChangeHandler<Progress>? = nil, completion: @escaping CompletionResponseHandler<URL>) {
    /// Create metadata
    let resultMetadata = metadata ?? StorageMetadata()
    resultMetadata.contentType = "image/jpeg"
    /// Add task detection metadata
    var resultTaskMetadata = ["fullPath": reference.fullPath]
    if let customMetadata = resultMetadata.customMetadata {
      customMetadata.forEach({ (object) in
        resultTaskMetadata[object.key] = object.value
      })
    }
    resultMetadata.customMetadata = resultTaskMetadata
    let uploadTask = reference.putData(data, metadata: resultMetadata) { (responseMetadata, error) in
      /// Remove task
      if let fullPath = responseMetadata?.customMetadata?["fullPath"] {
        StorageDataUploader.uploadTasks.removeValue(forKey: fullPath)
      }
      reference.downloadURL(completion: { (downloadURL, error) in
        completion(downloadURL, error)
      })
    }
    uploadTask.observe(.progress) { (snapshot) in
      guard let progress = snapshot.progress else { return }
      uploadingProgress?(progress)
    }
    StorageDataUploader.uploadTasks[reference.fullPath] = uploadTask
  }
  //swiftlint:disable:next line_length
  func uploadMovie(url: URL, with metadata: StorageMetadata? = nil, to reference: StorageReference, uploadingProgress: CompletionChangeHandler<Progress>? = nil, completion: @escaping CompletionResponseHandler<URL>) {
    /// Create metadata
    let resultMetadata = metadata ?? StorageMetadata()
    resultMetadata.contentType = "video/quicktime"
    /// Add task detection metadata
    var resultTaskMetadata = ["fullPath": reference.fullPath]
    if let customMetadata = resultMetadata.customMetadata {
      customMetadata.forEach({ (object) in
        resultTaskMetadata[object.key] = object.value
      })
    }
    resultMetadata.customMetadata = resultTaskMetadata
    /// Observe uploading progress
    let uploadTask = reference.putFile(from: url, metadata: resultMetadata) { (responseMetadata, error) in
      /// Remove task
      if let fullPath = responseMetadata?.customMetadata?["fullPath"] {
        StorageDataUploader.uploadTasks.removeValue(forKey: fullPath)
      }
      reference.downloadURL(completion: { (downloadURL, error) in
        completion(downloadURL, error)
      })
    }
    uploadTask.observe(.progress) { (snapshot) in
      guard let progress = snapshot.progress else { return }
      uploadingProgress?(progress)
    }
    StorageDataUploader.uploadTasks[reference.fullPath] = uploadTask
  }
  func dowload(from reference: StorageReference, completion: @escaping CompletionResponseHandler<Data>) {
    let maxSize: Int64 = 3 * 1024 * 1024 // 3MB
    reference.getData(maxSize: maxSize, completion: completion)
  }
}
