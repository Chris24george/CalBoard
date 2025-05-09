//
//  Untitled.swift
//  CalBoard
//
//  Created by Chris George on 12/21/24.
//

import SwiftUI

struct Toast: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)
    }
}
