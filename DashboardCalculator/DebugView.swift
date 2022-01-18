//
//  DebugView.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/18/22.
//

import SwiftUI

struct DebugVar: View {
    let text: String
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .fontWeight(.bold)
            .font(.system(size: 16.0))
            .foregroundColor(.gray)
            .frame(width: 200, height: 60, alignment: .trailing)
    }
}

struct DebugValue: View {
    let text: String
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 16.0))
            .frame(width: 200, height: 60, alignment: .leading)
    }
}

struct DebugView: View {
    @ObservedObject var calculator: Calculator
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    DebugVar("Previous Expression: ")
                    DebugValue(calculator.previousExpression)
                }
                HStack {
                    DebugVar("Current Expression: ")
                    DebugValue(calculator.currentExpression)
                }
                HStack {
                    DebugVar("Previous State: ")
                    DebugValue(calculator.previousState?.description ?? "<nil>")
                }
                HStack {
                    DebugVar("Current State: ")
                    DebugValue(calculator.state.description)
                }
                HStack {
                    DebugVar("Operation: ")
                    DebugValue(calculator.operation)
                }
                HStack {
                    DebugVar("Last key pressed: ")
                    DebugValue(calculator.lastKeyPressed ?? "<nil>")
                }
                
            }
        }
    }
}

//struct DebugView_Previews: PreviewProvider {
//    static var previews: some View {
////        DebugView()
//    }
//}
