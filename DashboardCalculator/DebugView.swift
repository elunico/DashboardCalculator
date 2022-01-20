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
            .frame(width: 200, alignment: .trailing)
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
            .frame(maxWidth:.infinity, alignment: .leading)
    }
}

struct DebugProperty: View {
    let key: String
    let value: Any?
    var body: some View {
        HStack {
            DebugVar(key + ": ")
            DebugValue(String(describing: (value ?? "<nil>")))
        }
    }
}

struct DebugView: View {
    @ObservedObject var calculator: Calculator
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                DebugProperty(key: "Previous Expression", value: calculator.previousExpression)
                DebugProperty(key: "Current Expression", value: calculator.currentExpression)
                DebugProperty(key: "Previous State", value: calculator.previousState)
                DebugProperty(key: "Current State", value: calculator.state)
                DebugProperty(key: "Operation", value: calculator.operation)
                DebugProperty(key: "Last Key Pressed", value: calculator.lastKeyPressed)
                DebugProperty(key: "Memory", value: calculator.memory)
            }
        }
    }
}

//struct DebugView_Previews: PreviewProvider {
//    static var previews: some View {
////        DebugView()
//    }
//}
