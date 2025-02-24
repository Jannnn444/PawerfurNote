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
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var imageNumer: Int = 1
    @State private var randomNumber: Int = 1
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear // Makes the navbar transparent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Adjust text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func randomImage() {
        randomNumber = Int.random(in: 1...5)
        imageNumer = randomNumber
    }
    
    var body: some View {
        VStack{
            // MARK: - ✅ Cat Image
            Image("cat\(imageNumer)")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
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
                    randomImage()
                    IsLogIn = true
                    notesViewModel.notyetLogin = false
                    byeMsg = ""
                } label: {
                    ZStack{
                        CustomButtonView()
                        Text("Login")
                            .padding()
                            .foregroundColor(.noteAlmond)
                    }
                }
                
                // MARK: - ✅ Log-Out Button
                Button() {
                    randomImage()
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
                            .foregroundColor(.noteAlmond)
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

