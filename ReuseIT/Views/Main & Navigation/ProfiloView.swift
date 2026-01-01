import PhotosUI
import SwiftUI

// MARK: - 1. MODELLI DATI

struct AnnuncioModel: Identifiable {
    let id = UUID()
    var titolo: String
    var prezzo: String
    var stato: String
    var immagini: [UIImage]
}

struct ValutazioneRicevuta: Identifiable {
    let id = UUID()
    var titolo: String
    var categoria: String
    var condizione: String
    var descrizione: String
    var prezzoStimato: String
    var puntiStimati: Int
    var immagini: [UIImage]
    var data: Date = .init()
}

// MARK: - 2. VISTA PRINCIPALE PROFILO

struct ProfiloView: View {
    @State private var username: String = "daniel"
    @State private var password: String = "admin"
    @State private var passwordVisibile: Bool = false
    @State private var puntiAccumulati: Int = 1100
    
    @State private var mieiAnnunci = [
        AnnuncioModel(titolo: "iPhone 15 Pro - Grigio",
                      prezzo: "850,00",
                      stato: "In attesa",
                      immagini: [UIImage(named: "iphone_1") ?? UIImage(systemName: "photo")!,
                                 UIImage(named: "iphone_2") ?? UIImage(systemName: "photo")!]),
        
        AnnuncioModel(titolo: "PlayStation 5 - Disco",
                      prezzo: "400,00",
                      stato: "Pubblicato",
                      immagini: [UIImage(named: "ps5_1") ?? UIImage(systemName: "photo")!,
                                 UIImage(named: "ps5_2") ?? UIImage(systemName: "photo")!]),
        
        AnnuncioModel(titolo: "MacBook Air M2",
                      prezzo: "950,00",
                      stato: "In attesa",
                      immagini: [UIImage(named: "mac_1") ?? UIImage(systemName: "photo")!,
                                 UIImage(named: "mac_2") ?? UIImage(systemName: "photo")!])
    ]
    
    @State private var valutazioniRicevute: [ValutazioneRicevuta] = [
        ValutazioneRicevuta(titolo: "MacBook Pro M2",
                            categoria: "Elettronica",
                            condizione: "Ottimo",
                            descrizione: "Tenuto perfettamente, batteria al 90%",
                            prezzoStimato: "850,00",
                            puntiStimati: 850,
                            immagini: [UIImage(named: "mac_1") ?? UIImage(systemName: "photo")!]),
        
        ValutazioneRicevuta(titolo: "Bicicletta da corsa",
                            categoria: "Sport",
                            condizione: "Buono",
                            descrizione: "Qualche graffio sul telaio, catena nuova",
                            prezzoStimato: "250,00",
                            puntiStimati: 250,
                            immagini: [UIImage(named: "bicycle") ?? UIImage(systemName: "photo")!])
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Attività")) {
                    NavigationLink(destination: MieAnnunciView(annunci: $mieiAnnunci)) {
                        HStack {
                            Image(systemName: "megaphone.fill").foregroundColor(.blue)
                            Text("I miei annunci pubblicati")
                        }
                    }
                    
                    NavigationLink(destination: MieiPreventiviSceltiView()) {
                        HStack {
                            Image(systemName: "doc.text.badge.checkmark").foregroundColor(.green)
                            Text("Preventivi scelti")
                        }
                    }
                    
                    NavigationLink(destination: ListaValutazioniView(valutazioni: valutazioniRicevute)) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass").foregroundColor(.purple)
                            Text("Valutazioni ricevute")
                        }
                    }
                }
                
                Section(header: Text("Premi e Fedeltà")) {
                    HStack {
                        Image(systemName: "star.circle.fill").foregroundColor(.orange)
                        Text("Saldo punti")
                        Spacer()
                        Text("\(puntiAccumulati) pt").fontWeight(.bold).foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Informazioni Account")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(username).foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Password")
                        Spacer()
                        if passwordVisibile { Text(password).foregroundColor(.gray) }
                        else { Text("••••••••").foregroundColor(.gray) }
                        Button(action: { passwordVisibile.toggle() }) {
                            Image(systemName: passwordVisibile ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 14)).foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: {}) {
                        Text("Reimposta Password").foregroundColor(.blue)
                    }
                }
                
                Section {
                    NavigationLink(destination: LogIN().navigationBarBackButtonHidden(true)) {
                        HStack {
                            Spacer()
                            Text("Log Out").fontWeight(.bold).foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Il mio Profilo")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

// MARK: - 3. VISTA ELENCO ANNUNCI (CORRETTA)

struct MieAnnunciView: View {
    @Binding var annunci: [AnnuncioModel]
    @State private var annuncioDaModificare: AnnuncioModel?
    
    // Stati per l'Alert di eliminazione
    @State private var mostraAlertElimina = false
    @State private var annuncioDaEliminare: AnnuncioModel?
    
    var body: some View {
        List {
            ForEach(annunci) { annuncio in
                VStack(alignment: .leading, spacing: 10) {
                    Text(annuncio.titolo).font(.headline)
                    Text("Prezzo: €\(annuncio.prezzo)").font(.subheadline).foregroundColor(.blue)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if annuncio.immagini.isEmpty {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                    .overlay(Image(systemName: "photo").foregroundColor(.gray))
                            } else {
                                ForEach(annuncio.immagini, id: \.self) { img in
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(10)
                                        .clipped()
                                }
                            }
                        }
                    }
                    
                    Text("Stato: \(annuncio.stato)").font(.caption).foregroundColor(.orange)
                    
                    HStack(spacing: 20) {
                        Button(action: { annuncioDaModificare = annuncio }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Modifica")
                            }.font(.footnote)
                        }
                        .buttonStyle(.bordered)
                        
                        // TASTO ELIMINA CON ALERT
                        Button(role: .destructive, action: {
                            annuncioDaEliminare = annuncio
                            mostraAlertElimina = true
                        }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Elimina")
                            }.font(.footnote)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("I miei Annunci")
        // ALERT DI CONFERMA
        .alert("Elimina Annuncio", isPresented: $mostraAlertElimina) {
            Button("Elimina", role: .destructive) {
                if let daEliminare = annuncioDaEliminare {
                    if let index = annunci.firstIndex(where: { $0.id == daEliminare.id }) {
                        withAnimation {
                            _ = annunci.remove(at: index)
                        }
                    }
                }
            }
            Button("Annulla", role: .cancel) {}
        } message: {
            Text("Sei sicuro di voler eliminare '\(annuncioDaEliminare?.titolo ?? "questo annuncio")'? L'azione non può essere annullata.")
        }
        .sheet(item: $annuncioDaModificare) { item in
            ModificaAnnuncioView(annunci: $annunci, annuncio: item)
        }
    }
}

// MARK: - 4. VISTA MODIFICA ANNUNCIO

struct ModificaAnnuncioView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var annunci: [AnnuncioModel]
    @State private var titoloLocal: String
    @State private var prezzoLocal: String
    @State private var immaginiLocali: [UIImage]
    @State private var selectedItems: [PhotosPickerItem] = []
    var idAnnuncio: UUID
    
    init(annunci: Binding<[AnnuncioModel]>, annuncio: AnnuncioModel) {
        self._annunci = annunci
        self._titoloLocal = State(initialValue: annuncio.titolo)
        self._prezzoLocal = State(initialValue: annuncio.prezzo)
        self._immaginiLocali = State(initialValue: annuncio.immagini)
        self.idAnnuncio = annuncio.id
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dati Principali")) {
                    TextField("Nuovo Titolo", text: $titoloLocal)
                    TextField("Nuovo Prezzo", text: $prezzoLocal).keyboardType(.decimalPad)
                }
                Section(header: Text("Media")) {
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                        Label("Aggiungi foto dalla galleria", systemImage: "photo.on.rectangle.angled")
                    }
                    .onChange(of: selectedItems) { _, newValue in
                        caricaImmagini(da: newValue)
                    }
                    
                    if !immaginiLocali.isEmpty {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(immaginiLocali, id: \.self) { img in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                            .clipped()
                                        
                                        Button(action: {
                                            if let index = immaginiLocali.firstIndex(of: img) { immaginiLocali.remove(at: index) }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .background(Circle().fill(Color.white))
                                        }.offset(x: 5, y: -5)
                                    }
                                }
                            }.padding()
                        }
                    }
                }
            }
            .navigationTitle("Modifica")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") {
                        if let index = annunci.firstIndex(where: { $0.id == idAnnuncio }) {
                            annunci[index].titolo = titoloLocal
                            annunci[index].prezzo = prezzoLocal
                            annunci[index].immagini = immaginiLocali
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") { dismiss() }
                }
            }
        }
    }
    
    func caricaImmagini(da items: [PhotosPickerItem]) {
        for item in items {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                    await MainActor.run { self.immaginiLocali.append(image) }
                }
            }
        }
    }
}

