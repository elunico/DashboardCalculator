//
//  BigButton.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct BigButton: View {
    @State var clicked = false
    let text: String
    let owner: Calculator
    
    func lookup(_ text: String) -> String {
        var name = text
        if name == "." {
            name = "decimal"
        }
        
        if clicked {
            name = "d" + name
        }
        
        return name
    }
    
    
    var body: some View {
            Image(lookup(text))
                .frame( alignment: .center)
                .clipShape(Circle())
                .onTapGesture {
                    owner.fire(key: text)
                }.simultaneousGesture(DragGesture(minimumDistance: 0).onChanged {_ in
                    clicked = true
                }.onEnded({_ in
                    clicked = false
                }))
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        BigButton(text: "Test", owner: Calculator(maxDigits: 11, formatter: format))
    }
}
