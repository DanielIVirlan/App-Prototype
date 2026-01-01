import SwiftUI
import PhotosUI

struct PreventivoRip: View {
    // --- Variabili Stato Form ---
    @State private var nomeOggetto: String = ""
    @State private var tipologiaScelta: String = "Telefonia"
    @State private var modello: String = ""
    @State private var tipoRiparazioneScelta: String = "Seleziona tipo"
    @State private var altraRiparazioneSpecifica: String = ""
    
    // --- Variabili Foto ---
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isUploading: Bool = false
    
    // --- Liste Dati ---
    let tipologie = ["Telefonia", "Computer", "Elettrodomestici", "Abbigliamento", "Giochi e accessori"]
    
    let opzioniRiparazione: [String: [String]] = [
        "Telefonia": ["Schermo rotto", "Batteria", "Connettore ricarica", "Fotocamera", "Danni da liquidi", "Altro"],
        "Computer": ["Sostituzione SSD/RAM", "Pulizia/Pasta termica", "Tastiera", "Schermo", "Software/Virus", "Altro"],
        "Elettrodomestici": ["Motore", "Scheda elettronica", "Cablaggio", "Guarnizioni", "Altro"],
        "Abbigliamento": ["Cerniera", "Sartoria/Rammendo", "Lavaggio speciale", "Pelle/Calzature", "Altro"],
        "Giochi e accessori": ["Joystick/Controller", "Lettore disco", "Surriscaldamento", "Altro"]
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Preventivo Riparazione")
                                .font(.largeTitle).bold()
                            Text("Inserisci i dettagli per ricevere una stima dai nostri tecnici.")
                                .font(.subheadline).foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 1. NOME OGGETTO
                        customTextField(title: "Nome Oggetto*", placeholder: "Es. MacBook Pro, Giacca North Face", text: $nomeOggetto)
                        
                        // 2. TIPOLOGIA
                        VStack(alignment: .leading) {
                            Text("Tipologia*").fontWeight(.semibold).padding(.horizontal)
                            pickerMenu(selection: $tipologiaScelta, options: tipologie)
                                .onChange(of: tipologiaScelta) {
                                    tipoRiparazioneScelta = "Seleziona tipo"
                                    altraRiparazioneSpecifica = ""
                                }
                        }
                        
                        // 3. MODELLO (Solo per Telefonia o Computer)
                        if tipologiaScelta == "Telefonia" || tipologiaScelta == "Computer" {
                            customTextField(title: "Modello*", placeholder: "Es. iPhone 15 o Dell XPS 13", text: $modello)
                        }
                        
                        // 4. TIPO RIPARAZIONE
                        VStack(alignment: .leading) {
                            Text("Tipo di Riparazione*").fontWeight(.semibold).padding(.horizontal)
                            pickerMenu(selection: $tipoRiparazioneScelta, options: opzioniRiparazione[tipologiaScelta] ?? ["Altro"])
                        }
                        
                        // 4b. CAMPO DINAMICO PER "ALTRO"
                        if tipoRiparazioneScelta == "Altro" {
                            VStack(alignment: .leading) {
                                Text("Specifica il problema*").font(.caption).fontWeight(.medium).padding(.horizontal).foregroundColor(.blue)
                                TextField("Descrivi brevemente il problema...", text: $altraRiparazioneSpecifica)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                        
                        // 5. SEZIONE FOTO
                        fotoSection
                        
                        Spacer(minLength: 30)
                        
                        // 6. TASTO CONTINUA (Naviga verso PreventivoIN)
                        NavigationLink(destination: PreventivoIN(
                            oggetto: nomeOggetto,
                            tipoRiparazione: tipoRiparazioneScelta == "Altro" ? altraRiparazioneSpecifica : tipoRiparazioneScelta
                        )) {
                            Text("CONTINUA")
                                .font(.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 55)
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.4))
                                .cornerRadius(15)
                                .padding(.horizontal)
                        }
                        .disabled(!isFormValid)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .animation(.spring(), value: tipoRiparazioneScelta)
        }
    }

    // --- Helper UI ---
    private func customTextField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).fontWeight(.semibold).padding(.horizontal)
            TextField(placeholder, text: text)
                .padding().background(Color.white).cornerRadius(12).padding(.horizontal)
        }
    }

    private func pickerMenu(selection: Binding<String>, options: [String]) -> some View {
        Menu {
            ForEach(options, id: \.self) { opt in
                Button(opt) { selection.wrappedValue = opt }
            }
        } label: {
            HStack {
                Text(selection.wrappedValue).foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.down").foregroundColor(.gray)
            }
            .padding().background(Color.white).cornerRadius(12).padding(.horizontal)
        }
    }

    private var fotoSection: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("Foto (\(selectedImages.count)/10)").fontWeight(.semibold)
                    if isUploading { ProgressView().padding(.leading, 5) }
                }
                .padding(.horizontal)
                
                if selectedImages.isEmpty {
                    // Stato Vuoto: Bottone Grande
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                        VStack(spacing: 10) {
                            Image(systemName: "camera.fill").font(.largeTitle).foregroundColor(.blue)
                            Text("Tocca per caricare foto").font(.caption).foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity).frame(height: 120)
                        .background(Color.white).cornerRadius(15).padding(.horizontal)
                    }
                } else {
                    // Galleria Orizzontale
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // Ciclo delle foto già caricate
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Button(action: { removeImage(at: index) }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.white, .red)
                                            .background(Circle().fill(.white).frame(width: 12, height: 12))
                                    }
                                    .padding(4)
                                }
                            }
                            
                            // IL TASTO AGGIUNGI (+) alla fine della lista
                            if selectedImages.count < 10 {
                                PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                                    VStack(spacing: 5) {
                                        Image(systemName: "plus")
                                            .font(.title2)
                                            .bold()
                                        Text("Aggiungi")
                                            .font(.system(size: 10, weight: .semibold))
                                    }
                                    .foregroundColor(.blue)
                                    .frame(width: 100, height: 100)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                            .foregroundColor(.blue.opacity(0.5))
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onChange(of: selectedItems) {
                loadSelectedImages()
            }
        }

    private func loadSelectedImages() {
        isUploading = true
        Task {
            var loaded: [UIImage] = []
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
                    loaded.append(img)
                }
            }
            await MainActor.run { selectedImages = loaded; isUploading = false }
        }
    }

    private func removeImage(at index: Int) {
        selectedImages.remove(at: index)
        selectedItems.remove(at: index)
    }

    var isFormValid: Bool {
        let baseValid = !nomeOggetto.isEmpty && tipoRiparazioneScelta != "Seleziona tipo"
        let altroValid = (tipoRiparazioneScelta == "Altro") ? !altraRiparazioneSpecifica.isEmpty : true
        let modelloValid = (tipologiaScelta == "Telefonia" || tipologiaScelta == "Computer") ? !modello.isEmpty : true
        return baseValid && altroValid && modelloValid
    }
}
