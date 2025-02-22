//
//  ContentView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel
    @State var IsLogIn: Bool = false

    var body: some View {
        VStack{
            if IsLogIn {
                NotesView()
                    .background(.black)
            } else {
                Text("Please log in first ... ")
                    .font(.body)
                    .foregroundColor(.noteMilktea)
            }
            
            Button() {
                IsLogIn = true
            } label: {
                Text("Login")
                    .padding()
                    .foregroundColor(.noteIcyGrey)
                    .background(.noteDarktea, in: .capsule)
                    .frame(width: 80, height: 50)
//                    .cornerRadius(30)
            }
        }
    }
}
