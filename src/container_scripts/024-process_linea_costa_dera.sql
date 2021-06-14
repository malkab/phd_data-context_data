\c cell_raw_data

\echo
\echo -------------------------
\echo Loading linea_costa_dera data...
\echo -------------------------
\echo

begin;

create schema linea_costa_dera_process;

-- Creates the linea costa from DERA data

create table linea_costa_dera_process.linea_costa_dera_csv(
    gid integer,
    geom geometry(MultiLinestring, 25830)
);

\echo Loading raw data...
\echo

\copy linea_costa_dera_process.linea_costa_dera_csv from '../../data/000_in/linea_costa_dera/linea_costa_dera.csv' with delimiter '|' csv header

create table context.linea_costa_dera(
    gid integer,
    geom geometry(MultiLinestring, 3035),
    primary key (gid)
);

create index linea_costa_dera_geom_gist
on context.linea_costa_dera
using gist(geom);

\echo Processing raw data...
\echo

insert into context.linea_costa_dera
select
    gid,
    st_transform(geom, 3035)
from
    linea_costa_dera_process.linea_costa_dera_csv;

drop schema linea_costa_dera_process cascade;

commit;

\echo Vacuuminzing context.linea_costa_dera...

vacuum analyze context.linea_costa_dera;
