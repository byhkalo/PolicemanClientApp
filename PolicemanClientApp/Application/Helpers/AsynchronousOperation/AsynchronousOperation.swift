//
//  AsynchronousOperation.swift
//
//

import Foundation

/// An abstract class that makes building simple asynchronous operations easy.
/// Subclasses must implement `execute()` to perform any work and call
/// `finish()` when they are done. All `NSOperation` work will be handled
/// automatically.
open class AsynchronousOperation: Operation {
  // MARK: - Properties
  private let stateQueue = DispatchQueue(
    label: "com.queue.operation.state",
    attributes: .concurrent)
  private var rawState = OperationState.ready
  @objc private dynamic var state: OperationState {
    get {
      return stateQueue.sync(execute: { rawState })
    }
    set {
      willChangeValue(forKey: "state")
      stateQueue.sync(
        flags: .barrier,
        execute: { rawState = newValue })
      didChangeValue(forKey: "state")
    }
  }
  // MARK: - States
  public final override var isReady: Bool {
    return state == .ready && super.isReady
  }
  public final override var isExecuting: Bool {
    return state == .executing
  }
  public final override var isFinished: Bool {
    return state == .finished
  }
  public final override var isAsynchronous: Bool {
    return true
  }
  @objc fileprivate(set) var isFailed: Bool = false
  // MARK: - NSObject
  @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
    return ["state"]
  }
  @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
    return ["state"]
  }
  @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
    return ["state"]
  }
  @objc private dynamic class func keyPathsForValuesAffectingIsFailed() -> Set<String> {
    return ["state"]
  }
  // MARK: - Foundation.Operation
  public override final func start() {
    super.start()
    if isCancelled {
      finish()
      return
    }
    state = .executing
    execute()
  }
  // MARK: - Public
  /// Subclasses must implement this to perform their work and they must not
  /// call `super`. The default implementation of this function throws an
  /// exception.
  @objc open func execute() {
    fatalError("Subclasses must implement `execute`.")
  }
  /// Call this function after any work is done or after a call to `cancel()`
  /// to move the operation into a completed state.
  @objc public final func finish(withFail failed: Bool = false) {
    isFailed = failed
    state = .finished
  }
}
// MARK: - State
@objc private enum OperationState: Int {
  case ready
  case executing
  case finished
}
