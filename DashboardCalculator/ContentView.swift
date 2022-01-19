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

    static let EQUALS_DIAMETER = 50.0
    static let outerWidth = 165.0
    static let innerWidth = 145.0
    static let outerHeight = 260.0
    static let innerHeight = 235.0

    var body: some View {
        return GeometryReader { geometry in
            VStack(spacing: 2.0) {
                
                Text(calculator.currentExpression)
                    
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
                    .background(Color("bezelColor"))
                
                Spacer()
                    .frame(width: ContentView.innerWidth + 5, height: 5, alignment: .center)
                
                HStack(spacing: 2.0) {
                    SmallButton(text: "m+", owner: calculator)
                    SmallButton(text: "m-", owner: calculator)
                    SmallButton(text: "mc", owner: calculator)
                    SmallButton(text: "mr", owner: calculator)
                    SmallButton(text: "÷", owner: calculator)
                    
                }
                
                HStack(spacing: 2.0) {
                    
                    VStack(spacing: 2.0) {
                        // 3x4 buttons
                        HStack(spacing: 2.0) {
                            BigButton(text: "7", owner: calculator)
                            BigButton(text: "8", owner: calculator)
                            BigButton(text: "9", owner: calculator)
                        }
                        
                        HStack(spacing: 2.0) {
                            BigButton(text: "4", owner: calculator)
                            BigButton(text: "5", owner: calculator)
                            BigButton(text: "6", owner: calculator)
                        }
                        HStack(spacing: 2.0) {
                            BigButton(text: "1", owner: calculator)
                            BigButton(text: "2", owner: calculator)
                            BigButton(text: "3", owner: calculator)
                        }
                        HStack(spacing: 2.0) {
                            BigButton(text: "0", owner: calculator)
                            BigButton(text: ".", owner: calculator)
                            BigButton(text: "c", owner: calculator)
                            
                        }
                    }
                    
                    VStack(spacing: 5) {
                        SmallButton(text: "⨉", owner: calculator)
                        SmallButton(text: "–", owner: calculator)
                        SmallButton(text: "+", owner: calculator)
                        Image("equal")
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
        .background(Color("bezelColor"))
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
