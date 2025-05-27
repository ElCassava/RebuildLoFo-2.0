//
//  Color.swift
//  RebuildLoFo
//
//  Created by Nicholas  on 13/05/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        // Clean up the hex string
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove the leading '#' if present
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // Ensure the hex string is valid
        guard hexString.count == 6 else {
            // Default to red color if the hex code is not valid
            self.init(red: 1.0, green: 0.0, blue: 0.0)
            return
        }
        
        // Extract RGB values
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        // Initialize the color with extracted RGB values
        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: 1.0 // Default opacity (fully opaque)
        )
    }
}

