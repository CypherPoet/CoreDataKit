import XCTest

@testable import CypherPoetCoreDataKit_PredicateUtils



final class ComparisonPredicateTests: XCTestCase {
}


// MARK: - Making Braces
extension ComparisonPredicateTests {

    func testMakingFilterStringBraces() {
        var caseSensitive = true
        var diacriticSensitive = true
        
        var braces = NSComparisonPredicate.operatorBraces(
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertNotNil(braces)
        XCTAssertEqual(braces!, "[cd]")
        
        
        diacriticSensitive = false
        braces = NSComparisonPredicate.operatorBraces(
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertNotNil(braces)
        XCTAssertEqual(braces!, "[c]")
        
        
        caseSensitive = false
        diacriticSensitive = true
        braces = NSComparisonPredicate.operatorBraces(
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertNotNil(braces)
        XCTAssertEqual(braces!, "[d]")
        
        
        caseSensitive = false
        diacriticSensitive = false
        braces = NSComparisonPredicate.operatorBraces(
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertNil(braces)
    }
}



// MARK: - Making Filter Strings
extension ComparisonPredicateTests {
    
    func testMakingPredicateFilterStrings() {
        let predicateOperator = NSComparisonPredicate.Operator.beginsWith
        let predicateKeyword = NSComparisonPredicate.keyword(for: .beginsWith)
        var caseSensitive = true
        var diacriticSensitive = true
        
        var string = NSComparisonPredicate.stringValue(
            for: predicateOperator,
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertEqual(string, "\(predicateKeyword)[cd]")
        
        
        diacriticSensitive = false
        string = NSComparisonPredicate.stringValue(
            for: predicateOperator,
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertEqual(string, "\(predicateKeyword)[c]")

        
        caseSensitive = false
        diacriticSensitive = true
        string = NSComparisonPredicate.stringValue(
            for: predicateOperator,
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertEqual(string, "\(predicateKeyword)[d]")

        
        caseSensitive = false
        diacriticSensitive = false
        string = NSComparisonPredicate.stringValue(
            for: predicateOperator,
            caseSensitive: caseSensitive,
            diacriticSensitive: diacriticSensitive
        )
        
        XCTAssertEqual(string, predicateKeyword)
    }
}

// MARK: - Tests Manifest
extension ComparisonPredicateTests {
    static var allTests = [
        ("testMakingFilterStringBraces", testMakingFilterStringBraces),
    ]
}

