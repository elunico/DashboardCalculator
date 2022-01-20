//
//  ContentView.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import Combine
import SwiftUI

//https://stackoverflow.com/questions/64823492/how-to-open-another-window-in-swiftui-macos
extension View {
    
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        var frame = win.frame
        frame.size = CGSize(width: 640, height: 480)
        print(frame.debugDescription)
        frame.origin.x -= 840
        win.setFrame(frame, display: true, animate: true)
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        
        return win
    }
}

func format(_ answer: Double, decimalSet: Bool) -> String {
    if (answer == 0) {
        return "0"
    }

    let intDigitCount = Int(log10(abs(answer)).rounded())
    
    // allow many digits until a limit than move to 1 digit, decimal, and scientific notation
    if intDigitCount < ContentView.MAX_DIGITS {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = decimalSet
        formatter.hasThousandSeparators = true
        formatter.maximumIntegerDigits = intDigitCount + 1
        formatter.maximumFractionDigits = ContentView.MAX_DIGITS - formatter.maximumIntegerDigits
        return formatter.string(from: NSNumber(value: answer))!
    } else {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.exponentSymbol = "e"
        formatter.alwaysShowsDecimalSeparator = true
        formatter.hasThousandSeparators = false
        formatter.maximumIntegerDigits = 1
        formatter.maximumFractionDigits = ContentView.MAX_DIGITS - 6 // 1 or 0 . then E+/-###
        return formatter.string(from: NSNumber(value: answer))!
    }
}

struct ContentView: View {
    @ObservedObject var calculator = Calculator(maxDigits: ContentView.MAX_DIGITS, formatter: format)

    static let EQUALS_DIAMETER = 50.0
    static let MAX_DIGITS = 11

    var body: some View {
        let width = 172.0
        let height = 248.0
        
        guard let backgroundImage = NSImage(named: "Calculator") else {
            fatalError("A necessary asset is missing!")
        }
        
        return
            VStack(alignment: .center, spacing: 0.0) {
                ZStack {
                    Image("lcd-backlight")
                        .fixedSize()
                    
                    Text(calculator.currentExpression.formatted(formatter: format(_:decimalSet:)))
//                        .font(.custom("Helvetica Neue", size: 20))
                        .font(.custom("DB LCD Temp", size: 18))
                        .lineSpacing(24)
                        .foregroundColor(.black)
                        .frame(width: width, alignment: .trailing)
                        .padding(.trailing, 35.0)
                }.offset(x: 0, y: -5.0)
                #if DEBUG
                    .onTapGesture {
                        DebugView(calculator: calculator).openInWindow(title: "DebugView", sender: self)
                    }
                #endif
                
                Spacer().frame(width: 5, height: 5, alignment: .center)
                   
                
                let hSpacing = 0.0
                HStack(spacing: hSpacing) {
                    SmallButton(text: "m+", owner: calculator)
                    SmallButton(text: "m-", owner: calculator)
                    SmallButton(text: "mc", owner: calculator)
                    SmallButton(text: "mr", owner: calculator)
                    SmallButton(text: "÷", owner: calculator)
                        .offset(x: 0, y: -1)
                    
                }
                
                HStack(spacing: 0.0) {
                    
                    VStack(spacing: 0.0) {
                        // 3x4 buttons
                        HStack(spacing: hSpacing) {
                            BigButton(text: "7", owner: calculator)
                            BigButton(text: "8", owner: calculator)
                            BigButton(text: "9", owner: calculator)
                        }
                        
                        HStack(spacing: hSpacing) {
                            BigButton(text: "4", owner: calculator)
                            BigButton(text: "5", owner: calculator)
                            BigButton(text: "6", owner: calculator)
                        }
                        HStack(spacing: hSpacing) {
                            BigButton(text: "1", owner: calculator)
                            BigButton(text: "2", owner: calculator)
                            BigButton(text: "3", owner: calculator)
                        }
                        HStack(spacing: hSpacing) {
                            BigButton(text: "0", owner: calculator)
                            BigButton(text: ".", owner: calculator)
                            BigButton(text: "c", owner: calculator)
                            
                        }
                    }
                    
                    VStack(spacing: 3) {
                        SmallButton(text: "⨉", owner: calculator)
                        SmallButton(text: "–", owner: calculator)
                        SmallButton(text: "+", owner: calculator)
                        SmallButton(text: "=", owner: calculator)
                            .offset(x: 0, y: -1)
                            
                    }.frame(alignment: .top)
                }

                Spacer().frame(width: width/2, height: 5, alignment: .bottom)
        }
        .background(Image(nsImage: backgroundImage).frame( alignment: .center))
        .scaledToFill()
        .frame(width: width, height: height, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
