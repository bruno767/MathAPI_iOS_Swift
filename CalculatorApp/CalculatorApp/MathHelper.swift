//
//  MathHelper.swift
//  CalculatorApp
//
//  Created by Bruno Augusto Mendes Barreto Alves on 11/07/2017.
//  Copyright © 2017 Bruno Augusto Mendes Barreto Alves. All rights reserved.
//

import Foundation

enum ApiErrors: Error {
    case DivisionByZero
    case WrongExpressionFormat
    case WrongNumberFormat
}
// thanks https://stackoverflow.com/a/38160725
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class MathHelper {
    
    let operators = ["+","-","*","/"]
    
    /**
     Function to find the next operator using the orden Priority
     [/ -> * -> + -> -]
     
     return the index of the operator
     **/
    public func calculateExpression(expression: String) throws -> Float {
        //calculating
        var indxOperator = 0
        var expArray = self.convertToArray(expression: expression)
    
        //cleaning Array
        if let first = expArray.first{
            if operators.contains(first) {
                expArray.removeFirst()
            }
        }
        if let last = expArray.last{
            if operators.contains(last) {
                expArray.removeLast()
            }
        }
        //Identifying each operation should be called
            while expArray.count > 1 {
                indxOperator = self.indexOfOperator(expr: expArray)
                
                switch expArray[indxOperator] {
                case operators[2]:
                    do{
                        let result = try String(self.multiplication(a: expArray.remove(at: indxOperator-1), b: expArray.remove(at: indxOperator)))
                        expArray[indxOperator-1] = result
                    }catch{
                        throw ApiErrors.WrongExpressionFormat
                    }
                    
                case operators[3]:
                    do{
                        expArray[indxOperator-1] = try String(self.division(a: expArray.remove(at: indxOperator-1), b: expArray.remove(at: indxOperator)))
                    }catch let error as ApiErrors{
                        switch error {
                        case .DivisionByZero:
                            throw ApiErrors.DivisionByZero
                        case .WrongNumberFormat:
                            throw ApiErrors.WrongNumberFormat
                        default:
                            print("error")
                        }
                    }
                case operators[1]:
                    do{
                        expArray[indxOperator-1] = try String(self.subtraction(a: expArray.remove(at: indxOperator-1), b: expArray.remove(at: indxOperator)))
                    }catch{
                        throw ApiErrors.WrongExpressionFormat
                    }
                case operators[0]:
                    do{
                        expArray[indxOperator-1] = try String(self.addition(a: expArray.remove(at: indxOperator-1), b: expArray.remove(at: indxOperator)))
                    }catch{
                        throw ApiErrors.WrongExpressionFormat
                    }
                default:
                    print("any operator finded")
                    throw ApiErrors.WrongExpressionFormat
                }
                
            }
        
        if let resp = expArray.first{
            if let floatValue = Float(resp){
                return floatValue
            }else{
                return 0.0
            }
        }else{
            return 0.0
        }
    }
    /**
     Funcion to convert the String expression in [String]
    **/
    internal func convertToArray(expression: String) -> [String]{
        let range = expression.startIndex..<expression.endIndex
        var expressionArray = [String]()
        var isNumber = false
        var isNegative = false
        var zeroBefore = false
        var isDecimal = false
        var idxArray = 0
        
        if expression.isEmpty{
            return [""]
        }else{
            //split the expression
            for idx in expression.characters.indices[range]{
                
                if expression[idx] == "."{
                    if !isNumber {
                        zeroBefore = true
                    }else{
                        isDecimal = true
                    }
                }else{
                    
                    if operators.contains(String(expression[idx])) {
                        expressionArray.append(String(expression[idx]))
                        idxArray += 1
                        isNumber = false
                        if String(expression[idx]) == operators[1] {
                            isNegative = true
                        }
                    }else{
                        if isNumber {
                            if isDecimal {
                                expressionArray[idxArray-1] += "." + String(expression[idx])
                                isDecimal = false
                            }else{
                                 expressionArray[idxArray-1] += String(expression[idx])
                            }
                            
                        }else{
                            
                            if isNegative {
                                isDecimal ? expressionArray.append("-0." + String(expression[idx])) : expressionArray.append("-" + String(expression[idx]))
                                isNegative = false
                            }else{

                                zeroBefore ? expressionArray.append("0." + String(expression[idx])) :expressionArray.append( String(expression[idx]))
                            }
                            zeroBefore = false
                            isDecimal = false
                            isNumber = true
                            idxArray += 1
                        }
                    }
                    print(expressionArray)
                }
            }
        }
        return expressionArray
        
    }
    
    /**
    Function to find the next operator using the orden Priority
        [/ -> * -> + -> -]
         
    return the index of the operator
    **/
    internal func indexOfOperator(expr: [String])-> Int{
        
        for element in expr.reversed(){
            if element == operators[3] {
                return expr.index(of: element)!
            }
        }
        for element in expr.reversed(){
            if element == operators[2] {
                return expr.index(of: element)!
            }
        }
        for element in expr.reversed(){
            if element == operators[0] || element == operators[1] {
                return expr.index(of: element)!
            }
        }
        
        return 0
    }
    
   internal func addition(a: String, b: String) throws -> Float {
        if let valueA = Float(a), let valueB = Float(b) {
            return valueA + valueB
        }else{
            throw ApiErrors.WrongNumberFormat
        }
    }
    internal func subtraction(a: String, b: String) throws -> Float {
        if let valueA = Float(a), let valueB = Float(b) {
            return valueA - Swift.abs(valueB)
        }else{
            throw ApiErrors.WrongNumberFormat
        }
    }
    internal func division(a: String, b: String) throws -> Float {
        if let valueA = Float(a), let valueB = Float(b) {
            if valueB == 0{
                throw ApiErrors.DivisionByZero //check division by 0
            }else{
                return valueA / valueB
            }
        }else{
            throw ApiErrors.WrongNumberFormat
        }
    }
    
    internal func multiplication(a: String, b: String) throws -> Float {
        if let valueA = Float(a), let valueB = Float(b) {
            return valueA * valueB
        }else{
            throw ApiErrors.WrongNumberFormat
        }
        
    }
    internal func multiplyByMinusOne(value: String) throws -> String {
        if var value = Float(value){
            value = value * -1.0
            return  "\(value)"
        }
        throw ApiErrors.WrongNumberFormat
    }
    func getPercentage(value: String) throws -> String {
        if var value = Float(value){
            value = value * 0.01
            return  "\(value)"
        }
        throw ApiErrors.WrongNumberFormat
    }
    

    
}
