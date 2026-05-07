# 💾 Floppy Machine

**Floppy Machine** è un'applicazione innovativa e nostalgica che automatizza completamente il processo di formattazione dei floppy disk (dischetti). Progettata e funzionante su **Windows XP 32 bit**, rappresenta un affascinante ponte tra il retro-computing e l'automazione moderna.

## 🎯 Che cos'è Floppy Machine?

Floppy Machine è un sistema automatico per la formattazione continue di floppy disk che unisce:
- 📜 **Script Batch (BAT)** per l'automazione del sistema operativo
- 🌐 **Interfaccia Web moderna** con design retrò anni '90
- 📊 **Monitoraggio in tempo reale** dello stato della formattazione
- 📈 **Logging completo** di tutte le operazioni
- 💤 **Modalità riposo intelligente** per il risparmio energetico

Il progetto è perfetto per chi desidera rivivere l'era dei floppy disk o per applicazioni specializzate di retro-computing.

## 🖥️ Requisiti di Sistema

- **Sistema Operativo**: Windows XP 32 bit
- **Server Web**: XAMPP (o qualsiasi server web con supporto PHP)
- **Browser**: Qualsiasi browser web moderno (consigliato Internet Explorer 8+)
- **Unità Floppy**: Un'unità floppy disk su ingresso A:
- **Floppy Disk**: Dischetti da 3.5" formattabili

## 📦 Installazione

### Prerequisiti
1. Installare **XAMPP** o un server web equivalente con PHP
2. Assicurarsi che l'unità floppy sia collegata e accessibile come A:\

### Setup

1. Clonare o scaricare il progetto in: `C:\xampp\htdocs\FloppyMachine\`
2. Verificare che i seguenti file siano presenti:
   - `FloppyMachine.bat` - Script principale di automazione
   - `index.html` - Interfaccia web
   - `wake.php` - API per il risveglio
   - `stop.php` - API per l'arresto
   - `favicon.ico` - Icona dell'applicazione

3. Avviare il server web XAMPP

4. Lanciare `FloppyMachine.bat` dal prompt dei comandi:
   ```batch
   C:\xampp\htdocs\FloppyMachine\FloppyMachine.bat
   ```

5. Aprire il browser e navigare a:
   ```
   http://localhost/FloppyMachine/
   ```

## 🚀 Utilizzo

### Avvio dell'Applicazione

1. **Lanciare lo script**: Eseguire `FloppyMachine.bat`
2. **Accedere all'interfaccia**: Aprire il browser a `http://localhost/FloppyMachine/`
3. **Monitorare lo stato**: L'interfaccia mostra in tempo reale lo stato del sistema

### Workflow Principale

```
PRONTO (Verde 🟢)
    ↓
ATTESA FLOPPY (Clessidra ⌛) - max 10 tentativi
    ↓
FLOPPY INSERITO (Suono di conferma)
    ↓
FORMATTAZIONE (Ruota ⚙️) - animazione di progresso
    ↓
COMPLETATO (Spunta ✅)
    ↓
RIPOSO (Sonno 😴) - dopo 10 tentativi falliti consecutivi
    ↓
[Tornare a PRONTO o rimanere in RIPOSO per 1 ora]
```

### Pulsanti di Controllo

- **🔔 Risveglia**: Esce dalla modalità riposo e riprende la formattazione
- **⛔ Arresta**: Arresta completamente il programma (disponibile solo in stato PRONTO)

### Stati dell'Applicazione

| Stato | Emoji | Descrizione |
|-------|-------|-------------|
| **PRONTO** | 🟢 | Sistema pronto ad accettare floppy |
| **INSERIRE FLOPPY** | ⌛ | In attesa di un floppy disk da inserire (max 10 tentativi) |
| **FLOPPY INSERITO** | 💾 | Dischetto rilevato, inizio formattazione |
| **FORMATTANDO** | ⚙️ | Formattazione in corso con barra di progresso |
| **COMPLETATO** | ✅ | Floppy formattato con successo |
| **ERRORE** | ❌ | Errore durante la formattazione |
| **RIPOSO** | 😴 | Modalità a basso consumo energetico (1 ora) |
| **ARRESTO** | 🛑 | Sistema in fase di arresto |

## 🔧 Architettura Tecnica

### Componenti Principali

#### 1. **FloppyMachine.bat** - Motore di Automazione
Script batch che gestisce:
- **Rilevamento** dell'unità floppy (`dir A:\`)
- **Formattazione** in formato FAT (`format A: /FS:FAT`)
- **Segnali sonori** per feedback visivo
- **Aggiornamento dello stato** tramite file HTML
- **Logging** dettagliato in CSV
- **Modalità riposo** con timeout di 1 ora

Logica principale:
```
1. Inizializzazione: pulizia file di stato e controllo
2. Loop principale:
   - Attesa insertimento floppy (max 10 tentativi con delay)
   - Formattazione del disco
   - Aggiornamento dello stato e log
3. Riposo: dopo 10 fallimenti, attende 1 ora prima di ritentare
4. Monitoraggio: verifica continua di file di controllo (wake.txt, stop.txt)
```

#### 2. **index.html** - Interfaccia Web
Interfaccia moderna con stile retrò (98.css) che:
- **Monitora** lo stato ogni 2 secondi via HTTP
- **Anima** la barra di progresso durante la formattazione
- **Legge** il log CSV per storico completo
- **Fornisce** pulsanti di controllo
- **Responsive**: adattabile a diverse risoluzioni

