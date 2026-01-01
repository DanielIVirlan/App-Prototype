import SwiftUI
import PhotosUI

struct ValutazioneView: View {
    @State private var titolo = ""
    @State private var descrizione = ""
    @State private var categoria = "Elettronica"
    @State private var condizione = "Buono"
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var immaginiSelezionate: [UIImage] = []
    @State private var vaiARisultato = false
    
    let categorie = ["Elettronica", "Mobili", "Abbigliamento", "Libri", "Altro"]
    let condizioni = ["Nuovo", "Ottimo", "Buono", "Usurato"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { 
                Form {
                    Section("Dati Oggetto") {
                        TextField("Titolo", text: $titolo)
                        Picker("Categoria", selection: $categoria) {
                            ForEach(categorie, id: \.self) { Text($0) }
                        }
                        Picker("Condizioni", selection: $condizione) {
                            ForEach(condizioni, id: \.self) { Text($0) }
                        }
                        TextEditor(text: $descrizione)
                            .frame(height: 100)
                            .overlay(
                                Group {
                                    if descrizione.isEmpty {
                                        Text("Inserisci una descrizione...")
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 5)
                                            .padding(.vertical, 8)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                    
                    Section("Foto") {
                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 3, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                    .foregroundColor(.blue)
                                Text("Aggiungi Foto")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onChange(of: selectedItems) {
                            caricaImmagini()
                        }
                        
                        if !immaginiSelezionate.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(immaginiSelezionate, id: \.self) { img in
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // --- TASTO NATIVO IN BASSO ---
                VStack {
                    Button(action: { vaiARisultato = true }) {
                        Text("RICEVI VALUTAZIONE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(titolo.isEmpty || immaginiSelezionate.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(titolo.isEmpty || immaginiSelezionate.isEmpty)
                    .padding(.horizontal, 20) // Spazio laterale
                    .padding(.top, 10)         // Spazio sopra il tasto
                    .padding(.bottom, 10)      // Spazio sotto il tasto (rispetto alla safe area)
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .navigationTitle("Valuta Oggetto")
            .navigationDestination(isPresented: $vaiARisultato) {
                RisultatoValutazioneView(
                    titolo: titolo,
                    categoria: categoria,
                    condizione: condizione,
                    immagini: immaginiSelezionate
                )
            }
        }
    }
    
    func caricaImmagini() {
        for item in selectedItems {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    await MainActor.run {
                        self.immaginiSelezionate.append(img)
                    }
                }
            }
        }
    }
}
