//
//  DashboardCalculatorApp.swift
//  DashboardCalculator
//
//  Created by Thomas Povinelli on 1/16/22.
//

import SwiftUI


@main
struct DashboardCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fixedSize()
                            .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                                for window in NSApplication.shared.windows {
                                    window.standardWindowButton(.zoomButton)?.isEnabled = false
                                }
                            })
        }    .windowStyle(HiddenTitleBarWindowStyle())

            
    }
}
