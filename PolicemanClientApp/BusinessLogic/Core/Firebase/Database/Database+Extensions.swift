//
//  Database+Extensions.swift
//
//

import FirebaseDatabase

// MARK: - DataSnapshot
extension DataSnapshot {
  var uniqueValue: [String: Any]? {
    guard var tempValue = value as? [String: Any]
      else { return nil }
    tempValue["identifier"] = key
    return tempValue
  }
  var uniqueEncoded: Data? {
    guard let value = uniqueValue,
      let dataFrom = try? JSONSerialization.data(withJSONObject: value, options: []),
      let stringData = String(data: dataFrom, encoding: .utf8)
      else { return nil }
    return stringData.data(using: .utf8)
  }
  func toObjectDataModel<DataModel: AnyDatabaseModel>() -> DataModel? {
    guard let data = self.uniqueEncoded else { return nil }
    let model = try? JSONDecoder().decode(DataModel.self, from: data)
    return model
  }
}
