//
//  MathHelperTests.swift
//  CalculatorApp
//
//  Created by Bruno Augusto Mendes Barreto Alves on 11/07/2017.
//  Copyright © 2017 Bruno Augusto Mendes Barreto Alves. All rights reserved.
//

import XCTest
@testable import CalculatorApp

class MathHelperTests: XCTestCase {
    
    let mathApi = MathHelper()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testConvertToArray(){
        let expression = "0/3*222+2-333*3"
        let answer = ["0","/","3","*","222","+","2","-","-333","*","3"]
        XCTAssertEqual(mathApi.convertToArray(expression: expression), answer)
        
    }
    func testCalculateExpression(){
        let expression = "3/3*222+2-333*3"
        let answer = Float(-775.0)
        XCTAssertEqual(try mathApi.calculateExpression(expression: expression), answer)
        
    }
    func testOperationOrder() {
        var operators = ["/","+","*","-"]
        XCTAssertEqual(mathApi.indexOfOperator(expr: operators), 0, "The first operator is /")
        operators.remove(at: 0)
        XCTAssertEqual(mathApi.indexOfOperator(expr: operators), 1, "The second operator is *")
        operators.remove(at: 1)
        XCTAssertEqual(mathApi.indexOfOperator(expr: operators), 1, "The third operator is -")
        operators.remove(at: 1)
        XCTAssertEqual(mathApi.indexOfOperator(expr: operators), 0, "The fourth operator is +")
    
    }
    
    func testAddition() {
        let a = "3"
        let b = "-10"
        let answer = Float(-7.0)
        XCTAssertEqual(try mathApi.addition(a: a, b: b), answer, "the right answer must be \(answer)")
    }
    func testSubtraction() {
        let a = "-3"
        let b = "10"
        let answer = Float(-13.0)
        XCTAssertEqual(try mathApi.subtraction(a: a, b: b), answer, "the right answer must be \(answer)")
    }
    func testMultiplication() {
        let a = "-3"
        let b = "4"
        let answer = Float(-3*4)
        XCTAssertEqual(try mathApi.multiplication(a: a, b: b), answer, "the right answer must be \(answer)")
    }
    func testDivision() {
        let a = "-3"
        let b = "9"
        let answer = Float(-3.0/9.0)
        if b != "0" {
            XCTAssertEqual(try mathApi.division(a: a, b: b), answer, "the right answer must be \(answer)")
        }else {
            XCTAssertNotEqual(try mathApi.division(a: a, b: b), answer, "exeption")
        }
    }
}
