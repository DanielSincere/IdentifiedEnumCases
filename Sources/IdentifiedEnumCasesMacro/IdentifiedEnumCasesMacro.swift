import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct IdentifiedEnumCasesMacro: MemberMacro {
  public static func expansion<Declaration, Context>(
    of node: SwiftSyntax.AttributeSyntax,
    providingMembersOf declaration: Declaration,
    in context: Context) throws -> [SwiftSyntax.DeclSyntax] where Declaration : SwiftSyntax.DeclGroupSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {

      guard declaration.kind == .enumDecl else {
        throw Errors.mustBeAnEnum
      }

      guard let enumCases = declaration.memberBlock
        .children(viewMode: .fixedUp)
        .filter({ $0.kind == .memberDeclList })
        .first?
        .children(viewMode: .fixedUp)
        .filter({ $0.kind == SyntaxKind.memberDeclListItem })
        .flatMap({ $0.children(viewMode: .fixedUp).filter({ $0.kind == .enumCaseDecl })})
        .flatMap({ $0.children(viewMode: .fixedUp).filter({ $0.kind == .enumCaseElementList })})
        .flatMap({ $0.children(viewMode: .fixedUp).filter({ $0.kind == .enumCaseElement })})
      else {
        throw Errors.mustHaveCases
      }

      let caseIds: [String] = enumCases.compactMap { enumCase in
        guard let firstToken = enumCase.firstToken(viewMode: .fixedUp) else {
          return nil
        }
        if case let .identifier(id) = firstToken.tokenKind {
          //          return firstToken.tokenKind
          return id
        } else {
          return nil
        }
      }

      return [
        DeclSyntax(stringLiteral:
                   "enum ID: String, Equatable, CaseIterable {\n" +
                   caseIds.map { "  case \($0)\n" }.joined() +
                   "}"),
        DeclSyntax(stringLiteral: "var id: ID {\n  switch self {\n" +
                   caseIds.map { "  case .\($0): return .\($0)\n" }.joined() +
                   "  }\n}")
      ]
    }


  public enum Errors: Error, LocalizedError {
    case mustBeAnEnum
    case mustHaveCases

    public var errorDescription: String? {
      switch self {
      case .mustBeAnEnum:
        return "This attribute only works on `enum`"
      case .mustHaveCases:
        return "This enum must have `case` statements"
      }
    }
  }
}

@main
struct MacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    IdentifiedEnumCasesMacro.self,
  ]
}
