/**

  SQL table creation to recreate the municipio table. EPSG: 3035 (LAEA)

*/

begin;

create table provincia(
  gid integer,
  provincia varchar(50),
  geom geometry(MultiPolygon, 3035)
);

create index provincia_geom_gist
on provincia using gist(geom);

\copy provincia from 'provincia.csv' with csv header quote '"' encoding 'utf-8' null '-'

commit;

vacuum analyze provincia;
