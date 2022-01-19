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
    let delegate: Calculator
    static let diameter = 55.0
    
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
//            .font(Font.custom("Helvetica Neue", size: 16))
//            .background(
//                Image("button", bundle: Bundle.main)
//                            .resizable()
//                            .clipShape(Circle())
//            )
//            .foregroundColor(Color.gray)
            .clipShape(Circle())
            .onTapGesture {
                delegate.fire(key: text)
            }.simultaneousGesture(DragGesture(minimumDistance: 0).onChanged {_ in
                clicked = true
            }.onEnded({_ in
                clicked = false
            }))
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        BigButton(text: "Test", delegate: Calculator())
    }
}
