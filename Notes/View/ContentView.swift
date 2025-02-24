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
    @State var byeMsg = ""
    @State var notyetLoginMsg = ""
    
    @State private var username: String = ""  // For first TextField
    @State private var password: String = ""  // For second TextField
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear // Makes the navbar transparent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Adjust text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack{
            // MARK: - ✅ Greetinga
            Text("Hi Welcome to Pawerfur Note 🐾")
                .font(.title2)
                .foregroundColor(.noteMediumDarktea)
                .padding()
            
            // MARK: - ✅ Username TextField
            TextField("Enter username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
            
            // MARK: - ✅ Password TextField
            SecureField("Enter password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
            
            HStack{
                // MARK: - ✅ Log-In Button
                Button() {
                    IsLogIn = true
                    notesViewModel.notyetLogin = false
                    byeMsg = ""
                } label: {
                    ZStack{
                        CustomButtonView()
                        Text("Login")
                            .padding()
                            .foregroundColor(.white)
                    }
                }
                
                // MARK: - ✅ Log-Out Button
                Button() {
                    if  notesViewModel.notyetLogin {
                        byeMsg = "Please log in first! "
                    } else {
                        IsLogIn = false
                        byeMsg = "Successfully log out!"
                        notesViewModel.notyetLogin = true
                    }
                } label: {
                    ZStack {
                        CustomButtonView()
                        Text("Log out")
                            .padding()
                            .foregroundColor(.white)
                    }
                }
            }
            .fullScreenCover(isPresented: $IsLogIn) {
                NotesView()
            }
            .padding(.top, 30)
            
            Text("\(byeMsg)")
                .font(.body)
                .foregroundColor(.noteMilktea)
                .padding()
        }
    }
}

