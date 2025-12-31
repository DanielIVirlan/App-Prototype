import Foundation

struct Guida: Identifiable, Hashable, Equatable {
    let id = UUID()
    let nomeAutore: String
    let bioEsperienza: String
    let descrizioneProcedimento: String
    let votiPositivi: Int
    let votiNegativi: Int
    let videoUrl: String
    let tempoStimato: String
    let difficolta: String
}

struct Problema: Identifiable, Hashable, Equatable {
    let id = UUID()
    let titolo: String
    let guidaDettaglio: Guida
}

struct CategoriaOggetto: Identifiable, Hashable, Equatable {
    let id = UUID()
    let nome: String
    let icona: String
    let problemiComuni: [Problema]
}

// Dati di esempio pronti per l'uso
let categorieDati = [
    CategoriaOggetto(nome: "Smartphone", icona: "iphone", problemiComuni: [
        Problema(titolo: "Sostituzione Schermo OLED", guidaDettaglio: Guida(
            nomeAutore: "Marco Tecno",
            bioEsperienza: "Tecnico certificato con oltre 10 anni di esperienza nel settore micro-elettronica. Specializzato in rigenerazione display e microsaldatura su circuiti stampati Apple e Android.",
            descrizioneProcedimento: """
                ATTENZIONE: Prima di iniziare, scarica la batteria sotto il 25% per evitare rischi di incendio.

                1. PREPARAZIONE: Spegni il dispositivo. Riscalda i bordi del display per 3-5 minuti con un phon per ammorbidire l'adesivo.

                2. APERTURA: Applica una ventosa sulla parte inferiore del vetro. Tira leggermente e inserisci un plettro di plastica sottile. Scorri il plettro lungo il perimetro facendo attenzione a non inserirlo per più di 2mm per non tagliare i cavi flex.

                3. RIMOZIONE SCHERMATURE: Apri il display a 'libretto'. Svita le viti a tripla punta (Y000) che fissano la placchetta metallica dei connettori.

                4. SCOLLEGAMENTO: Usa uno spudger in plastica per scollegare PRIMA la batteria, poi il connettore OLED e infine i sensori frontali (FaceID).

                5. TRASFERIMENTO SENSORI: Rimuovi l'altoparlante auricolare e i sensori dal vecchio schermo e installali sul nuovo pannello OLED.

                6. CHIUSURA: Applica un nuovo biadesivo perimetrale. Collega i connettori, riposiziona le placchette e avvita.

                7. TEST: Accendi il dispositivo per verificare touch e luminosità prima di sigillare definitivamente premendo lungo i bordi.
                """,
            votiPositivi: 1450,
            votiNegativi: 12,
            videoUrl: "https://www.apple.com", // Link di esempio
            tempoStimato: "50-60 min",
            difficolta: "Alta"
        )),
        Problema(titolo: "Sostituzione Batteria", guidaDettaglio: Guida(
            nomeAutore: "Andrea Fix",
            bioEsperienza: "Esperto in riparazioni rapide hardware.",
            descrizioneProcedimento: "Aprire il retro, scollegare batteria vecchia...",
            votiPositivi: 890,
            votiNegativi: 3,
            videoUrl: "https://www.google.com",
            tempoStimato: "30 min",
            difficolta: "Media"
        )),
        
        
        Problema(titolo: "Pulizia/Cambio Porta USB-C", guidaDettaglio: Guida(
            nomeAutore: "Giulia Tech",
            bioEsperienza: "Esperta in microsaldature e connettività mobile.",
            descrizioneProcedimento: "1. Prima di smontare, prova a pulire con uno stuzzicadenti in plastica e aria compressa.\n2. Se non funziona, smonta la parte inferiore del telaio.\n3. Rimuovi l'altoparlante di sistema per accedere al connettore.\n4. Scollega il cavo flat della porta di ricarica.\n5. Sostituisci il modulo e rimonta.",
            votiPositivi: 650, votiNegativi: 2, videoUrl: "",
            tempoStimato: "40 min", difficolta: "Media")),
                
                // 4. FOTOCAMERA POSTERIORE
        Problema(titolo: "Vetro Fotocamera Rotto", guidaDettaglio: Guida(
            nomeAutore: "Luca Snap",
            bioEsperienza: "Riparatore hardware con focus sui moduli ottici.",
            descrizioneProcedimento: "1. Rimuovi i frammenti di vetro dall'esterno usando calore e una pinzetta sottile.\n2. Fai attenzione a non graffiare la lente del sensore.\n3. Pulisci con alcool isopropilico.\n4. Applica il nuovo vetrino adesivo premendo con decisione per 30 secondi.",
            votiPositivi: 430, votiNegativi: 0, videoUrl: "",
            tempoStimato: "15 min", difficolta: "Bassa")),
                
                // 5. DANNO DA LIQUIDI
        Problema(titolo: "Smartphone Caduto in Acqua", guidaDettaglio: Guida(
            nomeAutore: "Emergency Fix",
            bioEsperienza: "Specialista nel recupero dati e ossidazione circuiti.",
            descrizioneProcedimento: "1. NON ACCENDERE il telefono.\n2. Asciuga l'esterno e rimuovi la SIM.\n3. Se possibile, scollega la batteria internamente il prima possibile.\n4. Pulisci la scheda madre con alcool isopropilico 99% per rimuovere i sali.\n5. Lascia asciugare per 24 ore prima di testare.",
            votiPositivi: 2100, votiNegativi: 18, videoUrl: "",
            tempoStimato: "24 ore (attesa)", difficolta: "Alta"))
            ]),
        
        
    

    CategoriaOggetto(nome: "Computer", icona: "laptopcomputer", problemiComuni: [
        Problema(titolo: "Pulizia Ventole", guidaDettaglio: Guida(
            nomeAutore: "Sara Bit",
            bioEsperienza: "Sistemista IT con focus su manutenzione hardware PC/Mac.",
            descrizioneProcedimento: "1. Rimuovi viti scocca...\n2. Blocca ventole con aria compressa...",
            votiPositivi: 420,
            votiNegativi: 1,
            videoUrl: "",
            tempoStimato: "20 min",
            difficolta: "Bassa"
        ))
        
        
        
        
    ]),
    CategoriaOggetto(nome: "Elettrodomestici", icona: "washer", problemiComuni: [
        // Aggiungi qui altre guide...
    ])
]
