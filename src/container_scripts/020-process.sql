/**

  Process info.

*/
\c cell_raw_data

begin;

create schema context;

-- Process nucleo_poblacion
create table context.nucleo_poblacion (
  gid integer,
  codigo_nd varchar(11),
  cod_pob varchar(15),
  nombre_pob varchar(254),
  nivel varchar(3),
  estado varchar(3),
  geom geometry(MultiPolygon, 3035)
);

insert into context.nucleo_poblacion
select
  gid,
  codigo_nd,
  cod_pob,
  nombre_pob,
  nivel,
  estado,
  st_transform(geom, 3035) as geom
from context_process.nucleo_poblacion
where st_isvalid(geom);

alter table context.nucleo_poblacion
add constraint nucleo_poblacion_pkey
primary key(gid);

create index nucleo_poblacion_geom_gist
on context.nucleo_poblacion
using gist(geom);

-- Catálogo para nivel
create table context.nucleo_poblacion_nivel (
  codigo varchar(3),
  descripcion varchar(150)
);

insert into context.nucleo_poblacion_nivel
values ('DIS', 'Disperso');

insert into context.nucleo_poblacion_nivel
values ('SEC', 'Seccionado');

insert into context.nucleo_poblacion_nivel
values ('CAB', 'Cabecera');

-- Create materialized view with the nivel description
create materialized view context.nucleo_poblacion_descrito as
select
  a.gid,
  a.codigo_nd,
  a.cod_pob,
  a.nombre_pob,
  a.nivel,
  b.descripcion as nivel_descripcion,
  a.estado,
  a.geom
from
  context.nucleo_poblacion a inner join
  context.nucleo_poblacion_nivel b on
  a.nivel = b.codigo;

grant usage on schema context
to cell_readonly;

grant select on all tables in schema context
to cell_readonly;

commit;

set search_path = context, public;

\cd ../../data/000_in/andalucia/
\i ./andalucia.sql

\cd ../eu_grid_one_km_andalucia/
\i ./eu_grid_one_km_andalucia.sql

\cd ../municipio/
\i ./municipio.sql

\cd ../provincia/
\i ./provincia.sql

\cd ../seccion_censal/
\i ./seccion_censal.sql

\cd ../../../src/container_scripts/

set search_path = public;
