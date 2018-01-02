set lines 400
set pages 1000
BREAK ON STATUS SKIP 1
column kill_sql for a55
SELECT 
   distinct 'ALTER SYSTEM KILL SESSION '''||SID||','||SERIAL#||',@'||gv$session.INST_ID||''' IMMEDIATE;' Kill_SQL,
   status,
   username,
   machine,
   gv$sql.sql_id,
   gv$sql.module,
   program,
   substr(sql_text,1,50) text,
   substr(program,length(program)-5,6) program,
   decode(state,'WAITING',event,'NOT WAITING') event,
   decode(state,'WAITING',to_char(seconds_in_wait),'NOT WAITING') seconds_in_wait
FROM gv$session,gv$sql
WHERE gv$session.sql_id=gv$sql.sql_id(+)
and gv$session.inst_id=gv$sql.inst_id(+)
and gv$session.username is not null
ORDER BY status,username,machine
/

s