import SwiftUI
import PhotosUI

struct CreazioneAnnuncio: View {
    // --- Variabili per i dati del form ---
    @State private var titolo: String = ""
    @State private var condizioneScelta: String = "Nuovo"
    @State private var categoriaScelta: String = "Elettronica"
    @State private var comune: String = ""
    @State private var descrizione: String = ""
    @State private var tipoAnnuncio: String = "Vendita"
    
    // --- Variabili per le FOTO ---
    @State private var selectedItems: [PhotosPickerItem] = [] // Elementi selezionati
    @State private var selectedImages: [UIImage] = []        // Immagini caricate
    @State private var isUploading: Bool = false             // Stato per la ProgressView
    
    // Liste per i menu
    let condizioni = ["Nuovo", "Come nuovo", "Buone condizioni", "Usurato"]
    let categorie = ["Elettronica", "Abbigliamento", "Arredamento", "Libri", "Altro"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Nuovo Annuncio")
                            .font(.system(size: 30, weight: .bold))
                            .padding(.top)
                            .padding(.horizontal)
                        
                        // 1. TITOLO
                        Group {
                            Text("Titolo*").fontWeight(.semibold).padding(.horizontal)
                            TextField("Es. iPhone 13 Pro", text: $titolo)
                                .padding()
                                .background(Color.white).cornerRadius(12)
                                .padding(.horizontal)
                        }
                        
                        // 2. DETTAGLI (Condizione e Categoria)
                        Group {
                            Text("Dettagli*").fontWeight(.semibold).padding(.horizontal)
                            HStack(spacing: 15) {
                                Menu {
                                    ForEach(condizioni, id: \.self) { cond in
                                        Button(cond) { condizioneScelta = cond }
                                    }
                                } label: {
                                    HStack {
                                        Text(condizioneScelta).foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.down").foregroundColor(.gray)
                                    }
                                    .padding().background(Color.white).cornerRadius(12)
                                }
                                
                                Menu {
                                    ForEach(categorie, id: \.self) { cat in
                                        Button(cat) { categoriaScelta = cat }
                                    }
                                } label: {
                                    HStack {
                                        Text(categoriaScelta).foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.down").foregroundColor(.gray)
                                    }
                                    .padding().background(Color.white).cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // 3. AGGIUNGI FOTO (MULTIPLE)
                        Group {
                            HStack {
                                Text("Foto (\(selectedImages.count)/10)").fontWeight(.semibold)
                                if isUploading {
                                    ProgressView()
                                        .padding(.leading, 5)
                                }
                            }
                            .padding(.horizontal)
                            
                            if selectedImages.isEmpty {
                                // Stato Vuoto: Bottone grande
                                PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.blue)
                                        Text("Tocca per caricare fino a 10 foto")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 150)
                                    .background(Color.white)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .foregroundColor(.gray.opacity(0.5))
                                    )
                                    .padding(.horizontal)
                                }
                            } else {
                                // Galleria Orizzontale con foto selezionate
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(0..<selectedImages.count, id: \.self) { index in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: selectedImages[index])
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                
                                                // Tasto X per rimuovere
                                                Button(action: {
                                                    removeImage(at: index)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundStyle(.white, .red)
                                                        .font(.title2)
                                                        .background(Circle().fill(.white).frame(width: 15, height: 15))
                                                        .padding(5)
                                                }
                                            }
                                        }
                                        
                                        // Bottone "Aggiungi altre" se < 10
                                        if selectedImages.count < 10 {
                                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                                                VStack {
                                                    Image(systemName: "plus")
                                                        .font(.title)
                                                    Text("Aggiungi")
                                                        .font(.caption)
                                                }
                                                .frame(width: 120, height: 120)
                                                .background(Color.white)
                                                .foregroundColor(.blue)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                                                        .foregroundColor(.blue)
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
                        
                        // 4. TIPO ANNUNCIO
                        Group {
                            Text("Tipo annuncio*").fontWeight(.semibold).padding(.horizontal)
                            HStack(spacing: 0) {
                                Button(action: { withAnimation { tipoAnnuncio = "Vendita" } }) {
                                    Text("Vendita").fontWeight(.bold).frame(maxWidth: .infinity).padding()
                                        .background(tipoAnnuncio == "Vendita" ? Color.blue : Color.white)
                                        .foregroundColor(tipoAnnuncio == "Vendita" ? .white : .black)
                                }
                                Button(action: { withAnimation { tipoAnnuncio = "Regalo" } }) {
                                    Text("Regalo").fontWeight(.bold).frame(maxWidth: .infinity).padding()
                                        .background(tipoAnnuncio == "Regalo" ? Color.blue : Color.white)
                                        .foregroundColor(tipoAnnuncio == "Regalo" ? .white : .black)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.05), radius: 2)
                            .padding(.horizontal)
                        }
                        
                        // 5. COMUNE
                        Group {
                            Text("Comune*").fontWeight(.semibold).padding(.horizontal)
                            TextField("Es. Milano, Roma...", text: $comune)
                                .padding().background(Color.white).cornerRadius(12).padding(.horizontal)
                        }
                        
                        // 6. DESCRIZIONE
                        Group {
                            Text("Descrizione").fontWeight(.semibold).padding(.horizontal)
                            TextEditor(text: $descrizione)
                                .frame(height: 100)
                                .padding(5)
                                .background(Color.white).cornerRadius(12).padding(.horizontal)
                        }
                        
                        Spacer(minLength: 40)
                        
                        
                       
                        
                        NavigationLink(destination: OpzioniVendita()) {
                            Text("CONTINUA")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 60)
                                .background(isFormValid ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(15).shadow(radius: 5)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal).padding(.bottom, 20)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    // --- Logica per caricare le immagini ---
    private func loadSelectedImages() {
        isUploading = true
        Task {
            var newlyLoadedImages: [UIImage] = []
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        newlyLoadedImages.append(uiImage)
                    }
                }
            }
            await MainActor.run {
                selectedImages = newlyLoadedImages
                isUploading = false
            }
        }
    }
    
    // --- Logica per rimuovere un'immagine ---
    private func removeImage(at index: Int) {
        selectedImages.remove(at: index)
        selectedItems.remove(at: index) 
    }
    
    var isFormValid: Bool {
        return !titolo.isEmpty && !comune.isEmpty && !selectedImages.isEmpty
    }
}

// Preview
struct CreazioneAnnuncio_Previews: PreviewProvider {
    static var previews: some View {
        CreazioneAnnuncio()
    }
}
