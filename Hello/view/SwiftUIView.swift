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
            // The first view to be displayed when the app launches
            myplants()
            // Ensure the entire app adopts the dark color scheme if desired
           
        // .preferredColorScheme(.dark)
        
        }
    }
}

#Preview {
    myplants()
    // .preferredColorScheme(.dark)
}
