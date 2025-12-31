import SwiftUI

// MARK: - Modello Dati
// Assicurati che questa struct sia definita una sola volta nel progetto
struct QRTicket: Identifiable {
    let id = UUID()
    let titolo: String
    let oggetto: String
    let codiceNumerico: String
    let qrData: String
}

// MARK: - Vista Principale
struct QRCodes: View {
    // Dati di esempio per la lista
    @State private var tickets = [
        QRTicket(titolo: "Locker 5", oggetto: "iPhone 13 Pro", codiceNumerico: "554-129", qrData: "LKR5-13P"),
        QRTicket(titolo: "Locker 12", oggetto: "MacBook Air M2", codiceNumerico: "882-331", qrData: "LKR12-MBA"),
        QRTicket(titolo: "Locker 2", oggetto: "Sostituzione Batteria", codiceNumerico: "110-445", qrData: "SZ2-BATT")
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            List(tickets) { ticket in
                // La chiamata corretta alla vista dettaglio
                NavigationLink(destination: DettaglioQR(ticket: ticket)) {
                    HStack(spacing: 15) {
                        Image(systemName: "qrcode")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 45, height: 45)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ticket.titolo)
                                .font(.headline)
                            Text(ticket.oggetto)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("I tuoi QR Code")
    }
}

// MARK: - Vista Dettaglio
struct DettaglioQR: View {
    // Questa proprietà deve chiamarsi esattamente 'ticket' per corrispondere alla chiamata sopra
    let ticket: QRTicket
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text(ticket.titolo.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .tracking(2)
                    
                    Text(ticket.oggetto)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)

                // Area QR Code
                VStack(spacing: 25) {
                    Image(systemName: "qrcode")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                    
                    // Codice Numerico
                    VStack(spacing: 8) {
                        Text("CODICE DI SBLOCCO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Text(ticket.codiceNumerico)
                            .font(.system(size: 36, weight: .black, design: .monospaced))
                            .tracking(5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 30)

                // Istruzioni
                VStack(alignment: .leading, spacing: 12) {
                    Text("Istruzioni")
                        .font(.headline)
                    
                    Text("Mostra il QR code allo scanner del locker. Se non viene riconosciuto, inserisci il codice numerico manualmente sul tastierino fisico del locker.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 30)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}
