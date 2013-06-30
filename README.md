# CloudForecast

Server resource monitoring framework

WARNING: Alpha quality code

A tool to help with (server) resource monitoring.  This is meant to be a
framework for gathering information and a light wrapper around RRDTool.

CloudForecast runs in four separate processes.

 - Crawler daemon
 - Web server
 - Data collector (Gearman worker)
 - RRD file updater (Gearman worker)

It is also possible to run without Gearman for small-scale montioring.
The processes are diagramed in `docs/cloudforecast.png`.

## Crawler Daemon

    $ ./cloudforecast_radar -r -c cloudforecast.yaml -l server_list.yaml

 - Crawls every five (5) minutes
 - With the restart option (`-r`), will automatically restart when a library or
   settings file is updated
 - Specify settings file with `-c`
 - Specify server list with `-l`


## Web Server

    $ ./cloudforecast_web -r -p 5000 -c cloudforecast.yaml -l server_list.yaml

 - Serves graphs
 - `-p` port for httpd
 - `-o` (or `-host`) IP at which httpd will listen (defaults to all IPs)
 - `--allow-from` IP address or segment from which to accept connections (can
   specify multiple IPs, such as 192.168.0.1 or 192.168.0.1/24), nothing specified
   implies all connections will be allowed
 - `--front-proxy` IP address or segment of reverse proxy, if necessary (can
   specify multiple IPs)

## Data Collector (Gearman Worker)

    $ ./cf_fetcher_worker -r -c cloudforecast.yaml \
      -max-workers 2 -max-request-per-child 100 -max-exection-time 60

 - A Gearman worker to collect resource data
 - `-max-worker` number of workers to prefork
 - `-max-request-per-child` maximum requests per child (process will be
   respawned if this number is exceeded)
 - `-max-exection-time` maximum time to allow for a worker to run

## RRD Updater (Gearman Worker)
    $ ./cf_updater_worker -r -c cloudforecast.yaml \
      -max-workers 2 -max-request-per-child 100 -max-exection-time 60

 - Writes resource info for Gearman to RRD file

## Environment Variables

When `CF_DEBUG=1` debug log will be sent to output.
