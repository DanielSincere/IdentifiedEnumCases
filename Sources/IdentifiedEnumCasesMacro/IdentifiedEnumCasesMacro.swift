import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

public struct IdentifiedEnumCasesMacro: MemberMacro {
  public static func expansion<Declaration, Context>(
    of node: SwiftSyntax.AttributeSyntax,
    providingMembersOf declaration: Declaration,
    in context: Context) throws -> [SwiftSyntax.DeclSyntax] where Declaration : SwiftSyntax.DeclGroupSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {
      
      
      
      guard let declaration = declaration.as(EnumDeclSyntax.self) else {
        let enumError = Diagnostic(node: node._syntaxNode, message: Diagnostics.mustBeEnum)
        context.diagnose(enumError)
        return []
      }
      
      
      print("-------------------")
      let keywords: [Keyword] = {
        if let modifiers = declaration.modifiers {
          return modifiers.children(viewMode: .fixedUp).flatMap { syntax in
            return syntax.as(DeclModifierSyntax.self)?.children(viewMode: .fixedUp).compactMap({ syntax in
              switch syntax.as(TokenSyntax.self)?.tokenKind {
              case .keyword(.public):
                return Keyword.public
                
              default:
                return nil
              }
            }) ?? []
          }
        } else {
          return []
        }
      }()
      print("```````")
      print(keywords)
      print("```````")
//      let keywords: [Keyword] = declaration.modifiers?.children(viewMode: .fixedUp).map({ syntax in
//        syntax.as(DeclModifierSyntax.self)?.children(viewMode: .fixedUp).compactMmap({ syntax in
//          switch syntax.as(TokenSyntax.self)?.tokenKind {
//          case .keyword(.public):
//            return Keyword.public
//            
//          default:
//            return nil
//          }
//                 
//        })
//      })


      print(declaration.identifier)

      guard let enumCases: [SyntaxProtocol] = declaration.memberBlock
        .children(viewMode: .fixedUp)
        .filter({ $0.kind == .memberDeclList })
        .first?
        .children(viewMode: .fixedUp)
        .filter({ $0.kind == SyntaxKind.memberDeclListItem })
        .flatMap({ $0.children(viewMode: .fixedUp).filter({ $0.kind == .enumCaseDecl })})
        .flatMap({ $0.children(viewMode: .fixedUp).filter({ $0.kind == .enumCaseElementList })})
        .flatMap({ $0.children(viewMode: .fixedUp).filter({ $0.kind == .enumCaseElement })})
      else {
        
        let enumError = Diagnostic(node: node._syntaxNode, message: Diagnostics.mustHaveCases)
        context.diagnose(enumError)
        return []
      }

      let caseIds: [String] = enumCases.compactMap { enumCase in
        guard let firstToken = enumCase.firstToken(viewMode: .fixedUp) else {
          return nil
        }

        guard case let .identifier(id) = firstToken.tokenKind else {
          return nil
        }

        return id
      }
      
      guard !caseIds.isEmpty else {
        let enumError = Diagnostic(node: node._syntaxNode, message: Diagnostics.mustHaveCases)
        context.diagnose(enumError)
        return []
      }
      
      let enumID = "enum ID: String, Equatable, CaseIterable {\n\(caseIds.map { "  case \($0)\n" }.joined())}"
      let idAccessor = "var id: ID {\n  switch self {\n\(caseIds.map { "  case .\($0): .\($0)\n" }.joined())  }\n}"
      
      
      let isPublic = if let modifiers = declaration.modifiers, !modifiers.children(viewMode: .fixedUp).filter({ syntax in
        syntax.tokens(viewMode: .fixedUp).contains(TokenSyntax.keyword(.public)) }).isEmpty {
        true
      } else {
        false
      }
      
      
      return if isPublic {
        [
          DeclSyntax(stringLiteral: "public \(enumID)"),
          DeclSyntax(stringLiteral: "public \(idAccessor)")
        ]
      } else {
        [
          DeclSyntax(stringLiteral: enumID),
          DeclSyntax(stringLiteral: idAccessor)
        ]
      }
    }
  
  public enum Diagnostics: String, DiagnosticMessage {
    
    case mustBeEnum, mustHaveCases
    
    public var message: String {
      switch self {
      case .mustBeEnum:
        return "`@IdentifiedEnumCasesMacro` can only be applied to an `enum`"
      case .mustHaveCases:
        return "`@IdentifiedEnumCasesMacro` can only be applied to an `enum` with `case` statements"
      }
    }
    
    public var diagnosticID: MessageID {
      MessageID(domain: "IdentifiedEnumCasesMacro", id: rawValue)
    }
    
    public var severity: DiagnosticSeverity { .error }
  }
}

@main
struct MacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    IdentifiedEnumCasesMacro.self,
  ]
}
