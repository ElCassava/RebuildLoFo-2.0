//
//  AdminLoginView.swift
//  RebuildLoFo
//
//  Created by Nicholas  on 16/05/25.
//

import SwiftUI

struct AdminLoginView: View {
    // MARK: - State
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginFailed: Bool = false
    @State public var isLoggedIn: Bool
    
    // Replace with real authentication logic
    private let validCredentials = (username: "Admin", password: "password123")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Admin Login")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 40)
                
                // Username Field
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                // Login Button
                Button(action: authenticate) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(username.isEmpty || password.isEmpty)
                
                // Error Message
                if loginFailed {
                    Text("Invalid username or password.")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                }
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $isLoggedIn) {
                AdminDashboard(isLoggedIn: $isLoggedIn)
            }
        }
    }
    
    // MARK: - Authentication Logic
    private func authenticate() {
        // Simple local check (replace with secure service call)
        if username == validCredentials.username && password == validCredentials.password {
            loginFailed = false
            isLoggedIn = true
        } else {
            loginFailed = true
        }
    }
}

// MARK: - Preview
//struct AdminLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminLoginView(isLoggedIn: $isLoggedIn)
//    }
//}


struct AdminLoginView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var isLoggedIn = false

        var body: some View {
            AdminLoginView(isLoggedIn: isLoggedIn)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
