//
//  ContentView.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

struct ContentView: View, Calculator {
    
    @State var currentExpression: String = "0"
    
    var body: some View {
        
        
        return GeometryReader { geometry in
            VStack() {
                
                Text(currentExpression)
                    .frame(width: 178, height: 40, alignment: .trailing)
                    .font(.custom("Seven Segment", size: 26)).padding(3)
                    .background(Color.cyan)
                    .foregroundColor(.black)
                HStack {
                    SmallButton(text: "m+", delegate: self)
                    SmallButton(text: "m-", delegate: self)
                    SmallButton(text: "mc", delegate: self)
                    SmallButton(text: "mr", delegate: self)
                    SmallButton(text: "÷", delegate: self)
                }
                Spacer()
                    .frame(width: 200, height: 5, alignment: .center)
                    .background(.orange)
                    .padding(0.1)
                HStack {
                    BigButton(text: "7", delegate: self)
                    BigButton(text: "8", delegate: self)
                    BigButton(text: "9", delegate: self)
                    SmallButton(text: "⨉", delegate: self)
                }
                HStack {
                    BigButton(text: "4", delegate: self)
                    BigButton(text: "5", delegate: self)
                    BigButton(text: "6", delegate: self)
                    SmallButton(text: "–", delegate: self)
                }
                HStack {
                    BigButton(text: "1", delegate: self)
                    BigButton(text: "2", delegate: self)
                    BigButton(text: "3", delegate: self)
                    SmallButton(text: "+", delegate: self)
                }
                HStack {
                    BigButton(text: "0", delegate: self)
                    BigButton(text: ".", delegate: self)
                    BigButton(text: "c", delegate: self)
                    Text("=")
                        .frame(width: SmallButton.diameter, height: 50.0, alignment: .center)
                        .font(.custom("Monaco", size: 10))
                        .background(.white)
                        .foregroundColor(Color.gray)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: SmallButton.diameter/2, height: SmallButton.diameter/2)))
                        .onTapGesture {
                            
                        }
                }
            }.frame(width: 200.0, height: 300.0, alignment: .center)
                .background(Color.gray)
        }.frame(width: 210, height: 310, alignment: .center)
            .background(.orange)
    }
    
    func updateExpression(symbol: String) {
        if "1234567890".contains(symbol) {
            currentExpression = currentExpression + symbol
        } else if "+-⨉÷".contains(symbol) {
            operate(with: symbol)
        } else if symbol == "c" {
            currentExpression = "0"
        } else if symbol == "=" {
            computeOperation()
        }
    }
    
    func operate(with symbol: String) {
        
    }
    
    func computeOperation() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
