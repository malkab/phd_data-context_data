#!/bin/bash

# Imports nucleos_poblacion shapefile

PGCLIENTENCODING=UTF-8 ogr2ogr \
  -f "PostgreSQL" PG:"host=${MLKC_CONTEXT_DATA_HOST} user=postgres dbname=cell_raw_data password=${MLKC_CONTEXT_DATA_POSTGIS_PASSWORD} port=${MLKC_CONTEXT_DATA_PG_EXTERNAL_PORT}" \
  -a_srs "EPSG:25830" -lco SCHEMA=context_process -lco FID=gid \
  -lco OVERWRITE=YES -nln nucleo_poblacion \
  -lco GEOMETRY_NAME=geom -nlt MULTIPOLYGON \
  -lco PRECISION=YES \
  ../../data/000_in/nucleo_poblacion/07_01_Poblaciones.shp
