//
//  ToastView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 12/6/24.
//

import SwiftUI

struct ToastView: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}

#Preview {
    ToastView(message: "A basic message for a toast!")
}
