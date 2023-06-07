import XCTest
import IdentifiedEnumCasesMacro
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

let testMacros: [String: Macro.Type] = [
  "IdentifiedEnumCases": IdentifiedEnumCasesMacro.self,
]

final class MacroTests: XCTestCase {
  func testMacro() {
    assertMacroExpansion(
            """
            @IdentifiedEnumCases
            enum Nightshade {
              case potato(PotatoVariety), tomato(TomatoVariety)
              case eggplant(EggplantVariety)

              enum PotatoVariety {}
              enum TomatoVariety {}
              enum EggplantVariety {}
            }
            """,
            expandedSource:
            """

            enum Nightshade {
              case potato(PotatoVariety), tomato(TomatoVariety)
              case eggplant(EggplantVariety)

              enum PotatoVariety {
              }
              enum TomatoVariety {
              }
              enum EggplantVariety {
              }
              enum ID: String, Equatable, CaseIterable {
                case potato
                case tomato
                case eggplant
              }
              var id: ID {
                switch self {
                case .potato:
                  return .potato
                case .tomato:
                  return .tomato
                case .eggplant:
                  return .eggplant
                }
              }
            }
            """,
            macros: testMacros
    )
  }
}
