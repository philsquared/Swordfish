// Swordfish for Playgrounds
// By Phil Nash
//
// Drop this file into the Sources folder of a playground and start using it
//
// The repository is hosted at: https://github.com/philsquared/Swordfish
// This project is licensed under the BSD 2-Clause License
// See the associated LICENSE file in the root of this repository

public enum AssertionResult<T> : Error, CustomStringConvertible {
    case Pass
    case ShouldBeEqual(T,T)
    case ShouldDiffer(T,T)
    
    public var description: String {
        switch self {
        case .Pass: return "👍 ok"
        case .ShouldBeEqual(let l, let r ): return "❌ expected: \(l) == \(r)"
        case .ShouldDiffer(let l, let r ): return "❌ expected: \(l) != \(r)"
        }
    }
}

public struct ExprLhs<T : Equatable> {
    let lhs : T
    
    public static func ==( lhsExpr : ExprLhs, rhs: T) -> AssertionResult<T> {
        
        if lhsExpr.lhs == rhs {
            return AssertionResult.Pass
        }
        else {
            return AssertionResult.ShouldBeEqual(lhsExpr.lhs, rhs)
        }
    }
    public static func !=( lhsExpr : ExprLhs, rhs: T) -> AssertionResult<T> {
        
        if lhsExpr.lhs != rhs {
            return AssertionResult.Pass
        }
        else {
            return AssertionResult.ShouldDiffer(lhsExpr.lhs, rhs)
        }
    }
}

public class Assertion {
    public static func | <T>(assertion: Assertion, lhs: T) -> ExprLhs<T> {
        return ExprLhs(lhs: lhs )
    }
}

public func require( _ msg : String = String() ) -> Assertion {
    // Ignore msg for now
    return Assertion()
}
