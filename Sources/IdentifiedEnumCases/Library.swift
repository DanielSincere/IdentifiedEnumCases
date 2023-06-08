/// A macro that creates named cases for an enum. Helpful
/// when the enum has an associated value.
/// For example,
///
///     @IdentifiedEnumCases
///     enum AppRoute {
///       case item(ItemRoute)
///       case user(UserRoute)
///     }
///
@attached(member, names: named(ID), named(id))
public macro IdentifiedEnumCases() -> () = #externalMacro(module: "IdentifiedEnumCasesMacro", type: "IdentifiedEnumCasesMacro")
