import XCTest
import IdentifiedEnumCasesMacro
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import SwiftDiagnostics

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
                  .potato
                case .tomato:
                  .tomato
                case .eggplant:
                  .eggplant
                }
              }
            }
            """,
            macros: testMacros
    )
  }
    
  func testPublicMacro() {
    assertMacroExpansion(
          """
          @IdentifiedEnumCases(.public)
          public enum Nightshade {
            case potato(PotatoVariety), tomato(TomatoVariety)
            case eggplant(EggplantVariety)
          
            public enum PotatoVariety {}
            public enum TomatoVariety {}
            public enum EggplantVariety {}
          }
          """,
          expandedSource:
          """
          
          public enum Nightshade {
            case potato(PotatoVariety), tomato(TomatoVariety)
            case eggplant(EggplantVariety)
          
            public enum PotatoVariety {
            }
            public enum TomatoVariety {
            }
            public enum EggplantVariety {
            }
            public enum ID: String, Equatable, CaseIterable {
              case potato
              case tomato
              case eggplant
            }
            public var id: ID {
              switch self {
              case .potato:
                .potato
              case .tomato:
                .tomato
              case .eggplant:
                .eggplant
              }
            }
          }
          """,
          macros: testMacros
    )
  }
  
  func testMustBeEnumDiagnostic() {
    assertMacroExpansion("@IdentifiedEnumCases struct Tomato {}",
                         expandedSource: "struct Tomato {\n}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`", line: 1, column: 1)],
                         macros: testMacros)
    
    assertMacroExpansion("@IdentifiedEnumCases class Tomato {}",
                         expandedSource: "class Tomato {\n}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`", line: 1, column: 1)],
                         macros: testMacros)
    
    assertMacroExpansion("@IdentifiedEnumCases protocol Tomato {}",
                         expandedSource: "protocol Tomato {\n}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`", line: 1, column: 1)],
                         macros: testMacros)

  }
  
  func testEnumMustHaveCasesDiagnostic() {
    assertMacroExpansion("@IdentifiedEnumCases enum Tomato {}",
                         expandedSource: "enum Tomato {\n}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum` with `case` statements", line: 1, column: 1)],
                         macros: testMacros)
  }
}
