//
//  Calculator.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import Foundation
import AppKit

func * (lhs: String, rhs: Int) -> String {
    return String(repeating: lhs, count: rhs)
}

enum CalculatorState: CustomStringConvertible {
    case Empty
    case InputtingFirstNumber
    case DisplayingMemoryRecall
    case AwaitingNextNumber
    case InputtingSecondNumber
    case DisplayingIntermediateResult
    case DisplayingResult
    case Error
    
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
        case .Error:
            return "Error"
        }
    }
}


class Calculator: ObservableObject {
    
    func isActive(operation: String) -> Bool {
        return operation == self.operation
    }
    
    static let MAX_DIGITS = 12
    
    var previousExpression: String = "0"
    var currentExpression: String = "0"
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
    
    fileprivate func clearCalculator() {
        currentExpression = "0"
        previousExpression = "0"
        operation = ""
        updateState(.Empty)
        updateState(.Empty) // empty current and previous state
        lastKeyPressed = nil
    }
    
    fileprivate func raiseError() {
        currentExpression = "Error!"
        updateState(.Error)
        self.objectWillChange.send()
    }
    
    func fire(key: String) {
        print(key)
        lastKeyPressed = key
        if state == .Error {
            if key == "c" {
                clearCalculator()
            } else {
                NSSound.beep()
            }
            self.objectWillChange.send()
            return
        }
        if "1234567890.".contains(key) {
            if state == .Empty {
                currentExpression = (currentExpression == "0" ? key : currentExpression + key)
                updateState(.InputtingFirstNumber)
            } else if (state == .InputtingFirstNumber || state == .InputtingSecondNumber) {
                if currentExpression.count == Calculator.MAX_DIGITS {
                    raiseError()
                } else {
                    currentExpression += key
                }
            } else if state == .AwaitingNextNumber || state == .DisplayingIntermediateResult  {
                previousExpression = currentExpression
                currentExpression = key
                updateState(.InputtingSecondNumber)
            } else if state == .DisplayingResult {
                previousExpression = "0"
                currentExpression = key
                updateState(.InputtingFirstNumber)
            } else if state == .DisplayingMemoryRecall {
                popState()
                currentExpression = key
            }
        } else if "+–⨉÷".contains(key) {
            if state == .Empty {
                operation = key
                updateState(.AwaitingNextNumber)
            } else if state == .InputtingFirstNumber || state == .DisplayingMemoryRecall{
                operation = key
                updateState(.AwaitingNextNumber)
            } else if state == .InputtingSecondNumber {
                guard let answer = evaluateOperation() else { raiseError(); return }
                previousExpression = currentExpression
                currentExpression = format(answer)
                operation = key
                updateState(.DisplayingIntermediateResult)
            } else if state == .DisplayingIntermediateResult || state == .AwaitingNextNumber {
                if state == .AwaitingNextNumber {
                    previousExpression = currentExpression
                }
                guard let answer = evaluateOperation() else {  raiseError(); return }
                currentExpression = format(answer)
                operation = key
                updateState(.DisplayingIntermediateResult)
            } else if state == .DisplayingResult {
                operation = key
                updateState(.AwaitingNextNumber)
            }
        } else if key == "c" {
            clearCalculator()
        } else if key == "=" {
            if state == .AwaitingNextNumber {
                previousExpression = currentExpression
            }
            guard let answer = evaluateOperation() else {  raiseError(); return }
            previousExpression = "0"
            currentExpression = format(answer)
            operation = ""
            updateState(.DisplayingResult)
        } else if ["m+", "m-", "mc", "mr"].contains(key) {
            if key == "m+" {
                guard let current = Double(currentExpression) else {  raiseError(); return }
                memory += current
            } else if key == "m-" {
                guard let current = Double(currentExpression) else {  raiseError(); return }
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
        let string = String(answer)
        
        // integer up to a point then scientific notation
        if string.hasSuffix(".0") && string.count <= Calculator.MAX_DIGITS {
            return String(string[string.startIndex..<string.index(string.endIndex, offsetBy: -2)])
            // really big numbers are always scientific
        } else if string.count > Calculator.MAX_DIGITS {
            let value = String(format: "%0.06g", answer)
            return value
            // not int and not big - regular floating point value with few digits
        } else {
            return string
        }
    }
    
    func evaluateOperation() -> Double? {
        guard let first = Double(previousExpression),
              let second = Double(currentExpression) else {
                  fatalError("This should not happen. Do not let current or previous be invalid current: \(currentExpression), previous: \(previousExpression)")
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
        
        if answer > 1e300 || answer < -1e300 || answer < 1e-298 {
            return nil
        }
        
        return answer
    }
}
