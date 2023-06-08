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

let romaTomato = Nightshade.tomato(.roma)
print("ID equality:", romaTomato.id == Nightshade.ID.tomato)

