import SwiftUI
import PhotosUI

struct Ricordo: Identifiable {
    let id = UUID()
    var nome: String
    var descrizione: String
    var immagini: [UIImage] // Array per gestire più foto
}

struct Archivio: View {
    @State private var ricordi: [Ricordo] = []
    @State private var mostraAggiungi = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if ricordi.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "archivebox").font(.system(size: 60)).foregroundColor(.gray)
                        Text("Il tuo archivio è vuoto").foregroundColor(.secondary)
                        Button("Aggiungi il primo ricordo") { mostraAggiungi = true }
                    }
                } else {
                    List {
                        ForEach(ricordi) { ricordo in
                            NavigationLink(destination: DettaglioRicordoView(ricordo: ricordo)) {
                                HStack(spacing: 15) {
                                    if let primaFoto = ricordo.immagini.first {
                                        Image(uiImage: primaFoto)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                            .clipped()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(ricordo.nome).font(.headline)
                                        Text(ricordo.descrizione)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: rimuoviRicordo)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Archivio Ricordi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { mostraAggiungi = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $mostraAggiungi) {
                FormInserimentoView(ricordi: $ricordi)
            }
        }
    }

    func rimuoviRicordo(at offsets: IndexSet) {
        ricordi.remove(atOffsets: offsets)
    }
}

struct DettaglioRicordoView: View {
    let ricordo: Ricordo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Carosello orizzontale di foto
                if !ricordo.immagini.isEmpty {
                    GeometryReader { proxy in
                        let width = proxy.size.width
                        TabView {
                            ForEach(ricordo.immagini, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 350)
                                    .clipped()
                            }
                        }
                        .frame(height: 350)
                        .tabViewStyle(PageTabViewStyle())
                    }
                    .frame(height: 350)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(ricordo.nome)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Perché è importante")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text(ricordo.descrizione)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FormInserimentoView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var ricordi: [Ricordo]
    
    @State private var nome = ""
    @State private var descrizione = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var immaginiSelezionate: [UIImage] = []

    var body: some View {
        NavigationView {
            Form {
                Section("Dettagli") {
                    TextField("Nome oggetto", text: $nome)
                    TextEditor(text: $descrizione).frame(height: 100)
                }
                
                Section("Foto (Seleziona multiple)") {
                    // CORREZIONE ERRORE: Usiamo HStack invece di Label per sicurezza
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Scegli dalla galleria")
                        }
                    }
                    .onChange(of: selectedItems) {
                        caricaImmagini()
                    }
                    
                    if !immaginiSelezionate.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(immaginiSelezionate, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8).clipped()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nuovo Ricordo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        let nuovo = Ricordo(nome: nome, descrizione: descrizione, immagini: immaginiSelezionate)
                        ricordi.append(nuovo)
                        dismiss()
                    }
                    .disabled(nome.isEmpty || immaginiSelezionate.isEmpty)
                }
            }
        }
    }

    func caricaImmagini() {
        immaginiSelezionate.removeAll()
        for item in selectedItems {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.immaginiSelezionate.append(uiImage)
                    }
                }
            }
        }
    }
}
