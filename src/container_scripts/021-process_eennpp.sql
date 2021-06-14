/**

  Process info.

*/
\c cell_raw_data

begin;

-- Process nucleo_poblacion
create table context.eennpp (
  gid integer,
  figura varchar(150),
  nombre varchar(150),
  geom geometry(MultiPolygon, 3035)
);

insert into context.eennpp
select
  row_number() over (),
  figura,
  nombre,
  st_transform(geom, 3035)
from context_process.eennpp
where st_isvalid(geom);

alter table context.eennpp
add constraint eennpp_pkey
primary key(gid);

create index eennpp_geom_gist
on context.eennpp
using gist(geom);

commit;
