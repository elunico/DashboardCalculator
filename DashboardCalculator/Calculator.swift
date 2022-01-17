//
//  Calculator.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import Foundation

enum CalculatorState: CustomStringConvertible {
    case Empty
    case InputtingFirstNumber
    case AwaitingNextNumber
    case InputtingSecondNumber
    case DisplayingIntermediateResult
    case DisplayingResult
    
    var description: String {
        switch self {
        case .Empty:
            return "Empty"
        case .InputtingFirstNumber:
            return "InputtingFirstNumber"
        case .AwaitingNextNumber:
            return "AwaitingNextNumber"
        case .InputtingSecondNumber:
            return "InputtingSecondNumber"
        case .DisplayingIntermediateResult:
            return "DisplayingIntermediateResult"
        case .DisplayingResult:
            return "DisplayingResult"
        }
    }
}


class Calculator: ObservableObject {
    
    func isActive(operation: String) -> Bool {
        return operation == self.operation
    }
    
    
    var previousExpression: String = ""
    var currentExpression: String = ""
    var operation: String = ""
    var state = CalculatorState.Empty
    
    func fire(key: String) {
        print(key)
        if "1234567890.".contains(key) {
            if state == .Empty {
                currentExpression += key
                state = .InputtingFirstNumber}
            else if state == .InputtingFirstNumber || state == .InputtingSecondNumber {
                currentExpression += key
            }
            else if state == .AwaitingNextNumber || state == .DisplayingIntermediateResult {
                previousExpression = currentExpression
                currentExpression = key
                state = .InputtingSecondNumber
            } else if state == .DisplayingResult {
                previousExpression = ""
                currentExpression = key
                state = .InputtingFirstNumber
            }
            
            
            
        } else if "+–⨉÷".contains(key) {
            if state == .Empty {
                operation = key
            } else if state == .InputtingFirstNumber {
                operation = key
                state = .AwaitingNextNumber
            } else if state == .InputtingSecondNumber {
                guard let answer = evaluateOperation() else { return }
                previousExpression = currentExpression
                currentExpression = format(answer)
                operation = key
                state = .DisplayingIntermediateResult
            } else if state == .DisplayingIntermediateResult || state == .AwaitingNextNumber {
                if state == .AwaitingNextNumber {
                    previousExpression = currentExpression
                }
                guard let answer = evaluateOperation() else { return }
                currentExpression = format(answer)
                operation = key
                state = .DisplayingIntermediateResult
            } else if state == .DisplayingResult {
                operation = key
                state = .AwaitingNextNumber
            }
        } else if key == "c" {
            currentExpression = ""
            previousExpression = ""
            operation = ""
        } else if key == "=" {
            if state == .AwaitingNextNumber {
                previousExpression = currentExpression
            }
            guard let answer = evaluateOperation() else { return }
            previousExpression = ""
            currentExpression = format(answer)
            operation = ""
            state = .DisplayingResult
        }
        self.objectWillChange.send()
    }
    
    func format(_ answer: Double) -> String {
        var string = String(answer)
        
        assert(string.contains("."), "Calculator result string does not contain a . and formatting will produce a wrong answer")
        
        while string.count > 13 && string.last != "." {
            string.removeLast()
        }
        
        return string
    }
    
    func evaluateOperation() -> Double? {
        guard let first = Double(previousExpression),
              let second = Double(currentExpression) else {
                  return nil
              }
        let answer: Double
        
        
        switch operation {
        case "+":
            answer = first + second
        case "–":
            answer = first - second
        case "⨉":
            answer = first * second
        case "÷":
            answer = first / second
        default:
            fatalError("Unknown operation \(operation)")
        }
        
        return answer
    }
}
