docker build -t bsvp-csv-export .
REM Konfiguration aus paths.txt auslesen
REM Ordner für mappings, export und logs erstellen, wenn noch nicht vorhanden
REM Dateien mit mappings kopieren
REM Docker image bauen
REM Docker image ausführen mit expose Port 5000 und Volumes
REM Read-only Volumes: data, configs, mappings
REM Normale Volumes: export, logs
