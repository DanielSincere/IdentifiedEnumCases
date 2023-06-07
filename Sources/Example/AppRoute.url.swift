import Foundation

extension AppRoute {
  
  func url(with root: URL) -> URL {
    URL(string: self.urlComponents.joined(separator: "/"), relativeTo: root)!.absoluteURL
  }
  
  var urlComponents: [String] {
    switch self {
    case .item(let itemRoute):
      [self.id.rawValue] + itemRoute.urlComponents
    case .home, .about, .shop:
      [self.id.rawValue]
    }
  }
}

extension ItemRoute {
  
  var urlComponents: [String] {
    switch self {
    case .filter(let filter):
      switch filter {
      case .all:
        [self.id.rawValue, filter.id.rawValue]
      case .substring(let string):
        [self.id.rawValue, filter.id.rawValue, string.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!]
      }
    case .new:
      [self.id.rawValue]
    case .view(let itemId):
      [self.id.rawValue, itemId.id.uuidString]
    }
  }
}
