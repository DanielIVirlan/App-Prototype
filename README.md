# 📱 Paper - ReuseIT

**ReuseIT** è una piattaforma innovativa sviluppata in **SwiftUI** che mira a rivoluzionare il ciclo di vita dei dispositivi elettronici. L'app integra un marketplace sicuro, sistemi di logistica intelligente (Locker), guide alla riparazione e una sezione dedicata al valore affettivo degli oggetti.

---

## 🎥 Demo dell'App
Ecco l'app in funzione (Xcode 17 / iOS 18+):

<table width="100%">
  <tr>
    <td width="33%" align="center" valign="top">
      <p><b>📱 Demo Parte 1</b></p>
      <video src="https://github.com/user-attachments/assets/3390e263-ec92-4e46-8c50-0b360d95c313" width="100%" controls></video>
    </td>
    <td width="33%" align="center" valign="top">
      <p><b>📱 Demo Parte 2</b></p>
      <video src="https://github.com/user-attachments/assets/69adf429-1bac-450e-8845-ca39739ce9d6" width="100%" controls></video>
    </td>
    <td width="33%" align="center" valign="top">
      <p><b>📱 Demo Parte 3</b></p>
      <video src="https://github.com/user-attachments/assets/0e92ac11-2129-41ea-a8cb-54778c4334d2" width="100%" controls></video>
    </td>
  </tr>
</table>


---

## 🌟 Funzionalità Principali

### 1. Marketplace & Logistica Avanzata
Il cuore dell'app permette di vendere ed acquistare oggetti scegliendo la modalità di scambio preferita:
- **Safe Zones**: Selezione di zone sicure sulla mappa per lo scambio a mano.
- **Locker System**: Integrazione con armadietti intelligenti. Il venditore genera un **QR Code**, deposita l'oggetto e l'acquirente lo ritira con un proprio codice dopo il pagamento.
- **Spedizione**: Opzione per la spedizione privata tramite corriere.

### 2. Expert Repair & Preventivi
- **Consulenza Esperti**: L'utente invia i dati del dispositivo e riceve preventivi da tecnici esperti che consigliano se convenga riparare o acquistare un nuovo prodotto.
- **Logistica Riparazioni**: Possibilità di inviare il dispositivo al tecnico tramite Locker, ritiro a domicilio o consegna a mano.

### 3. Guide alla Riparazione DIY
- **Database Guide**: Guide specifiche per tipologia di oggetto e problemi comuni (es. sostituzione display).
- **Social Proof**: Ogni guida mostra l'autore, i voti positivi/negativi della community e video tutorial integrati.

### 4. Archivio dei Ricordi
Una funzione unica per preservare il valore emotivo: prima di vendere un oggetto, l'utente può salvarlo in un **archivio digitale** con foto e descrizioni, mantenendo viva la memoria dell'oggetto anche dopo la cessione.

### 5. Valutazione Istantanea & Sistema "Reuseit"
- **Valutazione esperto**: Inserendo dati e foto, l'utente riceve una quotazione monetaria e un saldo in **Punti Reusics** (punti bonus da utilizzare nell'ecosistema).

### 6. Profilo & Social Dashboard
- **Gestione Annunci**: Modifica di prezzi, foto e monitoraggio dei preventivi salvati.
- **Reputazione**: Visualizzazione di tutte le **valutazioni ricevute** dagli altri utenti per i propri oggetti.
- **Sicurezza**: Gestione account, Wallet QR Code e funzionalità di ripristino password/logout.

---

## 🗺️ Nota sulle Mappe (Modalità Demo)
Il modulo mappe è attualmente in modalità **Interattiva Demo**:
- La mappa mostra icone predefinite per **Locker e Safe Zones**.
- Non è implementata la geolocalizzazione GPS real-time: l'utente può selezionare manualmente i punti di interesse sulla mappa per simulare il processo di vendita/ritiro.

---

## 🛠 Note Tecniche
- **Linguaggio**: Swift 5+
- **Framework**: SwiftUI 
- **Target**: iOS 26.1+
- **Xcode**: 26.1+
- **Architettura**: Modulare (Organizzata in: `Models`, `Views`, `Resources`).

---

## 👨‍💻 Installazione Locale
1. Clonare la repository: `git clone https://github.com/DanielIVirlan/ReuseIT.git`
2. Aprire `Paper.xcodeproj` in Xcode.
3. Selezionare un simulatore iPhone (iOS 18+).
4. Build & Run (`Cmd + R`).
