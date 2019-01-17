//
//  ObservableContext.swift
//
//

protocol AnyContextChange: Equatable {
  init()
}

protocol AnyObservableContext {
  associatedtype Change: AnyContextChange
  func addHandler(for change: Change, _ completion: @escaping CompletionHandler) -> Int
  func addHandler(_ completion: @escaping CompletionChangeHandler<Change>) -> Int
  func removeHandler(_ handlerId: Int)
}

class ObservableContext<ContextChange: AnyContextChange>: AnyObservableContext {
  typealias Change = ContextChange
  // MARK: - Properties
  fileprivate var observingHandlers: [Int: CompletionChangeHandler<Change>] = [:]
  fileprivate var change = Change() {
    didSet {
      notifyHandlers()
    }
  }
  // MARK: - Init
  deinit {
    observingHandlers.removeAll()
  }
  // MARK: - Public
  /// Add handler for observing changes,
  /// you should remove handler, when stop observing
  /// - Parameter completion: hanler's completion block, which is called each time when changes happened
  /// - Returns: id for current handler
  func addHandler(_ completion: @escaping CompletionChangeHandler<Change>) -> Int {
    var maxId = observingHandlers.keys.max() ?? 0
    maxId += 1
    observingHandlers[maxId] = completion
    return maxId
  }
  func addHandler(for change: Change, _ completion: @escaping CompletionHandler) -> Int {
    return addHandler({ (currentChange) in
      if currentChange == change {
        completion()
      }
    })
  }
  func removeHandler(_ handlerId: Int) {
    observingHandlers.removeValue(forKey: handlerId)
  }
  func notifyHandlers(about change: Change) {
    self.change = change
  }
  private func notifyHandlers() {
    observingHandlers.forEach { (handler) in
      handler.value(change)
    }
  }
}
