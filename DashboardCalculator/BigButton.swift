//
//  BigButton.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct BigButton: View {
    let text: String
    let delegate: Calculator
    static let diameter = 40.0
    
    
    var body: some View {
        Text(text)
            .frame(width: BigButton.diameter, height: BigButton.diameter, alignment: .center)
            .font(.custom("Helvetica Neue Bold", size: 14))
            .background(.white)
            .foregroundColor(Color.gray)
            .clipShape(Circle())
            .onTapGesture {
                delegate.updateExpression(symbol: text)
            }
    }
}

//struct BigButton_Previews: PreviewProvider {
//    static var previews: some View {
////        BigButton(text: "Test") { print("Test") }
//    }
//}