#### 3. **wake.php** - API di Risveglio
Riceve richieste POST e:
- Crea il file `wake.txt` per segnalare il risveglio
- Esce dalla modalità riposo
- Ritorna al loop di attesa

#### 4. **stop.php** - API di Arresto
Riceve richieste POST e:
- Crea il file `stop.txt` per segnalare l'arresto
- Termina il programma in modo controllato

#### 5. **File di Stato e Dati**
- `status.html` - Stato corrente (aggiornato in tempo reale dal batch)
- `result.html` - Dettagli dell'ultimo errore
- `log.csv` - Log cronologico di tutte le operazioni (CSV separato da `;`)

### Flusso di Comunicazione

```
┌─────────────────────────────────────────────┐
│     Browser Web (index.html)                │
│  Interfaccia utente + monitoraggio          │
└────────────────────┬────────────────────────┘
                     │ HTTP Polling (ogni 2s)
                     │ + POST (wake/stop)
                     ↓
┌──────────────────────────────────────────┐
│  Server Web (XAMPP + PHP)                │
│  - wake.php / stop.php (API)             │
│  - Serve file di stato                   │
└─────────────────┬────────────────────────┘
                  │ File system
                  ↓
┌─────────────────────────────────────────────────────┐
│ FloppyMachine.bat (Batch Script)                    │
│ - Monitora wake.txt / stop.txt                      │
│ - Emette comandi di formattazione                   │
│ - Aggiorna status.html / log.csv                    │
└──────────────────────┬──────────────────────────────┘
                       │ Comando sistema
                       ↓
              ┌────────────────────┐
              │ Windows XP Kernel  │
              │ Unità A: (Floppy)  │
              └────────────────────┘
```

## 📊 Formato dei Log

Il file `log.csv` contiene una riga per ogni evento:

```csv
Data/Ora;Evento;
2026-05-07 14:30:45.123;Pronto;
2026-05-07 14:30:47.456;Inserire Floppy - Tentativo 0;
2026-05-07 14:30:52.789;Floppy Inserito;
2026-05-07 14:30:53.012;Inizio Formattazione;
2026-05-07 14:31:20.345;Completato;
```

## 🖱️ Interfaccia Utente

L'interfaccia Web usa **98.css**, uno stile CSS che replica l'estetica di Windows 98:
- Finestre con bordi intagliati classici
- Pulsanti in stile retrò
- Barra di stato in basso
- Visualizzazione di emoji per gli stati (con fallback testuale su vecchi browser)

### Layout Principale

```
┌─ Floppy Machine ─────────────────────────┐
│ [?] [X]                                  │
├──────────────────────────────────────────┤
│  🟢                                      │
│  PRONTO                                  │
│                                          │
│  [    Barra di Progresso    ]    0%     │
│  [Risveglia]    [Arresta]               │
├─ Log Attività ───────────────────────────┤
│  Orario          │ Azione               │
│  14:30:45        │ Pronto               │
│  14:30:52        │ Floppy Inserito      │
│  14:31:20        │ Completato           │
├──────────────────────────────────────────┤
│ Versione: 1.0.0 BETA                     │
│ Status: Online 🟢                        │
│ Ultimo aggiornamento: 14:31:20           │
└──────────────────────────────────────────┘
```

## ⚠️ Avvertenze Importanti

- ⚠️ **Non scollegare l'alimentazione** mentre Floppy Machine è in esecuzione
- ⚠️ **Non rimuovere il floppy** durante la formattazione
- ⚠️ **Tutti i dati** sul floppy verranno cancellati durante la formattazione
- ⚠️ **Windows XP only**: Il progetto è testato solo su Windows XP 32 bit
- ⚠️ **Compatibilità**: Potrebbe non funzionare su versioni più moderne di Windows

## 🎵 Segnali Sonori

Il batch utilizza segnali sonori per feedback:
- **1 beep**: Sistema pronto
- **2 beep**: Floppy rilevato / Formattazione completata
- **4 beep**: Errore di formattazione
- **5 beep**: Sistema in arresto

## 🐛 Troubleshooting

### Floppy non rilevato
- Verificare che l'unità sia funzionante
- Provare a inserire un altro floppy
- Controllare i driver dell'unità in Gestione dispositivi

### La pagina web non si carica
- Verificare che XAMPP sia avviato
- Controllare che il percorso sia `C:\xampp\htdocs\FloppyMachine\`
- Verificare che il firewall non blocchi la porta 80

### Formattazione fallisce
- Verificare che il floppy sia intatto (non danneggiato)
- Controllare lo spazio libero sul disco
- Verificare i permessi di accesso all'unità A:

### Browser non mostra gli emoji
- Usare un browser più moderno (Firefox, Chrome, Edge)
- Internet Explorer 8+ dovrebbe comunque mostrare le icone retrò

## 📝 Licenza

Consultare il file `LICENSE` per i dettagli sulla licenza del progetto.

## 🙏 Ringraziamenti

- **98.css** per il design retrò classico
- La comunità del retro-computing
- Windows XP, per essere stata un'era leggendaria

---

**Floppy Machine** - *Rendi i floppy come nuovi!* 💾✨

**Versione**: 1.0.0 BETA  
**Ultimo aggiornamento**: 7 Maggio 2026  
**Piattaforma**: Windows XP 32 bit

