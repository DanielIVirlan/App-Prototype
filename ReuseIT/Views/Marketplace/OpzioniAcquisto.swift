import SwiftUI
import CoreImage.CIFilterBuiltins

struct OpzioniAcquisto: View {
    @State private var selectedOption: DeliveryOption? = nil
    @State private var price: String = "850"
    @State private var showingMap: Bool = false
    
    @State private var via: String = ""
    @State private var cap: String = ""
    @State private var internoECivico: String = ""
    
    @State private var mostraConferma = false
    @State private var vaiAQRCodes = false
    @State private var vaiAlMenu = false
    @State private var codiceTemporaneo = "ABC-789"
    
    @State private var lockerSceltoInfo: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    // --- Proprietà per il generatore QR ---
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var isFormValid: Bool {
        guard let option = selectedOption else { return false }
        
        if option == .privateHand {
            return !via.isEmpty && !cap.isEmpty && !internoECivico.isEmpty
        }
        
        if option == .locker || option == .safeZone {
            return !lockerSceltoInfo.isEmpty
        }
        
        return true
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 25) {
                            headerSection
                            optionsListSection
                            
                            if selectedOption == .privateHand {
                                addressFieldsSection
                            }
                            
                            if selectedOption == .safeZone || selectedOption == .locker {
                                mapButtonSection
                            }
                            
                            priceSection
                            Spacer(minLength: 20)
                        }
                    }
                    
                    purchaseButtonSection
                }
            }
            .fullScreenCover(isPresented: $mostraConferma) {
                schermataConfermaTemporanea
            }
            .navigationDestination(isPresented: $vaiAQRCodes) {
                QRCodes()
            }
            .navigationDestination(isPresented: $vaiAlMenu) {
                MainMenu(username: "Admin")
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    // --- Funzione per generare il QR Code reale ---
    func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}

// --- Sub-Views ---
extension OpzioniAcquisto {
    private var headerSection: some View {
        Text("Modalità d'Acquisto")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(.primary)
            .padding(.top, 20)
    }
    
    private var optionsListSection: some View {
        VStack(spacing: 15) {
            ForEach(DeliveryOption.allCases, id: \.self) { option in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedOption = option
                        lockerSceltoInfo = ""
                    }
                }) {
                    HStack {
                        Image(systemName: selectedOption == option ? "checkmark.circle.fill" : "circle")
                            .resizable().frame(width: 28, height: 28)
                            .foregroundColor(selectedOption == option ? .blue : .secondary)
                        Text(option.rawValue)
                            .font(.title3).fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding().frame(height: 70)
                    .background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(selectedOption == option ? .blue : .clear, lineWidth: 2))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var addressFieldsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Indirizzo di Spedizione")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Group {
                TextField("Via e numero civico", text: $via)
                TextField("CAP", text: $cap).keyboardType(.numberPad)
                TextField("Interno e Scala", text: $internoECivico)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal)
        .transition(.opacity)
    }
    
    private var mapButtonSection: some View {
        Button(action: { showingMap = true }) {
            HStack(spacing: 15) {
                Image(systemName: selectedOption == .locker ? "cube.box.fill" : "map.fill")
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(lockerSceltoInfo.isEmpty ? (selectedOption == .locker ? "Cerca Locker su Mappe..." : "Scegli sulla mappa...") : "Posizione Selezionata")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if !lockerSceltoInfo.isEmpty {
                        Text(lockerSceltoInfo)
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                Image(systemName: "arrow.up.right.square").foregroundColor(.secondary)
            }
            .padding().frame(minHeight: 60)
            .background(Color.blue.opacity(0.15)).cornerRadius(12)
            .foregroundColor(.blue)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.3), lineWidth: 1))
        }
        .padding(.horizontal)
        .transition(.opacity)
        .fullScreenCover(isPresented: $showingMap) {
            if let option = selectedOption {
                MappaSimulataView(option: option, lockerSelezionato: $lockerSceltoInfo)
            }
        }
    }
    
    private var priceSection: some View {
        VStack(spacing: 15) {
            Text("Prezzo")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            HStack(spacing: 5) {
                TextField("30", text: $price)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 35, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(width: 120, height: 80)
                    .background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
                    .disabled(true)
                
                Image(systemName: "eurosign.circle.fill")
                    .resizable().frame(width: 45, height: 45).foregroundColor(.blue)
            }
        }
        .padding(.top, 10)
    }
    
    private var purchaseButtonSection: some View {
        VStack {
            Button(action: {
                withAnimation { mostraConferma = true }
            }) {
                Text("Acquista")
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
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea(.all, edges: .bottom))
    }
    
    var schermataConfermaTemporanea: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if selectedOption == .locker {
                Text("Acquisto Completato!")
                    .font(.title).bold()
                    .foregroundColor(.primary)
                
                // --- QR CODE REALE ---
                if let qrImage = generateQRCode(from: codiceTemporaneo) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color.white) // Fondo bianco per scanner
                        .cornerRadius(20)
                        .shadow(radius: 10)
                }
                
                VStack(spacing: 5) {
                    Text("CODICE DI RITIRO").font(.caption2).foregroundColor(.secondary)
                    Text(codiceTemporaneo)
                        .font(.system(size: 32, weight: .black, design: .monospaced))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 15) {
                    Text("Istruzioni Ritiro").font(.headline).foregroundColor(.primary)
                    Text("Usa questo QR al locker per ritirare il tuo oggetto.").font(.subheadline).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.secondary)
                    Text("Consultabile nella sezione 'QR Code' del menu.").font(.caption).foregroundColor(.blue)
                }
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable().frame(width: 100, height: 100).foregroundColor(.green)
                Text("Ordine Effettuato!")
                    .font(.largeTitle).bold()
                    .foregroundColor(.primary)
                Text(selectedOption == .safeZone ? "Incontra il venditore nella Safe Zone scelta." : "L'oggetto verrà spedito al tuo domicilio.")
                    .font(.body).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                mostraConferma = false
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
