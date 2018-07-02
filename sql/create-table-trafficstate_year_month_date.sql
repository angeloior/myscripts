CREATE TABLE trafficstate_2016_07_22
(
  cloc integer,
  strt integer,
  fsnd integer,
  tsnd integer,
  tsys integer,
  cdat timestamp without time zone,
  fdat timestamp without time zone,
  ldat timestamp without time zone,
  flow double precision,
  speed double precision,
  density double precision,
  reliability integer,
  source character varying(255),
  fprg double precision,
  tprg double precision,
  status integer,
  strt_sped double precision,
  strt_hier integer,
  strt_shap geometry(LineString,4326),
  metadata json
)
WITH (
  OIDS=FALSE
);
ALTER TABLE trafficstate_2016_07_22
  OWNER TO postgres;