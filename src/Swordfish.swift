// Swordfish
// By Phil Nash
//
// Include this file into a test target folder of a Swift project to use
//
// The repository is hosted at: https://github.com/philsquared/Swordfish
// This project is licensed under the BSD 2-Clause License
// See the associated LICENSE file in the root of this repository

import XCTest

public class SwordfishTests : XCTestCase {}


// Holds the LHS of the expression (as well as the auxiliary info,
// message, file and line) and provides overloads for comparison
// operators that forward on to XCTAssert...
// - as with Assertion, we should be able to capture rhs by @autoclosure
public struct ExprLhs<T : Equatable> {
    let msg : String
    let lhs : T
    let file: StaticString
    let line: UInt

    func assertEqual( _ rhs: T ) {
        XCTAssertEqual( lhs, rhs, msg, file:file, line: line )
    }
    func assertNotEqual( _ rhs: T ) {
        XCTAssertNotEqual( lhs, rhs, msg, file:file, line: line )
    }
    public static func ==( lhsExpr : ExprLhs, rhs: T ) {
        lhsExpr.assertEqual( rhs )
    }
    public static func !=( lhsExpr : ExprLhs, rhs: T ) {
        lhsExpr.assertNotEqual( rhs )
    }
}

// For now the only role of this type is to allow | to be overloaded, and
// pass on the message, file and line to the start of the expression object
public struct Assertion {
    let msg : String
    let file: StaticString
    let line: UInt

    // We're capturing the LHS value eagerly, but we should be able to capture
    // as an @autoclosure
    public static func | <T>(assertion: Assertion, lhs: T) -> ExprLhs<T> {
        return ExprLhs(msg: assertion.msg, lhs: lhs, file: assertion.file, line: assertion.line )
    }
}

// Captures an optional message, as well as file/ line number and bundles that up
// in an Assertion object
public func require( _ msg : String = String(), file: StaticString = #file, line: UInt = #line ) -> Assertion {
    return Assertion( msg: msg, file: file, line: line )
}
