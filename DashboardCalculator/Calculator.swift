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
    case DisplayingMemoryRecall
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
        case .DisplayingMemoryRecall:
            return "DisplayingMemoryRecall"
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
    var previousState: CalculatorState? = .Empty
    private(set) var lastKeyPressed: String? = nil
    
    var memory: Double = 0.0
    
    func updateState(_ newState: CalculatorState) {
        previousState = state
        state = newState
    }
    
    func popState() {
        assert(previousState != nil, "Two pop states before changing states!")
        state = previousState!
        previousState = nil
    }
    
    func fire(key: String) {
        print(key)
        lastKeyPressed = key
        if "1234567890.".contains(key) {
            if state == .Empty {
                currentExpression += key
                updateState(.InputtingFirstNumber)
            }else if state == .InputtingFirstNumber || state == .InputtingSecondNumber {
                currentExpression += key
            }else if state == .AwaitingNextNumber || state == .DisplayingIntermediateResult  {
                previousExpression = currentExpression
                currentExpression = key
                updateState(.InputtingSecondNumber)
            } else if state == .DisplayingResult {
                previousExpression = ""
                currentExpression = key
                updateState(.InputtingFirstNumber)
            } else if state == .DisplayingMemoryRecall {
                popState()
                currentExpression = key
            }
        } else if "+–⨉÷".contains(key) {
            if state == .Empty {
                operation = key
            } else if state == .InputtingFirstNumber || state == .DisplayingMemoryRecall{
                operation = key
                updateState(.AwaitingNextNumber)
            } else if state == .InputtingSecondNumber {
                guard let answer = evaluateOperation() else { return }
                previousExpression = currentExpression
                currentExpression = format(answer)
                operation = key
                updateState(.DisplayingIntermediateResult)
            } else if state == .DisplayingIntermediateResult || state == .AwaitingNextNumber {
                if state == .AwaitingNextNumber {
                    previousExpression = currentExpression
                }
                guard let answer = evaluateOperation() else { return }
                currentExpression = format(answer)
                operation = key
                updateState(.DisplayingIntermediateResult)
            } else if state == .DisplayingResult {
                operation = key
                updateState(.AwaitingNextNumber)
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
            updateState(.DisplayingResult)
        } else if ["m+", "m-", "mc", "mr"].contains(key) {
            if key == "m+" {
                guard let current = Double(currentExpression) else { return }
                memory += current
            } else if key == "m-" {
                guard let current = Double(currentExpression) else { return }
                memory -= current
            } else if key == "mc" {
                memory = 0.0
            } else if key == "mr" {
                previousExpression = currentExpression
                currentExpression = format(memory)
                updateState(.DisplayingMemoryRecall)
            }
        }
        self.objectWillChange.send()
    }
    
    func format(_ answer: Double) -> String {
        var string = String(answer)
        assert(string.contains("."), "Calculator result string does not contain a . and formatting will produce a wrong answer")

        if string.hasSuffix(".0") {
            string = String(string[string.startIndex..<string.index(string.endIndex, offsetBy: -2)])
        }
        
        
        while string.count > 15 && string.last != "." {
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
