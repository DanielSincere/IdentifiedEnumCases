import Foundation

let production: URL = URL(string: "https://www.example.com")!
let staging: URL = URL(string: "https://staging-www.example.com")!

let shopRoute = AppRoute.shop
print(shopRoute.url(with: production))

let houseplantItem = Item(id: Item.ID(), name: "Houseplant")
let houseplantRoute = AppRoute.item(.view(houseplantItem.id))
print(houseplantRoute.url(with: production))

let plantFilterRoute = AppRoute.item(.filter(.substring("plant")))
print(plantFilterRoute.url(with: staging))

