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




struct ContentView: View {
    @ObservedObject var calculator = Calculator()

    static let theOrange = Color(.displayP3, red: 0.85, green: 0.5, blue: 0.2, opacity: 1.0)
    static let EQUALS_DIAMETER = 50.0
    static let outerWidth = 165.0
    static let innerWidth = 145.0
    static let outerHeight = 260.0
    static let innerHeight = 235.0

    var body: some View {
        return GeometryReader { geometry in
            VStack(spacing: 2.0) {
                
                Text(calculator.currentExpression.isEmpty ? "0" : calculator.currentExpression)
                    
                    .frame(width: ContentView.innerWidth, height: 40, alignment: .trailing)
                    .font(.custom("Helvetica Neue", size: 20))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    .background(Image("lcd-backlight").resizable().scaledToFill())
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                #if DEBUG
                    .onTapGesture {
                    DebugView(calculator: calculator).openInWindow(title: "DebugView", sender: self)
                    }
                #endif
                
                Spacer()
                    .frame(width: ContentView.innerWidth + 5, height: 5, alignment: .center)
                    .background(ContentView.theOrange)
                Spacer().frame(width: ContentView.innerWidth + 5, height: 5, alignment: .center)
                HStack(spacing: 2.0) {
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
                    
                    VStack( spacing: 3) {
                        SmallButton(text: "⨉", delegate: calculator)
                        SmallButton(text: "–", delegate: calculator)
                        SmallButton(text: "+", delegate: calculator)
                        Text("=")
                            .frame(width: ContentView.EQUALS_DIAMETER-30, height: 60, alignment: .center)
                            .font(.custom("Monaco", size: 10))
                            .background(Color.white)
                            .foregroundColor(Color.gray)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: SmallButton.diameter/2, height: SmallButton.diameter/2)))
                            .onTapGesture {
                                calculator.fire(key: "=")
                            }
                    }
                }

                Spacer()
                    .frame(width: ContentView.innerWidth, height: 5, alignment: .bottom)
                
                
            }
            .background(Color(white:0.75, opacity: 1.0))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            
            .position(x: ContentView.outerWidth/2, y: ContentView.outerHeight/2)
            .frame(width: ContentView.innerWidth, height: ContentView.innerHeight, alignment: .bottom)
            
            
        }
        .frame(width: ContentView.outerWidth, height: ContentView.outerHeight, alignment: .center)
        .background(ContentView.theOrange)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
