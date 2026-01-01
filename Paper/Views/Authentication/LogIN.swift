import SwiftUI




struct LogIN: View {
    // MARK: - Variabili di Stato
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    // Lo stato che tiene traccia se l'utente ha fatto l'accesso
    @State private var isLoggedIn: Bool = false
    @State private var showingAlert: Bool = false
    
    // Credenziali Fisse
    private let validUsername = "daniel"
    private let validPassword = "admin"
    
    // MARK: - Corpo della View
    
    var body: some View {
        NavigationStack {
            // Se l'utente è loggato, mostra la vista CreazioneAnnuncio
            if isLoggedIn {
                
                CreazioneAnnuncioWrapper(username: username) // Un wrapper per la view di destinazione
            } else {
                // Schermata di Login
                ZStack {
                    // Sfondo
                    Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        
                        Text("Accedi")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 50)
                        
                        
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                placeholder: "Username (\(validUsername))",
                                text: $username,
                                iconName: "person.fill"
                            )
                            
                            CustomSecureField(
                                placeholder: "Password (\(validPassword))",
                                text: $password,
                                iconName: "lock.fill"
                            )
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Pulsante di Login
                        Button(action: {
                            authenticateUser()
                        }) {
                            Text("LOGIN")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 60)
                                .background(isLoginEnabled ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .disabled(!isLoginEnabled)
                        .padding(.horizontal)
                        
                        
                    }
                    .alert("Accesso Fallito", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Username o Password errati. Le credenziali sono '\(validUsername)' e '\(validPassword)'.")
                    }
                }
            }
        }
    }
    
    // MARK: - Funzioni e Variabili Calcolate
    
    var isLoginEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func authenticateUser() {
        if username == validUsername && password == validPassword {
            // Successo: imposta lo stato di login su true
            withAnimation {
                isLoggedIn = true
            }
        } else {
            // Fallimento: mostra l'alert
            showingAlert = true
            password = ""
        }
    }
}

// MARK: - Componenti Riutilizzabili (Mantengono lo stile precedente)


struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .frame(height: 55)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(text.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
        )
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            
            SecureField(placeholder, text: $text)
        }
        .padding()
        .frame(height: 55)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(text.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
        )
    }
}

// MARK: - Wrapper per CreazioneAnnuncio (Sostituisce WelcomeView)


struct CreazioneAnnuncioWrapper: View {
    let username: String // Riceve il nome dal Login
    @State private var showSuccessMessage: Bool = true
    
    var body: some View {
        if showSuccessMessage {
            ZStack {
                Color.blue.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable().frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    Text("Bentornato \(username)!") // Personalizzato
                        .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { showSuccessMessage = false }
                }
            }
        } else {
            // Passa il nome al MainMenu
            MainMenu(username: username)
        }
    }
}

//TEST

// MARK: - Preview

struct LogIN_Previews: PreviewProvider {
    static var previews: some View {
        LogIN()
    }
}




