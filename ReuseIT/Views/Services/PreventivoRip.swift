import PhotosUI
import SwiftUI

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
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Preventivo Riparazione")
                                .font(.largeTitle).bold()
                                .foregroundColor(.primary)
                            Text("Inserisci i dettagli per ricevere una stima dai nostri tecnici.")
                                .font(.subheadline).foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        customTextField(title: "Nome Oggetto*", placeholder: "Es. MacBook Pro, Giacca North Face", text: $nomeOggetto)
                        
                        VStack(alignment: .leading) {
                            Text("Tipologia*").fontWeight(.semibold).padding(.horizontal).foregroundColor(.primary)
                            pickerMenu(selection: $tipologiaScelta, options: tipologie)
                                .onChange(of: tipologiaScelta) {
                                    tipoRiparazioneScelta = "Seleziona tipo"
                                    altraRiparazioneSpecifica = ""
                                }
                        }
                        
                        if tipologiaScelta == "Telefonia" || tipologiaScelta == "Computer" {
                            customTextField(title: "Modello*", placeholder: "Es. iPhone 15 o Dell XPS 13", text: $modello)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Tipo di Riparazione*").fontWeight(.semibold).padding(.horizontal).foregroundColor(.primary)
                            pickerMenu(selection: $tipoRiparazioneScelta, options: opzioniRiparazione[tipologiaScelta] ?? ["Altro"])
                        }
                        
                        if tipoRiparazioneScelta == "Altro" {
                            VStack(alignment: .leading) {
                                Text("Specifica il problema*").font(.caption).fontWeight(.medium).padding(.horizontal).foregroundColor(.blue)
                                TextField("Descrivi brevemente il problema...", text: $altraRiparazioneSpecifica)
                                    .padding()
                                    .background(Color(UIColor.secondarySystemGroupedBackground))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                        }
                        
                        fotoSection
                        
                        Spacer(minLength: 30)
                        
                        NavigationLink(destination: PreventivoIN(oggetto: nomeOggetto,
                                                    tipoRiparazione: tipoRiparazioneScelta == "Altro" ? altraRiparazioneSpecifica : tipoRiparazioneScelta))
                        {
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
            .onChange(of: selectedItems) {
                loadSelectedImages()
            }
        }
    }
    
    // --- Helper UI Aggiornati per Dark Mode ---
    private func customTextField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).fontWeight(.semibold).padding(.horizontal).foregroundColor(.primary)
            TextField(placeholder, text: text)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
    
    private func pickerMenu(selection: Binding<String>, options: [String]) -> some View {
        Menu {
            ForEach(options, id: \.self) { opt in
                Button(opt) { selection.wrappedValue = opt }
            }
        } label: {
            HStack {
                Text(selection.wrappedValue).foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.down").foregroundColor(.secondary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private var fotoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Foto (\(selectedImages.count)/10)").fontWeight(.semibold).foregroundColor(.primary)
                if isUploading { ProgressView().padding(.leading, 5) }
            }
            .padding(.horizontal)
            
            if selectedImages.isEmpty {
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Tocca per caricare fino a 10 foto")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(.secondary.opacity(0.3))
                    )
                    .padding(.horizontal)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0 ..< selectedImages.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                Button(action: { removeImage(at: index) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .red)
                                        .font(.title2)
                                        .background(Circle().fill(.white).frame(width: 15, height: 15))
                                }
                                .padding(5)
                            }
                        }
                        
                        if selectedImages.count < 10 {
                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10 - selectedImages.count, matching: .images) {
                                VStack(spacing: 5) {
                                    Image(systemName: "plus").font(.title2).bold()
                                    Text("Aggiungi").font(.system(size: 12, weight: .semibold))
                                }
                                .foregroundColor(.blue)
                                .frame(width: 120, height: 120)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                                        .foregroundColor(.blue.opacity(0.5))
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                }
            }
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
            await MainActor.run {
                selectedImages.append(contentsOf: loaded)
                selectedItems.removeAll()
                isUploading = false
            }
        }
    }
    
    private func removeImage(at index: Int) {
        selectedImages.remove(at: index)
    }
    
    var isFormValid: Bool {
        let baseValid = !nomeOggetto.isEmpty && tipoRiparazioneScelta != "Seleziona tipo"
        let altroValid = (tipoRiparazioneScelta == "Altro") ? !altraRiparazioneSpecifica.isEmpty : true
        let modelloValid = (tipologiaScelta == "Telefonia" || tipologiaScelta == "Computer") ? !modello.isEmpty : true
        return baseValid && altroValid && modelloValid && !selectedImages.isEmpty
    }
}
