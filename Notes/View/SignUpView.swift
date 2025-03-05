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
                .frame(width: 100, height: 80)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                }
            
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
//                    noteViewModel.signup()
                    
                } label: {
                    CustomButtonView()
                    Text("Create")
                        .padding()
                        .foregroundColor(.noteAlmond)
                }
            }
            
            // NOTE:
            // 1. Remember show alert when it create success.
            // 2. Now we go create a signup func first.
            
            
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Success!"),
//                      message: Text(alertMessage),
//                      dismissButton: .default(Text("OK")) {
//                         
//                }
//              )
//            }
        }
    }
}

#Preview {
    SignUpView()
}
