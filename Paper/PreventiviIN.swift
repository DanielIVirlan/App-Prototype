import SwiftUI

// 1. Modello Dati Aggiornato
struct Preventivo: Identifiable {
    let id = UUID()
    let nomeDitta: String
    let logoDitta: String
    let descrizione: String
    let prezzo: Double
    let valutazione: Double
    let distanza: Double
    let via: String      // <--- AGGIUNTO
    let civico: String   // <--- AGGIUNTO
}

struct PreventivoIN: View {
    var oggetto: String
    var tipoRiparazione: String
    
    // 2. Dati di esempio aggiornati con indirizzi reali
    let preventivi: [Preventivo] = [
        Preventivo(nomeDitta: "Riparazioni Veloci H24", logoDitta: "tools.fill", descrizione: "Intervento rapido certificato. Utilizziamo solo ricambi di grado A+.", prezzo: 65.00, valutazione: 4.7, distanza: 1.2, via: "Via Roma", civico: "15"),
        Preventivo(nomeDitta: "Tech Hub Store", logoDitta: "cpu.fill", descrizione: "Specialisti in rigenerazione. Ritiro e riconsegna inclusi.", prezzo: 89.90, valutazione: 4.9, distanza: 3.5, via: "Corso Italia", civico: "128"),
        Preventivo(nomeDitta: "L'Artigiano del Bit", logoDitta: "hammer.fill", descrizione: "Esperienza decennale. Riparazione accurata con test di stress.", prezzo: 55.00, valutazione: 4.4, distanza: 0.8, via: "Via Dante", civico: "4")
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.95, blue: 0.97).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Preventivi per:").font(.caption).foregroundColor(.secondary)
                        Text(oggetto).font(.title2).bold()
                        Text(tipoRiparazione).font(.subheadline).foregroundColor(.blue)
                    }.padding(.horizontal).padding(.top)
                    
                    ForEach(preventivi) { preventivo in
                        SchedaPreventivoView(preventivo: preventivo, tipoRiparazione: tipoRiparazione)
                    }
                }
            }
        }
        .navigationTitle("Offerte Ricevute")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SchedaPreventivoView: View {
    let preventivo: Preventivo
    let tipoRiparazione: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(preventivo.nomeDitta).font(.headline)
                    
                    // Visualizzazione Indirizzo sotto il nome
                    Text("\(preventivo.via), \(preventivo.civico)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text("\(preventivo.valutazione, specifier: "%.1f")")
                        }
                        HStack(spacing: 2) {
                            Image(systemName: "location.fill").foregroundColor(.gray)
                            Text("\(preventivo.distanza, specifier: "%.1f") km")
                        }
                    }
                    .font(.caption).fontWeight(.medium).foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("€\(preventivo.prezzo, specifier: "%.2f")")
                    .font(.title3).bold().foregroundColor(.blue)
            }
            
            Text(preventivo.descrizione)
                .font(.footnote).foregroundColor(.secondary).lineLimit(2)
            
            NavigationLink(destination: SelezionePrev(preventivo: preventivo, tipoRiparazione: tipoRiparazione)) {
                Text("Seleziona").bold().foregroundColor(.white)
                    .frame(maxWidth: .infinity).frame(height: 40)
                    .background(Color.blue).cornerRadius(8)
            }
        }
        .padding().background(Color.white).cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
