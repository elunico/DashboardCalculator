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

enum OperatorState: CustomStringConvertible {
    case Empty
    case Selected(operation: String)
    
    var description: String {
        switch self {
        case .Empty:
            return "Empty"
        case .Selected(let operation):
            return "Selected(\(operation))"
        }
    }
}

struct ActiveExpression {
    var content: String
    var decimalSet = false
    
    static let ERROR_STRING = "ERROR"
    
    var doubleValue: Double {
        assert(content != ActiveExpression.ERROR_STRING, "Do not allow conversion to double on error condition!")
        if content.isEmpty { return 0 }
        if content.hasPrefix(".") {
            return Double("0" + content)!
        } else {
            return Double(content)!
        }
    }
    
    
    func formatted(formatter: (Double, Bool) -> String) -> String {
        if content == ActiveExpression.ERROR_STRING {
            return ActiveExpression.ERROR_STRING
        }
        if content.isEmpty {
            return "0"
        }
        return formatter(doubleValue, decimalSet)
    }
    
    var count: Int {
        content.count
    }
    
    mutating func reset() {
        content = ""
        decimalSet = false
    }
    
    init(from: Double) {
        self.content = String(from)
    }
    
    mutating func set(fromValue value: Double) {
        self.content = String(value)
    }
    
    mutating func set(content: String) {
        self.content = content
    }
    
    mutating func append(_ content: String) {
        self.content += content
    }
    
    init(content: String) {
        self.content = content
    }
    
    mutating func raiseError() {
        self.content = ActiveExpression.ERROR_STRING
    }
}

func swap(_ first: inout Double, _ second: inout ActiveExpression) {
    let temp = second.doubleValue
    second = ActiveExpression(from: first)
    first = temp
}

class Calculator: ObservableObject {
    
    func isPerformingOperation(representedBy string: String) -> Bool {
        switch operatorState {
        case .Empty:
            return false
        case .Selected(let operation):
            return operation == string
        }
    }
        
    init(maxDigits: Int, formatter: @escaping (_ value: Double, _ decimalSet: Bool) -> String) {
        self.formatter = formatter
        self.currentExpression = ActiveExpression(content: "")
        self.maxDigits = maxDigits
    }
    
    var formatter: (_ value: Double, _ decimalSet: Bool) -> String
    var maxDigits: Int
    var previousExpression: Double = 0.0
    var currentExpression: ActiveExpression
    var state = CalculatorState.Empty
    var previousState: CalculatorState? = .Empty
    var operatorState: OperatorState = .Empty
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
        currentExpression.reset()
        previousExpression = 0.0
        updateState(.Empty)
        updateState(.Empty) // empty current and previous state
        operatorState = .Empty
        lastKeyPressed = nil
    }
    
    fileprivate func raiseError() {
        updateState(.Error)
        self.currentExpression.raiseError()
        self.objectWillChange.send()
    }
    
    func setOperation(to symbol: String?) {
        if let operation = symbol {
            operatorState = .Selected(operation: operation)
        } else {
            operatorState = .Empty
        }
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
            if "." == key {
                currentExpression.decimalSet = true
            }
            if state == .Empty {
                currentExpression.append(key)
                updateState(.InputtingFirstNumber)
            } else if (state == .InputtingFirstNumber || state == .InputtingSecondNumber) {
                if currentExpression.count == maxDigits {
                    raiseError()
                } else {
                    currentExpression.append(key)
                }
            } else if state == .AwaitingNextNumber || state == .DisplayingIntermediateResult  {
                previousExpression = currentExpression.doubleValue
                currentExpression.set(content: key)
                updateState(.InputtingSecondNumber)
            } else if state == .DisplayingResult {
                previousExpression = 0.0
                currentExpression.set(content: key)
                updateState(.InputtingFirstNumber)
            } else if state == .DisplayingMemoryRecall {
                popState()
                currentExpression.set(content: key)
            }
        } else if "+????????".contains(key) {
            if state == .Empty {
                setOperation(to: key)
                updateState(.AwaitingNextNumber)
            } else if state == .InputtingFirstNumber || state == .DisplayingMemoryRecall{
                setOperation(to: key)
                updateState(.AwaitingNextNumber)
            } else if state == .InputtingSecondNumber {
                guard let answer = evaluateOperation() else { return }
                previousExpression = currentExpression.doubleValue
                currentExpression = ActiveExpression(from: answer)
                setOperation(to: key)
                updateState(.DisplayingIntermediateResult)
            } else if state == .DisplayingIntermediateResult || state == .AwaitingNextNumber {
                switch operatorState {
                case .Empty:
                    break
                case .Selected(let operation):
                    if operation != key {
                        setOperation(to: key)
                    } else {
                        if state == .AwaitingNextNumber {
                            previousExpression = currentExpression.doubleValue
                            guard let answer = evaluateOperation() else { return }
                            currentExpression = ActiveExpression(from: answer)
                            setOperation(to: key)
                            updateState(.DisplayingIntermediateResult)
                        } else {
                            swap(&previousExpression, &currentExpression)
                            guard let answer = evaluateOperation() else { return }
                            swap(&previousExpression, &currentExpression)
                            currentExpression = ActiveExpression(from: answer)
                            setOperation(to: key)
                            updateState(.DisplayingIntermediateResult)
                        }
                    }
                }
                
                
            } else if state == .DisplayingResult {
                setOperation(to: key)
                updateState(.AwaitingNextNumber)
            }
        } else if key == "c" {
            clearCalculator()
        } else if key == "=" {
            if state == .AwaitingNextNumber {
                previousExpression = currentExpression.doubleValue
            }
            guard let answer = evaluateOperation() else { return }
            previousExpression = 0.0
            setOperation(to: nil)
            currentExpression = ActiveExpression(from: answer)
            updateState(.DisplayingResult)
        } else if ["m+", "m-", "mc", "mr"].contains(key) {
            if key == "m+" {
                memory += currentExpression.doubleValue
            } else if key == "m-" {
                memory -= currentExpression.doubleValue
            } else if key == "mc" {
                memory = 0.0
            } else if key == "mr" {
                previousExpression = currentExpression.doubleValue
                currentExpression.set(fromValue: memory)
                updateState(.DisplayingMemoryRecall)
            }
        }
        self.objectWillChange.send()
    }
    
    
    
    func evaluateOperation() -> Double? {
        let first = previousExpression
        let second = currentExpression.doubleValue
        let answer: Double
        
        
        switch operatorState {
        case .Empty:
            return nil
        case .Selected(let operation):
            switch operation {
            case "+":
                answer = first + second
            case "???":
                answer = first - second
            case "???":
                answer = first * second
            case "??":
                answer = first / second
            case "":
                return nil
            default:
                fatalError("Unknown operation \(operation)")
            }
        }
        
        if answer > 1e300 || answer < -1e300 || (answer > 0 && answer < 1e-298) {
            print("Over/underflow \(answer)")
            raiseError()
            return nil
        }
        
        return answer
    }
}
