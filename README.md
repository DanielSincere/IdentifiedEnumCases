# IdentifiedEnumCases Swift Macro

When an Swift enumeration has associated values, its cases can't be referenced as code. It would be so nice to reference the names of cases, even when an associated value isn't known.

This macro creates an `ID` enum, to refer to each case. In addition, it also creates a computed variable `id` so that the identifier of each case is easily available.

In my past projects, I've typed this up by manually each time. But now with Swift Macros, it's easy! The Swift enumeration just needs an annotation, and identifiers for each case will be created!

```swift
import IdentifiedEnumCases

@IdentifiedEnumCases
enum Nightshade {
  case potato(PotatoVariety), tomato(TomatoVariety)
  case eggplant(EggplantVariety)

  enum PotatoVariety: CaseIterable {
    case russet, yukonGold, kennebec
  }
  enum TomatoVariety: CaseIterable {
    case roma, heirloom, cherry
  }
  enum EggplantVariety: CaseIterable {
    case fairyTale
  }
}
```

then in code we can directly refer to the ID of the case.

```swift
let romaTomato = Nightshade.tomato(.roma)
XCTAssertEquals(romaTomato.id, .tomato)
```

because the macro generates to 

```swift
enum Nightshade {
  case potato(PotatoVariety), tomato(TomatoVariety)
  case chili(ChiliVariety)

  enum PotatoVariety: CaseIterable {
    case russet, yukonGold, kennebec
  }
  
  enum TomatoVariety: CaseIterable {
    case roma, heirloom, cherry
  }
  
  enum ChiliVariety: CaseIterable {
    case jalapeño, arbol, habenero
  }
  
  var id: ID {
    switch self {
    case .jalapeño: .jalapeño
    case .arbol: .arbol
    case .habenero: .habenero
    }
  }
  
  enum ID: String, Hashable, CaseIterable {
    case potato, tomato, jalapeño
  }
}
```

Very exciting!

## Public visibility

If the enum is `public`, the generated `ID` enum and the
generated `id` accessor will also be `public`. For example,

```swift
import IdentifiedEnumCases

@IdentifiedEnumCases
public enum AppRoute {
  case item(ItemRoute)
  case user(UserRoute)
}
```

generates to

```swift
public enum AppRoute {
  case item(ItemRoute)
  case user(UserRoute)

  public var id: ID {
    switch self {
    case .item: .item
    case .user: .user
  }

  public enum ID: String, Hashable, CaseIterable {
    case item
    case user
  }
}
```

## Installation

In `Package.swift`, add the package to your dependencies.
```
.package(url: "https://github.com/FullQueueDeveloper/IdentifiedEnumCases.git", from: "0.1.1"),
```

And add `"IdentifiedEnumCases"` to the list of your target's dependencies.

When prompted by Xcode, trust the macro.


## Swift macros?

Introduced at WWDC '23, requiring Swift 5.9

## License

[BSD-3-Clause](https://opensource.org/license/bsd-3-clause/)
