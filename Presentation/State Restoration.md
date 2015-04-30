<!-- 

Deckset presentation
Author: Sebastian Hagedorn
Deckset Theme: Franziska, light green, 16:9

-->

# State Preservation & Restoration on iOS

-
 
-

-

-

Sebastian Hagedorn
CocoaHeads Dresden
09.07.2014

---

# Übersicht

+ Motivation
+ Implementierung
+ Debugging & GOTCHAs
+ Quellen & Links

---

# Motivation

+ iOS beendet im Hintergrund laufende Apps (aus Nutzersicht) wahllos
+ State Restoration: Verbergen, dass App beendet wurde
+ Ziel: Kein Unterschied zwischen Rückkehr zu laufender App und Neustart einer beendeten App
    + Vollständige Wiederherstellung des alten Zustands nicht immer sinnvoll
    
---

# Implementierung

+ Vorgehensweise:
    + State Restoration aktivieren
    + ViewController(hierarchie) wiederherstellen
    + Status/Daten wiederherstellen

---

# Implementierung

+ Beispielprojekt: <br />[github.com/shagedorn/StateRestorationDemo](https://github.com/shagedorn/StateRestorationDemo)
    + Tag Ausgangslage: `NO_STATE_RESTORATION`
    
![right, fit](https://raw.githubusercontent.com/shagedorn/StateRestorationDemo/master/Presentation/app_screenshot.png)

---

# Implementierung: Aktivierung

+ Opt-In im App Delegate:

```objectivec
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder;
 
- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder;
```

+ Restoration-Datei wird angelegt, enthält globale App-Infos (Version, Timestamp, Interface Idiom,...)
+ `return NO` nach inkompatiblen Updates oder großer Zeitspanne

^ noch keine Infos über ViewController enthalten  
^ konservative Variante: nach allen Updates deaktivieren

---

# Implementierung: Aktivierung

+ System nimmt Snapshot bevor App in den Hintergrund geht
    + Ersetzt `Default.png` (bzw. das Launch-NIB), falls mindestens ein ViewController State Preservation implementiert hat
    
+ Tag: `STATE_RESTORATION_OPT_IN`

^ Kein Snapshot, falls es nichts zum Wiederherstellen gibt

---

# Implementierung: Controller

+ Per-Controller Opt-In: `.restorationIdentifier`-Property setzen
    + IB/Storyboard oder Code
+ Geschafft: State Preservation
    + Gespeichert wird ein Pfad von Restoration-Identifiers
+ TODO: State Restoration
+ Tag: `RESTORATION_IDENTIFIERS`

^ Screenshots werden benutzt, aber Controller nicht wiederhergestellt  
^ Gilt auch für Tab/Navigation-Controller

---

# Implementierung: Controller

+ Wiederherstellung von ViewControllern (Optionen):
    1. Controller setzen `.restorationClass`
    1. AppDelegate instanziiert Controller auf Anfrage
    1. Implizit: Controller wurden zum Zeitpunkt der State Restoration bereits erstellt
    1. Implizit: Controller befinden sich im Storyboard
    
^ In der Reihenfolge, aber wegen Bsp.-App in anderer Reihenfolge erklärt  
^ Storyboard-Name wird bei Preservation mit gespeichert

---   

# Implementierung: Controller

+ Wiederherstellung von ViewControllern:
    + AppDelegate instanziiert Controller auf Anfrage

```objectivec
- (UIViewController *)application:(UIApplication *)application
    viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                            coder:(NSCoder *)coder;
```

+ `return nil`: Implizite Suche wird fortgesetzt

^ in Demo-App nicht verwendet

---   

# Implementierung: Controller

+ Wiederherstellung von ViewControllern:
    + Implizit: Controller wurden zum Zeitpunkt der State Restoration bereits erstellt
    + Reihenfolge:
          1. `application:willFinishLaunchingWithOptions:`
          1. [State Restoration]
          1. `application:didFinishLaunchingWithOptions:`
          
^ Controller in will... instanziieren: Deswegen bisher kein Erfolg

---

# Implementierung: Controller

+ Wiederherstellung von ViewControllern:

    + Status der Demo-App bei Tag `BASIC_STATE_RESTORATION`:
        + Initiale ViewController (Tabs) werden implizit hergestellt
        + Später erstellte ViewController nicht
        + Zustand der Controller/Views wird nicht hergestellt          
        
^ zweiten Punkt als nächstes fixen  
^ State Restoration bricht dort ab, wo sie zuerst fehlschlägt

---

# Implementierung: Controller

+ Wiederherstellung von ViewControllern:
    + Controller setzen `.restorationClass`
    + z.B. der Controller selbst: `UIViewControllerRestoration`-Protokoll implementieren

```objectivec
+ viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents 
                                        coder:(NSCoder *)coder;
```
^ Nur 1 Methode im Protokoll  
^ Hinweis auf Path vs. Name  
^ Nicht nötig bei VC aus Storyboards

---

# Implementierung: Controller

+ Wiederherstellung von ViewControllern:
    + Controller definieren `.restorationClass`
    + Opt-Out durch `nil`
        + Verhindert implizite Wiederherstellung aus Storyboards
    + Zugriff auf Coder: Entscheidung über erfolgreiche Restoration möglich
    + Tag: `RESTORATION_CLASS`

^ Test: Verhindert nicht wirklich Wiederherstellung aus Storyboards...

---

# Implementierung: State

+ `UIStateRestoring`-Protokoll:

```objectivec  

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeFloat:self.value forKey:"encodingKeyValue"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    ... // happens after viewDidLoad
}```

+ Primitive Werte und andere Objekte, die selbst State Restoration implementieren

^ neu in iOS 7  
^ Objekte: Shared References

---

# Implementierung: State

+ `decodeRestorableStateWithCoder:` wird nach `viewDidLoad` aufgerufen
+ Restoration kann nicht mehr abgebrochen werden
+ Views können selbst State Restoration implementieren
    + funktioniert nur beschränkt automatisch
+ Tag: `STATE_ENCODING`

^ Kein Zurück: Controller bereits neu erstellt  
^ Views: bessere Encapsulation/Reusability  
^ viewDidLoad-Notiz: Alternative: restorationClass wertet Coder aus

---

# Debugging

+ Auslöser für State Preservation: App geht in Hintergrund
    + nicht in Xcode oder App Switcher killen
    
+ Löschen von State Restoration-Daten:
    + Restoration schlägt fehl/App crasht
    + Nutzer beendet App
        + nicht im Simulator
        + kann mit iOS Profil umgangen werden

^ Endlosschleife vermeiden

---

# Debugging

+ Infos werden in `data.data`-Dateien abgelegt
    + Binary PLISTs: Auslesen mit `plutil`-Tool oder `restorationArchiveTool`
    + [https://developer.apple.com/downloads/](https://developer.apple.com/downloads/) -> Suche nach "restoration"
        + `restorationArchiveTool`
        + `StateRestoration DebugLogging` Profil
        + `StateRestoration DeveloperMode` Profil
        
---

# Debugging

+ Tipp: `data.data`-Suche im Simulator-Ordner in Finder-Sidebar speichern
+ Aufruf: `restorationArchiveTool path/to/data.data`

![inline, fill](https://raw.githubusercontent.com/shagedorn/StateRestorationDemo/master/Presentation/data_example.png)

---

# Debugging

+ DebugLogging Profil: Sehr verbose, inkl. Zeitmessung

+ `Warning: Unable to create restoration in progress marker file`
    + Keine `data.data`-Datei gefunden
    
![right, fit](https://raw.githubusercontent.com/shagedorn/StateRestorationDemo/master/Presentation/log_example.png)

---

# Debugging

+ `Can't find Child View Controller at index 1 with identifier TabController/:[1]:/NavigationController/:[1]:/_TtC20StateRestorationDemo18CityViewController, truncating child array`
    + Controller nicht gefunden

---

# GOTCHAs/Tipps

+ `.restorationIdentifier` durch Überschreiben des Getters setzen
    + Ermöglicht State Preservation: `data.data` ist ok
    + Keine Restoration: Registrierung im Setter?

+ `.restorationIdentifier` in `init` setzen:
    + Encapsulation vs. Wiederverwendbarkeit

^ Wiederverwendbarkeit: Controller wird immer wiederhergestellt, nicht offensichtlich

---

# GOTCHAs/Tipps

+ Nicht alle Subviews werden von Snapshots erfasst
    + Bsp.: AlertViews
    + Konsistenz zwischen Snapshots und App anstreben
    + Keine temporären Fehlermeldungen wiederherstellen
    + Snapshot ignorieren:

```objectivec
[[UIApplication sharedApplication] ignoreSnapshotOnNextApplicationLaunch];
```
---

# Tipps

+ `.window` muss nicht explizit gesichert werden, aber Preservation des Windows fügt unter iOS 8 Informationen über Size Classes hinzu
    + Tag: `SIZE_CLASSES`

---

# Quellen & Links

+ Doku: [https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/StatePreservation/StatePreservation.html](https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/StatePreservation/StatePreservation.html)
    + Ausführlich, aber nicht ganz aktuell
    + grundsätzlich ab iOS 6, Ergänzungen (fehlen hier) in iOS 7

^ u.a. Hinweis zu UIDataSourceModelAssociation
  
+ WWDC 2013 Session 222: What's New in State Restoration
    + Ausführlich & aktuell

^ New: Custom Objects & Snapshots  
^ Doku: Tools-Support nicht erwähnt  
^ beides empfehlenswert  
^ Apple Sample Code verfügbar  
