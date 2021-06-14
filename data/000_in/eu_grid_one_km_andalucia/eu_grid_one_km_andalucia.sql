/**

  SQL table creation to recreate the EU GRID 1KM table. EPSG: 3035 (LAEA)

*/

begin;

create table eu_grid_one_km(
    gid integer,
    cellcode varchar(15),
    eoforigin integer,
    noforigin integer,
    geom geometry(MULTIPOLYGON, 3035)
);

alter table eu_grid_one_km
add constraint eu_grid_one_km_pkey
primary key(gid);

create index eu_grid_one_km_geom_gist
on eu_grid_one_km
using gist(geom);

\copy eu_grid_one_km from eu_grid_one_km_andalucia.csv with delimiter '|' csv header quote '"' encoding 'utf-8' null '-'

commit;

vacuum analyze eu_grid_one_km;
