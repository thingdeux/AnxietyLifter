//
//  AnxietyLifterApp.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import SwiftUI

@main
struct AnxietyLifterApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .background(Color.black.opacity(0.9))
                .ignoresSafeArea(.all)
        }
    }
}
