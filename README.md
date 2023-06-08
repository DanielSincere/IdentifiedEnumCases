# IdentifiedEnumCases

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
