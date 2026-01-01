import SwiftUI

struct RisultatoValutazioneView: View {
    let titolo: String
    let categoria: String
    let condizione: String
    let immagini: [UIImage]
    
    @Environment(\.dismiss) var dismiss
    @State private var vaiASmaltimento = false
    @State private var tornaAlMenu = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { // VStack principale per dividere contenuto e bottoni
                ScrollView {
                    VStack(spacing: 25) {
                        // Riepilogo Oggetto
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Riepilogo").font(.caption).bold().foregroundColor(.secondary)
                            HStack(spacing: 15) {
                                if let img = immagini.first {
                                    Image(uiImage: img).resizable().scaledToFill().frame(width: 70, height: 70).cornerRadius(12).clipped()
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(titolo).font(.headline)
                                    Text("\(categoria) • \(condizione)").font(.subheadline).foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(15)

                        // Scheda Valutazione
                        VStack(spacing: 20) {
                            Text("VALUTAZIONE STIMATA")
                                .tracking(1)
                                .font(.caption)
                                .bold()
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 0) {
                                VStack {
                                    Text("€45,00").font(.system(size: 34, weight: .black, design: .rounded)).foregroundColor(.blue)
                                    Text("Valore Cash").font(.caption).foregroundColor(.secondary)
                                }.frame(maxWidth: .infinity)
                                
                                Divider().frame(height: 50)
                                
                                VStack {
                                    Text("450").font(.system(size: 34, weight: .black, design: .rounded)).foregroundColor(.orange)
                                    Text("Punti Green").font(.caption).foregroundColor(.secondary)
                                }.frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                    }
                    .padding()
                }

                // --- AREA BOTTONI NATIVI IN BASSO ---
                VStack(spacing: 8) {
                    // Tasto Smaltisci 
                    Button(action: { vaiASmaltimento = true }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("SMALTISCI ORA").fontWeight(.bold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Tasto Annulla
                    Button(action: { tornaAlMenu = true }) {
                        Text("Annulla")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.vertical, 10)
                    }
                }
                .background(Color(red: 0.96, green: 0.97, blue: 0.98)) // Stesso colore dello sfondo
                .padding(.bottom, 10)
            }
            .navigationTitle("Risultato")
            .background(Color(red: 0.96, green: 0.97, blue: 0.98).ignoresSafeArea())
            .navigationDestination(isPresented: $vaiASmaltimento) {
                SceltaSmaltimentoView()
            }
            .navigationDestination(isPresented: $tornaAlMenu) {
                MainMenu(username: "Admin")
            }
        }
    }
}
