//
//  SuccessLoginView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/3/4.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var noteViewModel: NotesViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            
            Text("Sign Up Right now!")
                .padding()
                .background(.noteMilktea)
                .frame(width: 130, height: 80)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.done)
               
            
            TextField("Phone", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }
            
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }
            HStack {
              
                    Button() {
                        hideKeyboard()
// noteViewModel.signup(name: name, email: email, password: password, phone: phone)
                        
                        Task {
                            do {
                                await noteViewModel.signup(name: name, email: email, password: password, phone: phone)
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            // When API works, isCreated will be set true
                            if noteViewModel.isCreated {
                                DispatchQueue.main.async {
                                    alertMessage = "Account Created"
                                    showAlert = true
                                }
                            } else {
                                alertMessage = "Account Created Failed."
                                showAlert = true  // Show alert for failure too
                            }
                        }
                        
                    } label: {
                        ZStack {
                        CustomButtonView()
                        Text("Create")
                            .padding()
                            .foregroundColor(.noteAlmond)
                    }
                }
            }
            
            // NOTE:
            // 1. Remember show alert when it isCreated success. (now)
            // 2. Now we go create a signup func first.(created)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Success Created!"),
                      message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
//                        ContentView()
                    }
              )
            }
        }
    }
}

#Preview {
    SignUpView()
}
