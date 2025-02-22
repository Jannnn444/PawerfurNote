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
            // MARK: - ✅ Greetinga
            Text("Hi Welcome to Pawerfur Note 🐾")
                .font(.title2)
                .foregroundColor(.noteMilktea)
                .padding()
            
            // MARK: - ✅ Check Register State
            if IsLogIn {
                NotesView()
                    .background(.black)
            } else {
                Text("Please log in first ... ")
                    .font(.body)
                    .foregroundColor(.noteMilktea)
                    .padding()
            }
            HStack{
                // MARK: - ✅ Log-In Button
                Button() {
                    IsLogIn = true
                } label: {
                    Text("Login")
                        .padding()
                        .frame(width: 120, height: 50)
                        .foregroundColor(.noteIcyGrey)
                        .background(.noteDarktea, in: .capsule)
                        
                }
                // MARK: - ✅ Log-Out Button
                Button() {
                    IsLogIn = false
                } label: {
                    Text("Log out")
                        .padding()
                        .frame(width: 120, height: 50)
                        .foregroundColor(.noteIcyGrey)
                        .background(.noteDarktea, in: .capsule)
                        
                }
            }
        }
        .ignoresSafeArea()
    }
}

