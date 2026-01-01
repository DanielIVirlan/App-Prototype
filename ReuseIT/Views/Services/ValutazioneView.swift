import PhotosUI
import SwiftUI

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
                            .foregroundColor(.primary)
                        
                        Picker("Categoria", selection: $categoria) {
                            ForEach(categorie, id: \.self) { Text($0) }
                        }
                        
                        Picker("Condizioni", selection: $condizione) {
                            ForEach(condizioni, id: \.self) { Text($0) }
                        }
                        
                        TextEditor(text: $descrizione)
                            .frame(height: 100)
                            .scrollContentBackground(.hidden) // Rende visibile il colore sottostante in Dark Mode
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                    }
                    
                    Section("Foto (\(immaginiSelezionate.count)/10)") {
                        if immaginiSelezionate.isEmpty {
                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                    Text("Tocca per caricare fino a 10 foto")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity).frame(height: 150)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                        .foregroundColor(.secondary.opacity(0.3))
                                )
                            }
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(0 ..< immaginiSelezionate.count, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: immaginiSelezionate[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            Button(action: { immaginiSelezionate.remove(at: index) }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundStyle(.white, .red)
                                                    .font(.title2)
                                                    .background(Circle().fill(.white).frame(width: 15, height: 15))
                                            }
                                            .padding(5)
                                        }
                                    }
                                    
                                    if immaginiSelezionate.count < 10 {
                                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 10 - immaginiSelezionate.count, matching: .images) {
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
                            }
                        }
                    }
                }
                .onChange(of: selectedItems) { oldValue, newValue in
                    caricaImmagini()
                }
                
                // Area pulsante inferiore
                VStack {
                    Button(action: { vaiARisultato = true }) {
                        Text("RICEVI VALUTAZIONE")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(titolo.isEmpty || immaginiSelezionate.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(titolo.isEmpty || immaginiSelezionate.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
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
        Task {
            for item in selectedItems {
                if let data = try? await item.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        if immaginiSelezionate.count < 10 { immaginiSelezionate.append(uiImage) }
                    }
                }
            }
            selectedItems.removeAll()
        }
    }
}
