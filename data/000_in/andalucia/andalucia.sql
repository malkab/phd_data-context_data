/**

  SQL table creation to recreate the Andalucía table. EPSG: 3035 (LAEA)

*/

begin;

create table andalucia(
  gid integer,
  geom geometry(MULTIPOLYGON, 3035)
);

alter table andalucia
add constraint andalucia_pkey
primary key(gid);

create index andalucia_geom_gist
on andalucia
using gist(geom);

\copy andalucia from andalucia.csv with delimiter '|' csv header quote '"' encoding 'utf-8' null '-'

commit;

vacuum analyze andalucia;
