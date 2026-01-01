import SwiftUI
import CoreImage.CIFilterBuiltins

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
    
    // Proprietà per la generazione del QR
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
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
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
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
                    .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea(.all, edges: .bottom))
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
    
    // MARK: - Funzione Generatore QR
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
    
    // MARK: - Sotto-Viste
    var deliveryOptionsSection: some View {
        VStack(spacing: 25) {
            Text("Modalità di ritiro")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 40)
            
            VStack(spacing: 15) {
                ForEach(DeliveryOption.allCases, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring()) {
                            if selectedOption != option {
                                lockerSceltoInfo = ""
                            }
                            selectedOption = option
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
            
            if selectedOption == .safeZone || selectedOption == .locker {
                mapViewButton.transition(.opacity)
            }
            
            VStack(spacing: 15) {
                Text("Prezzo")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                HStack(spacing: 5) {
                    TextField("0", text: $price)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 35, weight: .bold))
                        .multilineTextAlignment(.center)
                        .frame(width: 120, height: 80)
                        .background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
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
                        .foregroundColor(.primary)
                    if !lockerSceltoInfo.isEmpty {
                        Text(lockerSceltoInfo).font(.caption).lineLimit(1).foregroundColor(.secondary)
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
                Text("Annuncio Pubblicato!")
                    .font(.title).bold()
                    .foregroundColor(.primary)
                
                // --- SEZIONE QR CODE REALE ---
                if let qrImage = generateQRCode(from: codiceTemporaneo) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20).shadow(radius: 10)
                }
                
                VStack(spacing: 5) {
                    Text("CODICE DI SBLOCCO").font(.caption2).foregroundColor(.secondary)
                    Text(codiceTemporaneo)
                        .font(.system(size: 32, weight: .black, design: .monospaced))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 15) {
                    Text("Istruzioni Locker").font(.headline).foregroundColor(.primary)
                    Text("Usa questo QR al locker scelto per depositare l'oggetto.").font(.subheadline).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.secondary)
                }
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable().frame(width: 100, height: 100).foregroundColor(.green)
                Text("Annuncio Pubblicato!")
                    .font(.largeTitle).bold()
                    .foregroundColor(.primary)
                Text(selectedOption == .safeZone ? "Recati nella Safe Zone scelta." : "Prepara l'oggetto per la spedizione.")
                    .font(.body).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.secondary)
            }
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                mostraConfermaQR = false
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
