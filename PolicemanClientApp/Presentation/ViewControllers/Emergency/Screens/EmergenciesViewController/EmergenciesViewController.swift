//
//  EmergenciesViewController.swift
//  PolicemanClientApp
//
//  Created by Konstantyn on 1/14/19.
//  Copyright © 2019 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

class EmergenciesViewController: UIViewController {
  // MARK: - @IBOutlet
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.cellActionsDelegate = self
    }
  }
  // MARK: - Properties
  var viewModel: AnyEmergenciesViewModel! {
    didSet {
      guard oldValue !== self.viewModel else { return }
      if let oldValue = oldValue { unsubscribe(anyViewModel: oldValue) }
      if self.viewModel != nil { subscribe() }
    }
  }
  var displayCollection: EmergenciesDisplayCollection!
  // MARK: - ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    configureNavigationTitle()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
}
// MARK: - Private Configuration
fileprivate extension EmergenciesViewController {
  func configureTableView() {
    displayCollection.setup(on: tableView)
    tableView.dataSource = self
    tableView.delegate = self
  }
  func configureNavigationTitle() {
    self.navigationItem.title = viewModel.navigationTitle
  }
}
// MARK: - UITableViewDataSource
extension EmergenciesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayCollection.numberOfRows(in: section)
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = displayCollection.model(for: indexPath)
    return tableView.dequeueReusableCell(for: indexPath, with: model)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return displayCollection.heightForRow(at: indexPath)
  }
}
// MARK: - UITableViewDelegate
extension EmergenciesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    viewModel.selectEmergency(at: indexPath)
  }
}
// MARK: - Private Subscribe
fileprivate extension EmergenciesViewController {
  func unsubscribe(anyViewModel: AnyEmergenciesViewModel) {
    anyViewModel.emergenciesUpdateHandler = nil
  }
  func subscribe() {
    viewModel.emergenciesUpdateHandler = { [weak self] change in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch change {
        case .emergenciesUpdated: self.tableView.reloadData()
        case .policemanUpdated: break
        case .node: break
        }
      }
    }
  }
}
extension EmergenciesViewController: TableViewActionsDelegate {
  func tableView(_ tableView: UITableView, didAction action: AnyUserAction, onCellAt indexPath: IndexPath) {
    guard let tableCellAction = action as? EmergencyTableCellAction
      else { return }
    switch tableCellAction {
    case .getAction: break
    }
  }
}
