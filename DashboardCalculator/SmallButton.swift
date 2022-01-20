//
//  SmallButton.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct SmallButton: View {
    let text: String
    @State var clicked = false 
    @ObservedObject var owner: Calculator
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
        case "=":
            return "equal"
        default:
            return text
        }
    }
    
    var body: some View {
        var name = lookup(text)
        
        if owner.isPerformingOperation(representedBy: text) {
            name = "a" + name
        } else if clicked {
            name = "d" + name
        }
        
        return Image(name)
            .frame(alignment: .center)
            .onTapGesture {
                owner.fire(key: text)
            }.simultaneousGesture(DragGesture(minimumDistance: 0).onChanged {_ in
                clicked = true
            }.onEnded({_ in
                clicked = false
            }))
            
    }
}

struct SmallButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallButton(text: "Test", owner: Calculator(maxDigits: 11, formatter: format))
    }
}
