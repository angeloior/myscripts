--61
select count(*) from kpid;

--62
select count(*) from kpid;

--63
select * from rkpi join simu on simu.idno = rkpi.simu where kpid = 'zTSTA_speedPASTA' and inst is not null order by simu;

--64 non c'e'

--65
select count (*) from (select simu.idno, rkpi.valu, rkpi.valn, simu.dscr, simu.inst from rkpi, simu where rkpi.simu = simu.idno and rkpi.kpid = 'zTSTA_speedPASTA' and simu.inst is not null order by simu.inst desc) as v

--66
select idno from simu where inst is not null limit 1

--dopo
Log into the database and run the following query:
select 	*  from
	rkpi,
	simu
where  simu.idno = <simulation_id>
        AND rkpi.simu = simu.idno  
        AND simu.run_start_inst is not null 
order by
        simu.run_start_inst desc

--70
SELECT IDNO FROM SCEN;

--74
select scen from sims, simu where sims.simu = simu.idno AND simu.run_start_inst is not null limit 1

--74 bis
select   *  from
	rkpi,
	simu,
	sims
where 
        rkpi.kpid = 'zTSTA_speedPASTA'
        AND rkpi.simu = simu.idno 
        AND sims.simu = simu.idno
        AND sims.scen = <scenario_id>
        AND simu.run_start_inst is not null 
order by
        simu.run_start_inst desc


--79
select * from lkst where strt = 578558008 and fsnd = 683919680
which gives in the link field the link related to the selected street, and then:
select * from rlin_tsys_tre_rltm where link = 774140116

--81
select * from 
(
	with input as
	(select * from get_valid_runs_in_day('2018-02-02 00:00:00'))
	select *,get_last_arrival_time_for_run(input.idno::text) arrival from input
) t
where t.arrival < 240000;

--82
select * from 
(
	with input as
	(select * from get_valid_runs_in_day('2018-02-02 00:00:00'))
	select *,get_last_arrival_time_for_run(input.idno::text) arrival from input
) t
where t.arrival < 240000;

		

