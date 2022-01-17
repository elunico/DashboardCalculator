//
//  DashboardCalculatorApp.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
}

func main() {
    print("First thing")
    if #available(macOS 11.0, *) {
        @main
        struct DashboardCalculatorApp: App {
            var body: some Scene {
                WindowGroup {
                    ContentView()
                }
            }
        }
    } else {
        print("Trying Delegate")
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        print("Running")
        app.run()
        
    }
}


