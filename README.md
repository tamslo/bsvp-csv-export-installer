# BSVP CSV Exporter

Python-basierter Exporter für die Umwandlung von BSVP zu CSV Dateien.

Trello: https://trello.com/b/ug9q2Eif/bsvp

Diese README sieht komisch aus? Dann öffne sie mit einem Editor mit Markdown-Erweiterung (z.B. Notepad++) oder mit einem Online-Viewer (z.B. [Github](https://jbt.github.io/markdown-editor/)).

Bei Fragen und Problemen mit dem Export meldet euch gerne bei mir unter tamaraslosarek@gmail.com.

1.  [Erste Schritte](#erste-schritte)
2.  [Export-Konfigurationen](#export-konfigurationen)
3.  [Fehlerbehebung](#fehlerbehebung)

<a name="erste-schritte" />

## Erste Schritte

Um die Exporter ausführen zu können, wird lediglich Docker benötigt (Windows Installer: https://docs.docker.com/docker-for-windows/install/).

Allgemeine Konfigurationsdateien werden automatisch mit Standardwerten erstellt. Um diese zu überschreiben, können die Dateien kopiert, umbenannt und angepasst werden:

- `config.json` aus [`config.example.json`](config.json.example)
- `paths.txt` aus [`paths.example.txt`](paths.txt.example)

Zusätzlich müssen Export-Konfigurationsdateien (siehe unten) angelegt werden. Der Ordnername kann in der `paths.txt` Datei geändert werden, standardmäßig heißt er `configs`. Beispiele, wie Konfigurationen aussehen, sind in [`example_configs`](example_configs) abgelegt. Wenn es keinen `configs` Ordner gibt, wird wie bei den allgemeinen Konfigurationsdateien automatisch der `example_configs` Ordner kopiert.

Um die Webapp zu starten, muss das `start.bat` Skript ausgeführt werden (über die Kommandozeile oder per Doppelklick), das automatisch auf die aktuellste Version updated. Die App ist dann unter `https://localhost:5000` (bzw. anstatt `localhost` die IP-Adresse des Rechners im Netzwerk) erreicht werden.

<a name="export-konfigurationen" />

## Export-Konfigurationen

Die Kofigurations-Dateien sind im JSON Format hinterlegt. Es empfiehlt sich, mit einem Editor mit JSON-Erweiterung zu arbeiten, der auf Fehler aufmerksam machen kann (z.B. Notepad++) oder die JSON-Dateien mit einem Online-Validierer (z.B. [JSONLint](https://jsonlint.com/)) zu überprüfen. Es gibt muss eine Datei `Shop.json` für den allgemeinen BSVP Daten-Export nach Herstellern geben und einen Ordner `Konfigurator`, der die Konfigurationen für den Konfigurator-Export beinhaltet.

### Shop

Durch die `Shop.json` werden Felder angegeben, die in die CSV Datei pro Hersteller geschrieben werden. Als Bezeichner eines Feldes wird der Name angegeben, wie er in der CSV erscheint, als Wert ein Objekt, das den Wert beschreibt:

```json
{
  "XTSOL": { "wert": "XTSOL" },
  "action": { "prod": "ACTION" },
  "p_dics": { "ilugg": "DICOUNT" },
  "p_cat.": { "iterierbar": { "praefix": "CAT", "max": { "wert": "5" } } },
  "p_image.": {
    "iterierbar": {
      "praefix": "PIC.",
      "max": { "ilugg": "PicCount" },
      "start": "1"
    }
  },
  "p_desc.de": {}
}
```

Für den Wert wird der Typ angegeben und der dazugehörige Wert:

- `wert`: Es wird ein fester Wert eingetragen
- `prod`: Es wird der Name des Feldes in der `.prod`-Datei angegeben
- `ilugg`: Es wird der Name des Feldes in der `.ilugg`-Datei angegeben
- `iterierbar`: Es müssen der Präfix des Feldes in der `.prod`-Datei und der Maximalwert angegeben werden; zusätzlich kann der `start` Index (standardmäßig `0`) angegeben werden

Für Werte, die gesondert zusammengebaut werden müssen, wird ein leeres Objekt (`{}`) bzw. werden zusätzliche Spezifikationen angegeben:

- `p_desc.de`: leeres Objekt
- `p_movies.de`: leeres Objekt
- `products_energy_efficiency_text`: Liste von Feldern, die in die Tabelle geschrieben werden (`{ "fields": [ "0000015", "0000089" ] }`)

### Konfigurator

Der Dateiname der jeweiligen JSON Datei bestimmt den Dateinamen der CSV Datei, die erstellt wird (Bsp. `Kühlschränke.json` wird zu `Kühlschränke.csv`). Es werden der Produkttyp und Felder angegeben, die exportiert werden sollen. Das Format sieht wie folgt aus:

```json
{
  "produkttyp": "Kühlschrank",
  "hersteller_export": ["Nordcap", "KBS"],
  "felder": {
    "ARTNR": "artikelnummer",
    "0000017": "anzahl_regalboeden",
    "0000089": "energieverbrauch"
  },
  "kombinationen": {
    "temperaturbereich": {
      "separator": "|",
      "felder": ["0000226", "0000225"]
    }
  },
  "formatierungen": {
    "punkt_zu_komma": ["0000089"],
    "ersetzungen": [
      {
        "vorher": ["ja"],
        "nachher": "yes",
        "felder": ["0000241", "0000261", "0000003", "0000091"]
      },
      {
        "vorher": ["nein"],
        "nachher": "no",
        "felder": ["0000241", "0000261", "0000003", "0000091"]
      },
      {
        "vorher": ["CNS 1.4301", "CNS 1.4301 (AISI304)", "CNS 18/10"],
        "nachher": "CNS",
        "felder": ["0000158"]
      }
    ]
  }
}
```

Der Produkttyp muss so angegeben werden, wie er in den BSVP-Produkt-Dateien steht, allerdings ohne HTML kodierte Zeichen (Bsp. `PUM::Produkttyp::K&uuml;hlschrank`, in der Konfiguration steht `"Kühlschrank"`).

Die Felder werden als Key-Value-Paar angegeben, wobei der Key das Feld so wie es in den BSVP-Produkt-Dateien steht ist (Bsp. `"ARTNR"`) bzw. als numerische ID für das Attribut-Feld (Bsp. `"0000017"` für Anzahl Regalböden). Der Value ist der Name des Feldes wie er in der CSV Datei angegeben werden soll (Bsp. `"artikelnummer"` oder `"anzahl_regalboeden"`).

#### Lieferanten CSVs

Neben der globalen CSV Datei können CSV Dateien pro Lieferant erstellt werden. Dazu kann in dem Feld `"hersteller_export"` eine Liste von Lieferantennamen angegeben werden. Die resultierende CSV Datei heißt dann `KONFIGURATION_HERSTELLER.csv`, also zum Beispiel `Kühlschrank_Nordcap.csv`.

#### Kombinationen von Werten

Kombinationen von Werten können angegeben werden, sie müssen es aber nicht. Der Bezeichner einer Kombination entspricht der Bezeichung der Spalte in der CSV Datei. Als Wert werden ein Separator (Bsp. `"|"`) und Feldnamen bzw. Attribut-IDs in einer Liste (eckige Klammern) angegeben.

#### Formatierung von Werten

Formatierungen können in dem Feld `"formatierungen"` angegeben werden. Einfache Ersetzungen von Werten (Bsp. die Werte `["CNS 1.4301", "CNS 1.4301 (AISI304)", "CNS 18/10"]` sollen immer zu `"CNS"` geändert werden) können im untergeordneten Feld `"ersetzungen"` angegeben werden. Für komliziertere Formatierungen gibt es folgende vordefinierte Regeln:

- `"punkt_zu_komma"`: der Punkt (in einer Kommazahl) wird zu einem Komma geändert
- `"bereich_von_null"`: zu einem Wert wird "0|" hinzugefügt

Zu einer Ersetzung bzw. Regel kann eine Liste von Attribut-IDs angegeben werden, auf die diese dann angewendet werden.

<a name="fehlerbehebung" />

## Fehlerbehebung

Hier sind Lösungen zu häufigen Fehlern aufgeführt, geordnet nach den Fehlerarten, die in der Kommandozeile ausgegeben werden.

### PermissionError

```
PermissionError: [WinError 32] The process cannot access the file because it is being used by another process
```

Es könnte sein, dass eine CSV Datei, die überschrieben werden soll noch in einem anderen Programm wie Excel geöffnet ist, bitte schließen und den Exporter erneut starten.

### JSONDecodeError

Beim JSON Format empfiehlt es sich allgemein, mit einem Editor zu arbeiten, der auf Syntax-Fehler aufmerksam macht. Alternativ können JSON Dateien auch online validiert werden (z.B. unter https://jsonlint.com/).

```
json.decoder.JSONDecodeError: Expecting property name enclosed in double quotes: line 19 column 5 (char 566)
```

Eine der JSON Konfigurationen enthält ein Komma in der letzten Zeile, das bitte entfernen.
