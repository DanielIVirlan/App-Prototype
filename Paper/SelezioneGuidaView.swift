import SwiftUI

struct SelezioneGuidaView: View {
    @State private var categoriaSelezionata: CategoriaOggetto = categorieDati[0]
    @State private var problemaSelezionato: Problema?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("CATEGORIA OGGETTO")) {
                        Picker("Tipologia", selection: $categoriaSelezionata) {
                            ForEach(categorieDati, id: \.self) { cat in
                                Label(cat.nome, systemImage: cat.icona).tag(cat)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section(header: Text("PROBLEMI COMUNI")) {
                        ForEach(categoriaSelezionata.problemiComuni) { problema in
                            HStack {
                                Text(problema.titolo)
                                Spacer()
                                if problemaSelezionato?.id == problema.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                problemaSelezionato = problema
                            }
                        }
                    }
                }
                
                if let selezione = problemaSelezionato {
                    NavigationLink(destination: DettaglioGuidaView(guida: selezione.guidaDettaglio, titoloProblema: selezione.titolo)) {
                        Text("Cerca Guida")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Guida riparazione")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
