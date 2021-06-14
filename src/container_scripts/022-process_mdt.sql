\c cell_raw_data

\echo
\echo -------------------------
\echo Loading MDT data...
\echo -------------------------
\echo

begin;

create schema temp_mdt;

create schema mdt;

-- Creates the MDT data

create table temp_mdt.mdt_csv(
    x integer,
    y integer,
    z float
);

\echo Loading raw data...
\echo

\copy temp_mdt.mdt_csv from '../../data/000_in/mdt/mdt.csv' with csv header

create table mdt.mdt(
    gid integer,
    h float,
    geom geometry(POINT, 3035),
    primary key (gid)
);

create index mdt_geom_gist
on mdt.mdt
using gist(geom);

\echo Processing raw data...
\echo

insert into mdt.mdt
select
    row_number() over (),
    z,
    st_transform(st_setsrid(st_makepoint(x, y), 25830), 3035)
from
    temp_mdt.mdt_csv
where z>=0;

drop schema temp_mdt cascade;

commit;

\echo Vacuuminzing mdt.mdt...

vacuum analyze mdt.mdt;
