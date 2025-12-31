import SwiftUI

struct DettaglioGuidaView: View {
    let guida: Guida
    let titoloProblema: String
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(spacing: 0) {
            List {
                // Sezione Info Rapide
                Section(header: Text("SCHEDA TECNICA")) {
                    HStack {
                        Label("Tempo stimato", systemImage: "clock")
                        Spacer()
                        Text(guida.tempoStimato).fontWeight(.semibold)
                    }
                    HStack {
                        Label("Difficoltà", systemImage: "gauge.medium")
                        Spacer()
                        Text(guida.difficolta)
                            .foregroundColor(guida.difficolta == "Alta" ? .red : .blue)
                            .fontWeight(.bold)
                    }
                }

                // Sezione Autore e Voti
                Section(header: Text("AUTORE DELLA GUIDA")) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(guida.nomeAutore).font(.headline)
                                HStack(spacing: 15) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "hand.thumbsup.fill")
                                            .foregroundColor(.blue)
                                        Text("\(guida.votiPositivi)")
                                    }
                                    HStack(spacing: 4) {
                                        Image(systemName: "hand.thumbsdown.fill")
                                            .foregroundColor(.black)
                                        Text("\(guida.votiNegativi)")
                                    }
                                }
                                .font(.subheadline)
                            }
                        }
                        
                        Text(guida.bioEsperienza)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(.vertical, 8)
                }
                
                // Sezione Procedimento
                Section(header: Text("PROCEDIMENTO DETTAGLIATO")) {
                    Text(guida.descrizioneProcedimento)
                        .font(.body)
                        .padding(.vertical, 5)
                }
            }
            .listStyle(.insetGrouped)
            
            // Tasto Video Blu integrato senza scheda bianca
            VStack {
                Button(action: {
                    if let url = URL(string: guida.videoUrl) {
                        openURL(url)
                    }
                }) {
                    Label("Guarda Video Tutorial", systemImage: "play.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .padding(.top, 10)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
        .navigationTitle(titoloProblema)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PREVIEW
// Questo blocco permette di vedere la UI a destra nel Canvas di Xcode
#Preview {
    NavigationView {
        DettaglioGuidaView(
            guida: Guida(
                nomeAutore: "Daniel",
                bioEsperienza: "Esperto riparatore con oltre 500 interventi documentati su dispositivi iOS.",
                descrizioneProcedimento: "Spegni il dispositivo. Riscalda i bordi per 3 minuti. Usa la ventosa per sollevare lo schermo delicatamente...",
                
                votiPositivi: 120,
                votiNegativi: 2,
                videoUrl: "https://www.apple.com",
                tempoStimato: "45 min",
                difficolta: "Alta"
            ),
            titoloProblema: "Sostituzione Schermo"
        )
    }
}
