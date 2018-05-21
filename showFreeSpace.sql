select	tablespace_name		"Tablesapce",
        round(bytes/1024/1024/1024,1)			"Size GB",
       	round(nvl(bytes-free,bytes)/1024/1024/1024,1)	"Used GB",
       	round(nvl(free/1024/1024/1024,0),1)		"Free GB",
       	round(nvl(100*(bytes-free)/bytes,100),1)	"% Used"
from(
	select ddf.tablespace_name, sum(dfs.bytes) free, ddf.bytes bytes
	FROM (select tablespace_name, sum(bytes) bytes
	from dba_data_files group by tablespace_name) ddf, dba_free_space dfs
	where ddf.tablespace_name = dfs.tablespace_name(+)
	group by ddf.tablespace_name, ddf.bytes)
union all
select tablespace_name,
sum(round((bytes_used+bytes_free)/1024/1024/1024,1)),
sum(round(bytes_used/1024/1024/1024,1)),
sum(round(bytes_free/1024/1024/1024,1)),
NULL
from V$TEMP_SPACE_HEADER
group by tablespace_name
order by "Free GB";

--sum(round(bytes_used/1024/1024/1024,1))/sum(round(bytes_free/1024/1024/1024,1))*100

/*
select rpad(tablespace_name,30,'.')||rpad(file_name,70,'.')||round(bytes/1024/1024/1024,1) as "File Size (GB)"
from dba_data_files
order by tablespace_name,file_name,bytes;
*/

PROMPT Tips:
PROMPT ====
PROMPT
PROMPT select file_name,round(bytes/1024/1024/1024) SIZE_IN_GB,autoextensible from dba_data_files where tablespace_name = 'DEV_D'
PROMPT alter database datafile 'xxx' resize xG
PROMPT alter tablespace DEV_D add datafile '<full_path>' size xG autoextend off;
PROMPT

/*
finding objects at the end of high water mark HWM
From Jonathan Lewis:
https://jonathanlewis.wordpress.com/tablespace-hwm/

define m_tablespace = 'TEST_8K'
 
select
    file_id,
    block_id,
    block_id + blocks - 1   end_block,
    owner,
    segment_name,
    partition_name,
    segment_type
from
    dba_extents
where
    tablespace_name = '&m_tablespace'
union all
select
    file_id,
    block_id,
    block_id + blocks - 1   end_block,
    'free'          owner,
    'free'          segment_name,
    null            partition_name,
    null            segment_type
from
    dba_free_space
where
    tablespace_name = '&m_tablespace'
order by
    1,2
/



*/