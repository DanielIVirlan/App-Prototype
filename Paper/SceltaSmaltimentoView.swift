import SwiftUI

struct SceltaSmaltimentoView: View {
    // Usiamo DeliveryOption per coerenza con il resto del tuo codice
    @State private var opzioneScelta: DeliveryOption? = nil
    @State private var lockerInfo = ""
    @State private var mostraMappa = false
    @State private var messaggioConferma: String? = nil
    @State private var tornaAlMenu = false
    @State private var mostraAlert = false

    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
            
            // Navigazione invisibile per tornare al menu
            NavigationLink(destination: MainMenu(username: "Admin"), isActive: $tornaAlMenu) { EmptyView() }

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 25) {
                        Text("Modalità di smaltimento")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                        
                        // --- SEZIONE OPZIONI (Stile OpzioniVendita) ---
                        VStack(spacing: 15) {
                            ForEach(DeliveryOption.allCases, id: \.self) { option in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        opzioneScelta = option
                                        if option != .locker && option != .safeZone {
                                            lockerInfo = ""
                                        }
                                    }
                                }) {
                                    HStack {
                                        // Cerchio di selezione a sinistra
                                        Image(systemName: opzioneScelta == option ? "checkmark.circle.fill" : "circle")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                            .foregroundColor(opzioneScelta == option ? .blue : .gray)
                                        
                                        Text(option.rawValue)
                                            .font(.title3)
                                            .fontWeight(.medium)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(height: 70)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    // Bordo blu se selezionato
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(opzioneScelta == option ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Bottone Mappa Dinamico
                        if opzioneScelta == .locker || opzioneScelta == .safeZone {
                            mapViewButton.transition(.opacity)
                        }
                    }
                }

                // --- AREA BOTTONI NATIVI IN BASSO ---
                VStack(spacing: 15) {
                    Button(action: {
                        messaggioConferma = "Oggetto aggiunto con successo all'Archivio Ricordi!"
                        mostraAlert = true
                    }) {
                        HStack {
                            Image(systemName: "archivebox.fill")
                            Text("Aggiungi all'Archivio Ricordi")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                    }

                    Button(action: {
                        messaggioConferma = "Richiesta di smaltimento confermata!"
                        mostraAlert = true
                    }) {
                        Text("CONFERMA SMALTIMENTO")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .disabled(!isFormValid)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .background(Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea())
            }
        }
        .navigationTitle("")
        .alert("Completato", isPresented: $mostraAlert) {
            Button("OK") {
                if messaggioConferma == "Richiesta di smaltimento confermata!" {
                    tornaAlMenu = true
                }
            }
        } message: {
            if let messaggio = messaggioConferma { Text(messaggio) }
        }
    }

    // Validazione della Form
    var isFormValid: Bool {
        guard let option = opzioneScelta else { return false }
        if option == .locker || option == .safeZone {
            return !lockerInfo.isEmpty
        }
        return true
    }

    // Bottone Mappa (Stile OpzioniVendita)
    var mapViewButton: some View {
        Button(action: { mostraMappa = true }) {
            HStack(spacing: 15) {
                Image(systemName: opzioneScelta == .locker ? "cube.box.fill" : "map.fill")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(lockerInfo.isEmpty ? (opzioneScelta == .locker ? "Cerca Locker su Mappe..." : "Scegli sulla mappa...") : "Posizione Selezionata")
                        .fontWeight(.semibold)
                    if !lockerInfo.isEmpty {
                        Text(lockerInfo).font(.caption).lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "arrow.up.right.square")
            }
            .padding().frame(minHeight: 60)
            .background(Color.blue.opacity(0.1)).cornerRadius(12)
            .foregroundColor(.blue)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.3), lineWidth: 1))
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $mostraMappa) {
            if let option = opzioneScelta {
                MappaSimulataView(option: option, lockerSelezionato: $lockerInfo)
            }
        }
    }
}
