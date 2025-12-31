import Foundation
import MapKit
import Combine // <-- AGGIUNGI QUESTO

// La classe deve conformare a ObservableObject per poter notificare la View
class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    // MKLocalSearchCompleter è la classe Apple che fornisce i suggerimenti
    let completer = MKLocalSearchCompleter()
    
    // Variabile che conterrà i suggerimenti, e che la View 'ascolterà'
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    // Variabile in cui la View scriverà il testo corrente
    @Published var queryFragment: String = "" {
        didSet {
            // Ogni volta che il testo (queryFragment) cambia,
            // aggiorniamo la stringa di ricerca del completer.
            completer.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        // Impostiamo noi stessi come delegato per ricevere i suggerimenti
        completer.delegate = self
        
        // Impostiamo il filtro per mostrare solo città e paesi (Località/Administrative Area)
        completer.resultTypes = .address
        
        // Puoi anche limitare la ricerca ad un'area specifica, se necessario.
        // completer.region = MKCoordinateRegion(...)
    }
    
    // MARK: - MKLocalSearchCompleterDelegate
    
    // Funzione chiamata quando ci sono suggerimenti
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // ... (il resto della funzione)
        self.searchResults = completer.results.filter { $0.subtitle.contains("Area") || $0.subtitle.contains("Regione") }
    }
    
    // Funzione chiamata in caso di errore (opzionale)
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Errore nella ricerca di MapKit: \(error.localizedDescription)")
    }
}
