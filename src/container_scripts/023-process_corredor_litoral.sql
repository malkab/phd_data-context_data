\c cell_raw_data

\echo
\echo -------------------------
\echo Loading corredor_litoral data...
\echo -------------------------
\echo

begin;

create schema corredor_litoral_process;

-- Creates the MDT data

create table corredor_litoral_process.corredor_litoral_csv(
    gid integer,
    type varchar(50),
    geom geometry(MultiPolygon, 4326)
);

\echo Loading raw data...
\echo

\copy corredor_litoral_process.corredor_litoral_csv from '../../data/000_in/corredor_litoral/corredor_litoral.csv' with delimiter ';' csv header

create table context.corredor_litoral(
    gid integer,
    type varchar(50),
    geom geometry(MultiPolygon, 3035),
    primary key (gid)
);

create index corredor_litoral_geom_gist
on context.corredor_litoral
using gist(geom);

\echo Processing raw data...
\echo

insert into context.corredor_litoral
select
    gid,
    type,
    st_transform(geom, 3035)
from
    corredor_litoral_process.corredor_litoral_csv;

drop schema corredor_litoral_process cascade;

commit;

\echo Vacuuminzing context.corredor_litoral...

vacuum analyze context.corredor_litoral;
