import SwiftUI

struct OpzioniVendita: View {
    
    @State private var vaiAlMenu = false
    @State private var mostraConfermaQR = false
    @State private var vaiAQRCodes = false
    @State private var codiceTemporaneo = "554-129"
    
    @State private var selectedOption: DeliveryOption? = nil
    @State private var price: String = ""
    @State private var showingMap: Bool = false
    
    @State private var via: String = ""
    @State private var cap: String = ""
    @State private var internoECivico: String = ""
    @State private var lockerSceltoInfo: String = ""

    @Environment(\.dismiss) var dismiss
    
    var isFormValid: Bool {
        guard let option = selectedOption, !price.isEmpty else { return false }
        if option == .locker || option == .safeZone {
            return !lockerSceltoInfo.isEmpty
        }
        return true
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        deliveryOptionsSection
                    }
                    
                    VStack {
                        Button(action: {
                            withAnimation { mostraConfermaQR = true }
                        }) {
                            Text("Pubblica Annuncio")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 60)
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    }
                    .background(Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea(.all, edges: .bottom))
                }
            }
            .navigationTitle("")
            .fullScreenCover(isPresented: $mostraConfermaQR) {
                schermataConfermaTemporanea
            }
            .navigationDestination(isPresented: $vaiAQRCodes) {
                QRCodes()
            }
            .navigationDestination(isPresented: $vaiAlMenu) {
                MainMenu(username: "Admin")
            }
        }
    }

    // MARK: - Sotto-Viste
    var deliveryOptionsSection: some View {
        VStack(spacing: 25) {
            Text("Modalità di ritiro")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 40)
            
            VStack(spacing: 15) {
                ForEach(DeliveryOption.allCases, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedOption = option
                            if option != .locker && option != .safeZone {
                                lockerSceltoInfo = ""
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                                .resizable().frame(width: 28, height: 28)
                                .foregroundColor(selectedOption == option ? .blue : .gray)
                            Text(option.rawValue)
                                .font(.title3).fontWeight(.medium)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding().frame(height: 70)
                        .background(Color.white).cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(selectedOption == option ? .blue : .clear, lineWidth: 2))
                    }
                }
            }
            .padding(.horizontal)
            
            if selectedOption == .safeZone || selectedOption == .locker {
                mapViewButton.transition(.opacity)
            }
            
            VStack(spacing: 15) {
                Text("Prezzo").font(.title2).fontWeight(.semibold)
                HStack(spacing: 5) {
                    TextField("0", text: $price)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 35, weight: .bold))
                        .multilineTextAlignment(.center)
                        .frame(width: 120, height: 80)
                        .background(Color.white).cornerRadius(12)
                    Image(systemName: "eurosign.circle.fill")
                        .resizable().frame(width: 45, height: 45).foregroundColor(.blue)
                }
            }
            .padding(.top, 10)
            Spacer(minLength: 20)
        }
    }

    var mapViewButton: some View {
        Button(action: { showingMap = true }) {
            HStack(spacing: 15) {
                Image(systemName: selectedOption == .locker ? "cube.box.fill" : "map.fill")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(lockerSceltoInfo.isEmpty ? (selectedOption == .locker ? "Cerca Locker su Mappe..." : "Scegli sulla mappa...") : "Posizione Selezionata")
                        .fontWeight(.semibold)
                    if !lockerSceltoInfo.isEmpty {
                        Text(lockerSceltoInfo).font(.caption).lineLimit(1)
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
        .fullScreenCover(isPresented: $showingMap) {
            if let option = selectedOption {
                MappaSimulataView(option: option, lockerSelezionato: $lockerSceltoInfo)
            }
        }
    }

    var schermataConfermaTemporanea: some View {
        VStack(spacing: 30) {
            Spacer()
            if selectedOption == .locker {
                Text("Annuncio Pubblicato!").font(.title).bold()
                Image(systemName: "qrcode")
                    .resizable().scaledToFit().frame(width: 200, height: 200)
                    .padding().background(Color.white).cornerRadius(20).shadow(radius: 10)
                
                VStack(spacing: 5) {
                    Text("CODICE DI SBLOCCO").font(.caption2).foregroundColor(.secondary)
                    Text(codiceTemporaneo).font(.system(size: 32, weight: .black, design: .monospaced))
                }
                
                VStack(spacing: 15) {
                    Text("Istruzioni Locker").font(.headline)
                    Text("Usa questo QR al locker scelto per depositare l'oggetto.").font(.subheadline).multilineTextAlignment(.center).padding(.horizontal)
                }
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable().frame(width: 100, height: 100).foregroundColor(.green)
                Text("Annuncio Pubblicato!").font(.largeTitle).bold()
                Text(selectedOption == .safeZone ? "Recati nella Safe Zone scelta." : "Prepara l'oggetto per la spedizione.")
                    .font(.body).multilineTextAlignment(.center).padding(.horizontal)
            }
            Spacer()
        }
        .background(Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                mostraConfermaQR = false
                // Verifichiamo la destinazione dopo la chiusura del cover
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if selectedOption == .locker {
                        vaiAQRCodes = true
                    } else {
                        vaiAlMenu = true
                    }
                }
            }
        }
    }
}
