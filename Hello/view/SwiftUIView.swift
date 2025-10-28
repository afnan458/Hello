//
//  SwiftUIView.swift
//  Hello
//
//  Created by Afnan hassan on 01/05/1447 AH.
//

import SwiftUI

// This is the main entry point of your application
@main
struct HelloApp: App {
    var body: some Scene {
        WindowGroup {
            // Start directly with the main plants screen
            MyPlants()
            // If you want the entire app to be dark:
            // .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    MyPlants()
    // .preferredColorScheme(.dark)
}
