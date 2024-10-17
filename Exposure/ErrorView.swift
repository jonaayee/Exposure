//
//  ErrorView.swift
//  Exposure
//
//  Created by Jonathan Amburgy on 10/16/24.
//

import SwiftUI

struct ErrorView: View {
    
    let ErrorDatabase: ErrorDatabase
    
    var body: some View {
        Text("error")
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case errorRequired
    }
    
    static var wrapper: ErrorDatabase {
        ErrorDatabase(error: SampleError.errorRequired,
                      code: "1", criticalLevel: .none)
    }
    
    static var previews: some View {
        ErrorView(ErrorDatabase: wrapper)
    }
}
