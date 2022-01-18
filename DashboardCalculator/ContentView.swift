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
        frame.origin = CGPoint(x: 10, y: 10)
        win.setFrame(frame, display: true, animate: true)
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        
        return win
    }
}

let theOrange = Color(.displayP3, red: 0.9, green: 0.4, blue: 0.2, opacity: 1.0)

let outerWidth = 200.0
let innerWidth = 175.0
let outerHeight = 295.0
let innerHeight = 285.0


struct ContentView: View {
    @ObservedObject var calculator = Calculator()


    var body: some View {
        return GeometryReader { geometry in
            VStack {
                
                Text(calculator.currentExpression.isEmpty ? "0" : calculator.currentExpression)
                    .frame(width: innerWidth, height: 40, alignment: .trailing)
                    .font(.custom("Helvetica Neue", size: 20))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    .background(Image("screen").resizable().scaledToFill())
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                Spacer()
                    .frame(width: innerWidth + 5, height: 5, alignment: .center)
                    .background(theOrange)
                Spacer().frame(width: innerWidth + 5, height: 5, alignment: .center)
                HStack(spacing: 8.0) {
                    SmallButton(text: "m+", delegate: calculator)
                    SmallButton(text: "m-", delegate: calculator)
                    SmallButton(text: "mc", delegate: calculator)
                    SmallButton(text: "mr", delegate: calculator)
                    SmallButton(text: "÷", delegate: calculator)
                    
                }
                
                HStack(spacing: 2.0) {
                    
                    VStack(spacing: 2.0) {
                        // 3x4 buttons
                        HStack(spacing: 2.0) {
                            BigButton(text: "7", delegate: calculator)
                            BigButton(text: "8", delegate: calculator)
                            BigButton(text: "9", delegate: calculator)
                        }
                        
                        HStack(spacing: 2.0) {
                            BigButton(text: "4", delegate: calculator)
                            BigButton(text: "5", delegate: calculator)
                            BigButton(text: "6", delegate: calculator)
                        }
                        HStack(spacing: 2.0) {
                            BigButton(text: "1", delegate: calculator)
                            BigButton(text: "2", delegate: calculator)
                            BigButton(text: "3", delegate: calculator)
                        }
                        HStack(spacing: 2.0) {
                            BigButton(text: "0", delegate: calculator)
                            BigButton(text: ".", delegate: calculator)
                            BigButton(text: "c", delegate: calculator)
                            
                        }
                    }
                    
                    VStack( spacing: 10.0) {
                        SmallButton(text: "⨉", delegate: calculator)
                        SmallButton(text: "–", delegate: calculator)
                        SmallButton(text: "+", delegate: calculator)
                        Text("=")
                            .frame(width: SmallButton.diameter, height: 70.0, alignment: .center)
                            .font(.custom("Monaco", size: 10))
                            .background(Color.white)
                            .foregroundColor(Color.gray)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: SmallButton.diameter/2, height: SmallButton.diameter/2)))
                            .onTapGesture {
                                calculator.fire(key: "=")
                            }
                    }
                }
                #if DEBUG
                Button("Debug View"){
                    DebugView(calculator: calculator).openInWindow(title: "DebugView", sender: self)
                }
                #endif
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