// MARK: - 5. LISTA VALUTAZIONI RICEVUTE

struct ListaValutazioniView: View {
    let valutazioni: [ValutazioneRicevuta]
    var body: some View {
        List(valutazioni) { val in
            NavigationLink(destination: DettaglioValutazioneView(valutazione: val)) {
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(val.titolo).font(.headline)
                        Text(val.data, style: .date).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("€\(val.prezzoStimato)").bold().foregroundColor(.blue)
                }.padding(.vertical, 5)
            }
        }.navigationTitle("Le mie Valutazioni")
    }
}


struct DettaglioValutazioneView: View {
    let valutazione: ValutazioneRicevuta
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Galleria immagini
                if !valutazione.immagini.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(valutazione.immagini, id: \.self) { img in
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 280, height: 200)
                                    .cornerRadius(15)
                                    .clipped()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Titolo adattivo
                    Text(valutazione.titolo)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Box Valutazione
                    HStack(spacing: 15) {
                        VStack {
                            Text("STIMA CASH")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                            Text("€\(valutazione.prezzoStimato)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                        
                        VStack {
                            Text("PUNTI GREEN")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                            Text("\(valutazione.puntiStimati)")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

// MARK: - 7. VISTA PREVENTIVI SCELTI

struct MieiPreventiviSceltiView: View {
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 8) {
                Text("Riparazione Schermo PC").font(.headline)
                Text("Tecnico: Tech Hub Store").font(.subheadline)
                Text("Costo: €89,90").bold().foregroundColor(.blue)
                Text("Metodo: Locker 12").font(.footnote).foregroundColor(.secondary)
            }.padding(.vertical, 5)
            VStack(alignment: .leading, spacing: 8) {
                Text("Sostituzione batteria Iphone").font(.headline)
                Text("Tecnico: LabStore ").font(.subheadline)
                Text("Costo: €90,90").bold().foregroundColor(.blue)
                Text("Metodo: Consegna a mano ").font(.footnote).foregroundColor(.secondary)
            }.padding(.vertical, 5)
        }.navigationTitle("Preventivi Scelti")
    }
}
