//
//  SmallButton.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct SmallButton: View {
    let text: String
    let delegate: Calculator
    static let diameter = 27.0
    
    
    var body: some View {
        Text(text)
            .frame(width: SmallButton.diameter, height: SmallButton.diameter, alignment: .center)
            .font(.custom("Helvetica Neue Bold", size: 12))
            .background(Image("button", bundle: Bundle.main)
                            .resizable()
                            .clipShape(Circle()))
            .frame(width: SmallButton.diameter, height: SmallButton.diameter, alignment: .center)
            .foregroundColor(Color.gray)
            .clipShape(Circle())
            .onTapGesture {
                delegate.updateExpression(symbol: text)
            }
            
    }
}

struct SmallButton_Previews: PreviewProvider {
    static var previews: some View {
        SmallButton(text: "Test", delegate: EmptyCalc())
    }
}
