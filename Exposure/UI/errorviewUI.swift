//
//  ErrorView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/16/24.
//

import SwiftUI

struct errorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
            VStack {
                HStack{
                    Button {
                        
                    } label: {
                        Image(systemName: "x.square.fill")
                            .foregroundStyle(.gray)
                            .font(.system(size: 32))
                    }
                    Spacer()
                }
                Text("uh oh...")
                    .font(.largeTitle)
                    .bold()
                Text("This is the UI for an error prompt")
                Text("Error Code: ")
                
            }
            .padding()
        }
    }
}

#Preview {
    errorView()
}
