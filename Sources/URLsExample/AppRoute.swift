import Foundation
import IdentifiedEnumCases

@IdentifiedEnumCases
enum AppRoute {
  case item(ItemRoute)
  case home
  case about
  case shop
}

@IdentifiedEnumCases
enum ItemRoute {
  case new
  case view(Item.ID)
  case filter(ItemFilter)
}

struct Item: Equatable, Identifiable {
  let id: ID
  let name: String

  struct ID: Hashable, Equatable, Identifiable {
    let id: UUID = .init()
  }
}

@IdentifiedEnumCases
enum ItemFilter {
  case all
  case substring(String)
}
