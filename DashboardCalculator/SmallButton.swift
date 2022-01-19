//
//  SmallButton.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct SmallButton: View {
    let text: String
    @ObservedObject var delegate: Calculator
    static let diameter = 27.0
    
    func lookup(_ text: String) -> String {
        switch text {
        case "+":
            return "add"
        case "–":
            return "sub"
        case "⨉":
            return "mult"
        case "÷":
            return "div"
        default:
            return text
        }
    }
    
    var body: some View {
//        let buttonImageName = delegate.isActive(operation: text) ? "SelectedButton" : "button"
        
        var name = lookup(text)
        if delegate.isActive(operation: text) {
            name = "a" + name
        }
        
        return Image(name)
            .frame(alignment: .center)
            .clipShape(Circle())
            .onTapGesture {
                delegate.fire(key: text)
            }
            
    }
}

struct SmallButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallButton(text: "Test", delegate: Calculator())
    }
}
