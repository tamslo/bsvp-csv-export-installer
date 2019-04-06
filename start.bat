
REM TODO: Konfiguration aus paths.txt auslesen
REM TODO: Ordner für mappings, export und logs erstellen, wenn noch nicht vorhanden
REM TODO: Dateien mit mappings kopieren
REM TODO: Example configs in richtige configs kopieren (config.json, paths.txt, configs/)

docker build -t bsvp-csv-export .

REM TODO: Docker image ausführen mit expose Port 5000 und Volumes (Read-only Volumes: data, configs, mappings; Normale Volumes: export, logs)
