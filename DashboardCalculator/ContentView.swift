//
//  ContentView.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct EmptyCalc: Calculator {
    func updateExpression(symbol: String) {
        
    }
    
}

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

let theOrange = Color(.displayP3, red: 0.9, green: 0.4, blue: 0.2, opacity: 1.0)

let outerWidth = 200.0
let innerWidth = 175.0
let outerHeight = 295.0
let innerHeight = 285.0

struct ContentView: View, Calculator {
    @State var previousExpression: String = ""
    @State var currentExpression: String = ""
    @State var operation: String = ""
    @State var state = CalculatorState.Empty
    
    var body: some View {
        
        
        return GeometryReader { geometry in
            VStack {
                
                Text(currentExpression.isEmpty ? "0" : currentExpression)
                    .frame(width: innerWidth, height: 40, alignment: .trailing)
                    .font(.custom("Seven Segment", size: 26))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
//                    .background(Color.cyan)
                    .background(Image("screen").resizable().scaledToFill())
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                Spacer()
                    .frame(width: innerWidth + 5, height: 5, alignment: .center)
                    .background(theOrange)
                Spacer().frame(width: innerWidth + 5, height: 5, alignment: .center)
                HStack(spacing: 8.0) {
                    SmallButton(text: "m+", delegate: self)
                    SmallButton(text: "m-", delegate: self)
                    SmallButton(text: "mc", delegate: self)
                    SmallButton(text: "mr", delegate: self)
                    SmallButton(text: "÷", delegate: self)

                }
                
                HStack(spacing: 2.0) {
                    
                    VStack(spacing: 2.0) {
                        // 3x4 buttons
                        HStack(spacing: 2.0) {
                            BigButton(text: "7", delegate: self)
                            BigButton(text: "8", delegate: self)
                            BigButton(text: "9", delegate: self)
                        }
                        
                        HStack(spacing: 2.0) {
                            BigButton(text: "4", delegate: self)
                            BigButton(text: "5", delegate: self)
                            BigButton(text: "6", delegate: self)
                        }
                        HStack(spacing: 2.0) {
                            BigButton(text: "1", delegate: self)
                            BigButton(text: "2", delegate: self)
                            BigButton(text: "3", delegate: self)
                        }
                        HStack(spacing: 2.0) {
                            BigButton(text: "0", delegate: self)
                            BigButton(text: ".", delegate: self)
                            BigButton(text: "c", delegate: self)
                            
                        }
                    }
                    
                    VStack( spacing: 10.0) {
                        SmallButton(text: "⨉", delegate: self)
                        SmallButton(text: "–", delegate: self)
                        SmallButton(text: "+", delegate: self)
                        Text("=")
                            .frame(width: SmallButton.diameter, height: 70.0, alignment: .center)
                            .font(.custom("Monaco", size: 10))
                            .background(.white)
                            .foregroundColor(Color.gray)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: SmallButton.diameter/2, height: SmallButton.diameter/2)))
                            .onTapGesture {
                                updateExpression(symbol: "=")
                            }
                    }
                }
                Spacer().frame(width: innerWidth, height: 5, alignment: .bottom)
            
            }
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))

            .position(x: outerWidth/2, y: outerHeight/2)
            .frame(width: innerWidth, height: innerHeight, alignment: .bottom)
            
        }
        .frame(width: outerWidth, height: outerHeight, alignment: .center)
        .background(theOrange)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        
    }
    
    func updateExpression(symbol: String) {
        print(symbol)
        if "1234567890.".contains(symbol) {
            if state == .Empty {
                currentExpression += symbol
                state = .InputtingFirstNumber}
            else if state == .InputtingFirstNumber || state == .InputtingSecondNumber {
                currentExpression += symbol
            }
            else if state == .AwaitingNextNumber || state == .DisplayingIntermediateResult {
                previousExpression = currentExpression
                currentExpression = symbol
                state = .InputtingSecondNumber
            } else if state == .DisplayingResult {
                previousExpression = ""
                currentExpression = symbol
                state = .InputtingFirstNumber
            }
            
            
            
        } else if "+–⨉÷".contains(symbol) {
            if state == .Empty {
                operation = symbol
            } else if state == .InputtingFirstNumber {
                operation = symbol
                state = .AwaitingNextNumber
            } else if state == .InputtingSecondNumber {
                guard let answer = evaluateOperation() else { return }
                previousExpression = currentExpression
                currentExpression = String(answer)
                operation = symbol
                state = .DisplayingIntermediateResult
            } else if state == .DisplayingIntermediateResult {
                guard let answer = evaluateOperation() else { return }
                currentExpression = String(answer)
                operation = symbol
                state = .DisplayingIntermediateResult
            }
        } else if symbol == "c" {
            currentExpression = ""
            previousExpression = ""
            operation = ""
        } else if symbol == "=" {
            guard let answer = evaluateOperation() else { return }
            previousExpression = ""
            currentExpression = String(answer)
            operation = ""
            state = .DisplayingResult
        }
    }
    
    fileprivate func evaluateOperation() -> Double? {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
