REM Konfigurationsdateien kopieren, wenn es sie nicht gibt

if not exist config.json copy config.json.example config.json
if not exist paths.cmd copy paths.cmd.example paths.cmd
call paths.cmd

REM Ordner anlegen, wenn noch nicht vorhanden

if not exist %config_directory% xcopy /s example_configs %config_directory%
if not exist %logs_directory% mkdir %logs_directory%
if not exist %export_directory% mkdir %export_directory%
if not exist %mappings_directory% mkdir %mappings_directory%

set tooltip_mapping_target=%mappings_directory%tags.da
if not exist %tooltip_mapping_target% (
  copy %tooltip_mapping% %tooltip_mapping_target%
)

REM Docker Container aufsetzen und starten

docker build -t bsvp-csv-export .
docker run^
  -v %data_directory%:/data:ro^
  -v %config_directory%:/configs:ro^
  -v %absolute_path%%mappings_directory%:/mappings:ro^
  -v %absolute_path%%export_directory%:/export^
  -v %absolute_path%%logs_directory%:/logs^
  -p 0.0.0.0:5000:5000^
  bsvp-csv-export python3 server.py
