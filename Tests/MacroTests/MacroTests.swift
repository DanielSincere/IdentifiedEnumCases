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

              enum PotatoVariety {}
              enum TomatoVariety {}
              enum EggplantVariety {}
            
              enum CaseID: String, Hashable, CaseIterable, CustomStringConvertible {
                case potato
                case tomato
                case eggplant

                var description: String {
                  self.rawValue
                }
              }
            
              var caseID: CaseID {
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
            macros: testMacros,
            indentationWidth: .spaces(2)
    )
  }
  
  func testPublicMacro() {
    assertMacroExpansion(
          """
          @IdentifiedEnumCases
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
          
            public enum PotatoVariety {}
            public enum TomatoVariety {}
            public enum EggplantVariety {}
          
            public enum CaseID: String, Hashable, CaseIterable, CustomStringConvertible {
              case potato
              case tomato
              case eggplant

              public var description: String {
                self.rawValue
              }
            }
          
            public var caseID: CaseID {
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
          macros: testMacros,
          indentationWidth: .spaces(2)
    )
  }
    
  func testMustBeEnumDiagnostic() {
    assertMacroExpansion("@IdentifiedEnumCases struct Tomato {}",
                         expandedSource: "struct Tomato {}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`", line: 1, column: 1)],
                         macros: testMacros)
    
    assertMacroExpansion("@IdentifiedEnumCases class Tomato {}",
                         expandedSource: "class Tomato {}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`", line: 1, column: 1)],
                         macros: testMacros)
    
    assertMacroExpansion("@IdentifiedEnumCases protocol Tomato {}",
                         expandedSource: "protocol Tomato {}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`", line: 1, column: 1)],
                         macros: testMacros)

  }
  
  func testEnumMustHaveCasesDiagnostic() {
    assertMacroExpansion("@IdentifiedEnumCases enum Tomato {}",
                         expandedSource: "enum Tomato {}",
                         diagnostics: [DiagnosticSpec(message: "`@IdentifiedEnumCasesMacro` can only be applied to an `enum` with `case` statements", line: 1, column: 1)],
                         macros: testMacros)
  }
}
