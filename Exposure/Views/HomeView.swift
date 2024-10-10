//
//  HomeView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/9/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Text("something epic is coming")
                    //building folders
                }
                Spacer()
                HStack { // going to add buttons to actual folders, for now keep them outside.
                    Button {
                        print("add")
                    } label: {
                        Label("add", systemImage: "plus")
                    }
                    Button {
                        print("export")
                    } label: {
                        Label("export", systemImage: "square.and.arrow.up.fill")
                    }
                    Button {
                        print("delete")
                    } label: {
                        Label("delete", systemImage: "trash.fill")
                    }
                    .foregroundStyle(Color.red)
                }
                .padding(.bottom)
            }
            .navigationTitle("Exposure")
        }
    }
}

#Preview {
    HomeView()
}
