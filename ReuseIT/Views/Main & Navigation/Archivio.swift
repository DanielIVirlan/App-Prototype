import PhotosUI
import SwiftUI

struct Ricordo: Identifiable {
    let id = UUID()
    var nome: String
    var descrizione: String
    var immagini: [UIImage]
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
                        Image(systemName: "archivebox").font(.system(size: 60)).foregroundColor(.secondary)
                        Text("Il tuo archivio è vuoto").foregroundColor(.secondary)
                        Button("Aggiungi il primo ricordo") { mostraAggiungi = true }
                            .buttonStyle(.borderedProminent)
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
                                        Text(ricordo.nome).font(.headline).foregroundColor(.primary)
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
                        .foregroundColor(.primary)
                    
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
        .background(Color(UIColor.systemBackground))
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
                    TextEditor(text: $descrizione)
                        .frame(height: 100)
                        .scrollContentBackground(.hidden)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                }
                
                Section("Foto (\(immaginiSelezionate.count)/10)") {
                    if immaginiSelezionate.isEmpty {
                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                            VStack(spacing: 12) {
                                Image(systemName: "camera.fill").font(.largeTitle).foregroundColor(.blue)
                                Text("Carica fino a 10 foto").font(.subheadline).foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity).frame(height: 140)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(style: StrokeStyle(lineWidth: 2, dash: [5])).foregroundColor(.secondary.opacity(0.3)))
                        }
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0 ..< immaginiSelezionate.count, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: immaginiSelezionate[index])
                                            .resizable().scaledToFill()
                                            .frame(width: 100, height: 100).clipShape(RoundedRectangle(cornerRadius: 12))
                                        
                                        Button(action: { immaginiSelezionate.remove(at: index) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.white, .red).font(.title3)
                                                .background(Circle().fill(.white).frame(width: 12, height: 12))
                                        }.padding(4)
                                    }
                                }
                                
                                if immaginiSelezionate.count < 10 {
                                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 10 - immaginiSelezionate.count, matching: .images) {
                                        VStack {
                                            Image(systemName: "plus").font(.title2)
                                            Text("Aggiungi").font(.caption2)
                                        }
                                        .frame(width: 100, height: 100)
                                        .background(Color(UIColor.secondarySystemGroupedBackground))
                                        .foregroundColor(.blue).cornerRadius(12)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(style: StrokeStyle(lineWidth: 1, dash: [3])).foregroundColor(.blue))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: selectedItems) { caricaImmagini() }
            .navigationTitle("Nuovo Ricordo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        let nuovo = Ricordo(nome: nome, descrizione: descrizione, immagini: immaginiSelezionate)
                        ricordi.append(nuovo)
                        dismiss()
                    }.disabled(nome.isEmpty || immaginiSelezionate.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") { dismiss() }
                }
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
