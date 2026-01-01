import SwiftUI
import CoreImage.CIFilterBuiltins

struct SelezionePrev: View {
    let preventivo: Preventivo
    let tipoRiparazione: String
    
    @State private var consegnaScelta = "Privata/Mano"
    @State private var mostraMappa = false
    
    // --- Variabili Domicilio ---
    @State private var via: String = ""
    @State private var civico: String = ""
    @State private var internoScala: String = ""
    @State private var cap: String = ""
    
    // --- Variabile Locker ---
    @State private var lockerSceltoInfo: String = ""
    
    // --- Variabili di Navigazione ---
    @State private var mostraConferma = false
    @State private var vaiAQRCodes = false
    @State private var vaiAlMenu = false
    @State private var codiceTemporaneo = "REP-552"
    
    @Environment(\.dismiss) var dismiss
    
    // --- Proprietà per il generatore QR ---
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var professioneTecnico: String {
        let riparazione = tipoRiparazione.lowercased()
        if riparazione.contains("schermo") || riparazione.contains("batteria") { return "Tecnico Hardware Mobile" }
        else if riparazione.contains("pc") { return "Sistemista PC" }
        else { return "Specialista Certificato" }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // --- LOGO E INTESTAZIONE ---
                        VStack(spacing: 10) {
                            Image(systemName: preventivo.logoDitta)
                                .font(.system(size: 40)).foregroundColor(.blue)
                                .frame(width: 90, height: 90)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .clipShape(Circle()).shadow(color: .black.opacity(0.1), radius: 5)
                            
                            Text(preventivo.nomeDitta)
                                .font(.title3).fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .padding(.top)
                        
                        // --- SCHEDA POSIZIONE SEDE ---
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse").foregroundColor(.red)
                                Text("Sede dell'intervento").fontWeight(.bold).foregroundColor(.primary)
                            }
                            Divider()
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(preventivo.via), \(preventivo.civico)")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Distanza da te: \(preventivo.distanza, specifier: "%.1f") km")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.turn.up.right.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue.opacity(0.7))
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // --- SCHEDA RIPARATORE ---
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person.badge.shield.check.fill").foregroundColor(.blue)
                                Text("Riparatore incaricato").fontWeight(.bold).foregroundColor(.primary)
                            }
                            Divider()
                            Group {
                                HStack(spacing: 2) {
                                    Text("Nome: ").foregroundColor(.secondary)
                                    Text("Marco Rossi").bold().foregroundColor(.primary)
                                }
                                HStack(spacing: 2) {
                                    Text("Professione: ").foregroundColor(.secondary)
                                    Text("\(professioneTecnico)").bold().foregroundColor(.primary)
                                }
                                HStack(spacing: 2) {
                                    Text("Esperienza: ").foregroundColor(.secondary)
                                    Text("8 anni").bold().foregroundColor(.primary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // --- SEZIONE CONSEGNA OGGETTO ---
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Modalità di consegna oggetto").fontWeight(.semibold).padding(.horizontal).foregroundColor(.primary)
                            
                            Picker("Consegna", selection: $consegnaScelta) {
                                Text("A mano").tag("Privata/Mano")
                                Text("A domicilio").tag("Ritiro a domicilio")
                                Text("Locker").tag("Locker")
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            
                            if consegnaScelta == "Locker" {
                                Button(action: { mostraMappa = true }) {
                                    HStack(spacing: 15) {
                                        Image(systemName: "cube.box.fill").font(.title2).foregroundColor(.blue)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(lockerSceltoInfo.isEmpty ? "Scegli Locker sulla mappa" : "Locker Selezionato").font(.subheadline).bold().foregroundColor(.primary)
                                            if !lockerSceltoInfo.isEmpty {
                                                Text(lockerSceltoInfo).font(.caption).foregroundColor(.secondary)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(12).shadow(color: .black.opacity(0.05), radius: 5)
                                }
                                .padding(.horizontal)
                            }
                            
                            if consegnaScelta == "Ritiro a domicilio" {
                                VStack(spacing: 12) {
                                    TextField("Via / Piazza", text: $via)
                                        .padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(10)
                                    HStack {
                                        TextField("Civico", text: $civico)
                                            .padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(10)
                                        TextField("Interno / Scala", text: $internoScala)
                                            .padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(10)
                                    }
                                    TextField("CAP", text: $cap)
                                        .keyboardType(.numberPad)
                                        .padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(10)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 40)
                        
                        // --- TASTO CONTINUA ---
                        Button(action: {
                            withAnimation { mostraConferma = true }
                        }) {
                            Text("CONTINUA").font(.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 55)
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5)).cornerRadius(15)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Riepilogo Scelta")
            .fullScreenCover(isPresented: $mostraMappa) {
                MappaSimulataView(option: .locker, lockerSelezionato: $lockerSceltoInfo)
            }
            .fullScreenCover(isPresented: $mostraConferma) {
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
    
    var isFormValid: Bool {
        if consegnaScelta == "Ritiro a domicilio" { return !via.isEmpty && !civico.isEmpty && !cap.isEmpty }
        if consegnaScelta == "Locker" { return !lockerSceltoInfo.isEmpty }
        return true
    }

    var schermataConfermaTemporanea: some View {
        VStack(spacing: 30) {
            Spacer()
            if consegnaScelta == "Locker" {
                Text("Riparazione Prenotata!").font(.title).bold().foregroundColor(.primary)
                
                // --- SEZIONE QR CODE REALE ---
                if let qrImage = generateQRCode(from: codiceTemporaneo) {
                    Image(uiImage: qrImage)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color.white) // Fondo bianco necessario per lettura
                        .cornerRadius(20).shadow(radius: 10)
                }
                
                VStack(spacing: 5) {
                    Text("CODICE CONSEGNA").font(.caption2).foregroundColor(.secondary)
                    Text(codiceTemporaneo).font(.system(size: 32, weight: .black, design: .monospaced)).foregroundColor(.primary)
                }
                
                VStack(spacing: 15) {
                    Text("Istruzioni").font(.headline).foregroundColor(.primary)
                    Text("Deposita l'oggetto nel locker scelto usando questo QR.").font(.subheadline).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.secondary)
                    Text("Consultabile nella sezione 'QR Code' del menu.").font(.caption).foregroundColor(.blue)
                }
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .resizable().frame(width: 100, height: 100).foregroundColor(.green)
                Text("Richiesta Inviata!").font(.largeTitle).bold().foregroundColor(.primary)
                Text(consegnaScelta == "Privata/Mano" ? "Il tecnico ti contatterà per concordare l'orario di consegna." : "Il corriere passerà al tuo domicilio entro 24h.")
                    .font(.body).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.secondary)
            }
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                mostraConferma = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if consegnaScelta == "Locker" { vaiAQRCodes = true } else { vaiAlMenu = true }
                }
            }
        }
    }
}
