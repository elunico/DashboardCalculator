//
//  Calculator.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import Foundation

protocol Calculator {
    func updateExpression(symbol: String)
    
    func operate(with symbol: String)
    
    func computeOperation() 
}
