import Foundation

extension AppRoute {

  func url(with root: URL) -> URL {
    URL(string: self.urlComponents.joined(separator: "/"), relativeTo: root)!.absoluteURL
  }

  var urlComponents: [String] {
    switch self {
    case .item(let itemRoute):
      [self.caseID.rawValue] + itemRoute.urlComponents
    case .home, .about, .shop:
      [self.caseID.rawValue]
    }
  }
}

extension ItemRoute {

  var urlComponents: [String] {
    switch self {
    case .filter(let filter):
      switch filter {
      case .all:
        [self.caseID.rawValue, filter.caseID.rawValue]
      case .substring(let string):
        [self.caseID.rawValue, filter.caseID.rawValue, string.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!]
      }
    case .new:
      [self.caseID.rawValue]
    case .view(let itemId):
      [self.caseID.rawValue, itemId.id.uuidString]
    }
  }
}
