import SwiftUI

struct MappaSimulataView: View {
    let option: DeliveryOption
    @Environment(\.dismiss) var dismiss
    @Binding var lockerSelezionato: String
    
    @State private var selectedIndex: Int? = nil
    
    let fixedLocations: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.20, y: 0.30), (x: 0.80, y: 0.25), (x: 0.50, y: 0.45),
        (x: 0.25, y: 0.55), (x: 0.75, y: 0.60), (x: 0.65, y: 0.35)
    ]
    
    let indirizzi: [String] = [
        "Via Roma 12, Milano", "Corso Buenos Aires 45, Milano", "Via Dante 7, Milano",
        "Piazza Duomo 1, Milano", "Via Torino 22, Milano", "Via Manzoni 15, Milano"
    ]
    
    var body: some View {
        ZStack {
            Image("mappa")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0 ..< fixedLocations.count, id: \.self) { index in
                    let loc = fixedLocations[index]
                    
                    ZStack {
                        // Bolla informativa sopra il PIN
                        if selectedIndex == index {
                            HStack(spacing: 10) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(option == .locker ? "Locker \(index + 1)" : "Zona Sicura \(index + 1)")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.primary)
                                    Text(indirizzi[index])
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                }
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            .padding(10)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .offset(y: -75)
                        }
                        
                        // Icona PIN (Locker o Safe Zone)
                        VStack(spacing: 5) {
                            Image(systemName: option == .locker ? "cube.box.fill" : "shield.checkerboard")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(selectedIndex == index ? .white : (option == .locker ? .blue : .green))
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(selectedIndex == index ? Color.blue : Color(UIColor.secondarySystemGroupedBackground))
                                        .shadow(radius: 4)
                                )
                            
                            Text(option == .locker ? "Locker \(index + 1)" : "Zona \(index + 1)")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(selectedIndex == index ? Color.blue : Color(UIColor.secondarySystemGroupedBackground).opacity(0.95))
                                .foregroundColor(selectedIndex == index ? .white : .primary)
                                .cornerRadius(6)
                        }
                        .scaleEffect(selectedIndex == index ? 1.15 : 1.0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                selectedIndex = index
                                let prefisso = (option == .locker) ? "Locker" : "Zona Sicura"
                                lockerSelezionato = "\(prefisso) \(index + 1) - \(indirizzi[index])"
                            }
                        }
                    }
                    .position(x: geometry.size.width * loc.x, y: geometry.size.height * loc.y)
                }
            }
            
            VStack {
                Spacer()
                Button(action: { if selectedIndex != nil { dismiss() } }) {
                    Text(selectedIndex != nil ? "Conferma posizione" : "Seleziona un punto")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(selectedIndex != nil ? Color.blue : Color.gray.opacity(0.6))
                        .cornerRadius(28)
                }
                .disabled(selectedIndex == nil)
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
}
