import SwiftUI
import CoreImage.CIFilterBuiltins

// MARK: - Modello Dati
struct QRTicket: Identifiable {
    let id = UUID()
    let titolo: String
    let oggetto: String
    let codiceNumerico: String
    let qrData: String
}

// MARK: - Vista Principale (Lista)
struct QRCodes: View {
    @State private var tickets = [
        QRTicket(titolo: "Locker 5", oggetto: "iPhone 13 Pro", codiceNumerico: "554-129", qrData: "LKR5-13P"),
        QRTicket(titolo: "Locker 12", oggetto: "MacBook Air M2", codiceNumerico: "882-331", qrData: "LKR12-MBA"),
        QRTicket(titolo: "Locker 2", oggetto: "Sostituzione Batteria", codiceNumerico: "110-445", qrData: "SZ2-BATT")
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            List(tickets) { ticket in
                NavigationLink(destination: DettaglioQR(ticket: ticket)) {
                    HStack(spacing: 15) {
                        Image(systemName: "qrcode")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .frame(width: 45, height: 45)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(10)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ticket.titolo)
                                .font(.headline)
                                .foregroundColor(.primary)
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

// MARK: - Vista Dettaglio (QR Code Reale)
struct DettaglioQR: View {
    let ticket: QRTicket
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
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
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)
                
                // Area QR Code Dinamico
                VStack(spacing: 25) {
                    // Generazione immagine reale
                    if let qrImage = generateQRCode(from: ticket.qrData) {
                        Image(uiImage: qrImage)
                            .resizable()
                            .interpolation(.none) // Impedisce la sfocatura dei pixel
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                            .padding(20)
                            .background(Color.white) // Sfondo bianco fisso per scanner
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 10)
                    } else {
                        // Fallback in caso di errore
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .frame(width: 220, height: 220)
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    
                    // Codice Numerico
                    VStack(spacing: 8) {
                        Text("CODICE DI SBLOCCO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        Text(ticket.codiceNumerico)
                            .font(.system(size: 36, weight: .black, design: .monospaced))
                            .tracking(5)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .cornerRadius(15)
                }
                .padding(.horizontal, 30)
                
                // Istruzioni
                VStack(alignment: .leading, spacing: 12) {
                    Text("Istruzioni")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Mostra il QR code allo scanner del locker. Se non viene riconosciuto, inserisci il codice numerico manualmente sul tastierino fisico del locker.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(15)
                .padding(.horizontal, 30)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Funzione per generare il QR Code reale
    func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Ingrandiamo l'immagine (i QR generati sono piccoli di default)
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}

// MARK: - Preview
struct QRCodes_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                QRCodes()
            }
            .preferredColorScheme(.light)
            
            NavigationView {
                QRCodes()
            }
            .preferredColorScheme(.dark)
        }
    }
}
