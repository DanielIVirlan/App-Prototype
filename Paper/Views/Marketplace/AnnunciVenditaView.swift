import SwiftUI

struct Annuncio: Identifiable {
    let id = UUID()
    let titolo: String
    let descrizione: String
    let prezzo: Double
    let nomiImmagini: [String] // Array di nomi per il carosello
}

struct AnnunciVenditaView: View {
    // 2. Dati con 3 annunci e 2 immagini ciascuno
    let annunci = [
        Annuncio(titolo: "iPhone 15 Pro",
                 descrizione: "Ottime condizioni, batteria 95%. Grigio titanio.",
                 prezzo: 850.00,
                 nomiImmagini: ["iphone_1", "iphone_2"]),
        
        Annuncio(titolo: "PlayStation 5",
                 descrizione: "Versione disco, incluso secondo controller DualSense.",
                 prezzo: 400.00,
                 nomiImmagini: ["ps5_1", "ps5_2"]),
        
        Annuncio(titolo: "MacBook Air M2",
                 descrizione: "8GB RAM, 256GB SSD. Come nuovo, pochissimi cicli.",
                 prezzo: 950.00,
                 nomiImmagini: ["mac_1", "mac_2"])
    ]
    
    var body: some View {
        NavigationStack {
            List(annunci) { annuncio in
                NavigationLink(destination: DettaglioAnnuncioView(annuncio: annuncio)) {
                    HStack(spacing: 15) {
                        // Mostra la prima immagine dell'array nella lista
                        Image(annuncio.nomiImmagini.first ?? "")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(annuncio.titolo)
                                .font(.headline)
                            Text(annuncio.descrizione)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                            Text("€\(String(format: "%.2f", annuncio.prezzo))")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Annunci in vendita")
        }
    }
}

struct MetodoConsegnaView: View {
    let icona: String
    let testo: String
    let colore: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icona)
                .font(.system(size: 20))
                .foregroundColor(colore)
            Text(testo)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(colore.opacity(0.1))
        .cornerRadius(10)
    }
}

struct DettaglioAnnuncioView: View {
    let annuncio: Annuncio
    @State private var indiceCorrente = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Carosello Immagini
                ZStack(alignment: .topTrailing) {
                    TabView(selection: $indiceCorrente) {
                        ForEach(0..<annuncio.nomiImmagini.count, id: \.self) { index in
                            Image(annuncio.nomiImmagini[index])
                                .resizable()
                                .scaledToFill()
                                .tag(index)
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(.page)
                    .cornerRadius(15)
                    
                    Text("\(indiceCorrente + 1) di \(annuncio.nomiImmagini.count)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)
                        .padding(20)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 15) {
                    // Titolo e Prezzo
                    VStack(alignment: .leading, spacing: 5) {
                        Text(annuncio.titolo)
                            .font(.largeTitle)
                            .bold()
                        
                        Text("€\(String(format: "%.2f", annuncio.prezzo))")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .bold()
                    }
                    
                    // --- SEZIONE ICONE CONSEGNA AGGIORNATA ---
                    HStack(spacing: 15) {
                        MetodoConsegnaView(icona: "box.truck", testo: "Spedizione", colore: .orange)
                        
                        // Ho cambiato l'icona del Locker con 'shippingbox'
                        // Altre opzioni: "archivebox", "square.grid.2x2", "door.left.hand.closed"
                        MetodoConsegnaView(icona: "shippingbox", testo: "Locker", colore: .green)
                        
                        MetodoConsegnaView(icona: "mappin.and.ellipse", testo: "Safe Zone", colore: .blue)
                    }
                    .padding(.vertical, 5)

                    Divider()
                    
                    Text("Descrizione")
                        .font(.headline)
                    Text(annuncio.descrizione)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: OpzioniAcquisto()) {
                    Text("Acquista")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
