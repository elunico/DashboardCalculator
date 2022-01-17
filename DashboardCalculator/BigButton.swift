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
    static let diameter = 45.0
    
    
    var body: some View {

        
         Text(text)
            .frame(width: BigButton.diameter, height: BigButton.diameter, alignment: .center)
            .font(Font.custom("Helvetica Neue", size: 16))
            .background(
                Image("button", bundle: Bundle.main)
                            .resizable()
                            .clipShape(Circle())
            )
            .foregroundColor(Color.gray)
            .clipShape(Circle())
            .onTapGesture {
                delegate.fire(key: text)
            }
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        BigButton(text: "Test", delegate: Calculator())
    }
}
