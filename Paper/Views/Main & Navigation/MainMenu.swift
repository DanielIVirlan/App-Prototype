import SwiftUI

struct MainMenu: View {
    
    let username: String
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("Cosa desideri fare oggi?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        // --- VENDI ---
                        NavigationLink(destination: CreazioneAnnuncio()) {
                            MenuButtonView(title: "Vendi", icon: "eurosign.circle.fill")
                        }
                        
                        // --- ACQUISTA ---
                        NavigationLink(destination: AnnunciVenditaView()){
                            MenuButtonView(title: "Acquista", icon: "cart.fill")
                        }
                        
                        // --- PREVENTIVO ---
                        NavigationLink(destination: PreventivoRip()){
                            MenuButtonView(title: "Preventivo riparazione", icon: "doc.text.magnifyingglass")
                        }
                        
                        NavigationLink(destination: SelezioneGuidaView()){
                            MenuButtonView(title: "Guida riparazione", icon: "wrench.and.screwdriver.fill")
                        }
                        
                        
                        
                        NavigationLink(destination: Archivio()){
                            MenuButtonView(title: "Archivio ricordi", icon: "photo.on.rectangle.angled")
                        }
                        
                        
                        NavigationLink(destination: QRCodes()){
                            MenuButtonView(title: "QR Code", icon: "qrcode.viewfinder")
                            
                        }
                        
                        
                        
                        
                        NavigationLink(destination: ValutazioneView()){
                            MenuButtonView(title: "Valuta oggetti", icon: "chart.line.uptrend.xyaxis")
                            
                        }
                        
                        
                        
                        
                        
                        
                        NavigationLink(destination: ProfiloView()){
                            MenuButtonView(title: "Profilo", icon: "person.crop.circle.fill")
                        }
                        
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30) // Spazio extra in fondo per lo scroll
            }
            .navigationTitle("Menu Principale")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// Vista componente per i bottoni del menu
struct MenuButtonView: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Preview
struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu(username:"Admin")
    }
}
