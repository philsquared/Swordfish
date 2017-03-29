// Swordfish for Playgrounds
// By Phil Nash
//
// Drop this file into the Sources folder of a playground and start using it
//
// The repository is hosted at: https://github.com/philsquared/Swordfish
// This project is licensed under the BSD 2-Clause License
// See the associated LICENSE file in the root of this repository

public enum ExpressionType : CustomStringConvertible {
    case Unary
    case IsEqual
    case IsNotEqual
    case IsLessThan
    case IsGreaterThan
    case IsLessThanOrEqual
    case IsGreaterThanOrEqual
    
    public var description: String {
        switch self {
        case .Unary: return "" // !TBD?
        case .IsEqual: return "=="
        case .IsNotEqual: return "!="
        case .IsLessThan: return "<"
        case .IsGreaterThan: return ">"
        case .IsLessThanOrEqual: return "<="
        case .IsGreaterThanOrEqual: return ">="
        }
    }
}

public enum FailType {
    case Expression
    case ExplicitFailure
}

public enum ResultType {
    case Pass
    case Fail(FailType)
}
public struct AssertionResult<T> : Error, CustomStringConvertible {
    let expressionType : ExpressionType
    let resultType : ResultType
    let lhs : T
    let rhs : T
    let message : String?
    
    public var description: String {
        switch resultType {
        case .Pass: return "👍 ok"
        case .Fail(.Expression): return "❌ expected: \(lhs) \(expressionType) \(rhs)"
        case .Fail(.ExplicitFailure): return "❌ explicit failure" // !TBD message
        }
    }
}

public struct ExprLhs<T : Equatable> {
    let lhs : T
    
    func makeResult( binaryOp : (T,T)->Bool, rhs: T, expressionType : ExpressionType ) -> AssertionResult<T> {
        if binaryOp( lhs, rhs ) {
            return AssertionResult( expressionType: expressionType, resultType: .Pass, lhs: lhs, rhs: rhs, message: nil )
        }
        else {
            return AssertionResult( expressionType: expressionType, resultType: .Fail(.Expression), lhs: lhs, rhs: rhs, message: nil )
        }
    }
    
    public static func ==( lhsExpr : ExprLhs, rhs: T) -> AssertionResult<T> {
        
        return lhsExpr.makeResult(binaryOp: ==, rhs: rhs, expressionType: .IsEqual )
    }
    public static func !=( lhsExpr : ExprLhs, rhs: T) -> AssertionResult<T> {
        return lhsExpr.makeResult(binaryOp: !=, rhs: rhs, expressionType: .IsNotEqual )
    }
    // !TBD: more overloads
    
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
