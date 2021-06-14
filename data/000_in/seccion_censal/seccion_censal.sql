/**

  SQL table creation to recreate the seccion censal table. EPSG: 3035 (LAEA)

*/

begin;

create table seccion_censal(
  gid integer,
  codigo varchar(10),
  distrito varchar(2),
  seccion varchar(3),
  poblacion integer,
  cod_mun varchar(5),
  municipio varchar(150),
  provincia varchar(50),
  geom geometry(MultiPolygon, 3035)
);

create index seccion_censal_geom_gist
on seccion_censal using gist(geom);

\copy seccion_censal from 'seccion_censal.csv' with csv header quote '"' encoding 'utf-8' null '-'

commit;

vacuum analyze seccion_censal;
