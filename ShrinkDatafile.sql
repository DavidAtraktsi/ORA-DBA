set pages 5000
set lines 200
SELECT 
CEIL( (NVL(HWM,1)*(bytes/blocks))/1024/1024 ) SMALLEST_MB,
CEIL( BLOCKS*(bytes/blocks)/1024/1024) CURRSIZE_MB,
CEIL( BLOCKS*(bytes/blocks)/1024/1024) - CEIL( (NVL(HWM,1)*(bytes/blocks))/1024/1024 ) SAVINGS_MB,
'alter database datafile '''||file_name||''' resize '||CEIL( (NVL(HWM,1)*(bytes/blocks))/1024/1024 )||'M;' ALTER_CMD
FROM DBA_DATA_FILES DBADF, ( SELECT FILE_ID, MAX(BLOCK_ID+BLOCKS-1) HWM FROM DBA_EXTENTS GROUP BY FILE_ID ) DBAFS
WHERE DBADF.FILE_ID = DBAFS.FILE_ID(+) 
ORDER BY SAVINGS_MB;

-- simpler (for terminal):
set timing on




set timinng on
set pages 5000
set lines 200
SELECT 
'alter database datafile '''||file_name||''' resize '||CEIL( (NVL(HWM,1)*(bytes/blocks))/1024/1024 )||'M; --'||(CEIL( BLOCKS*(bytes/blocks)/1024/1024) - CEIL( (NVL(HWM,1)*(bytes/blocks))/1024/1024 ))||' MB' ALTER_CMD
FROM DBA_DATA_FILES DBADF, ( SELECT FILE_ID, MAX(BLOCK_ID+BLOCKS-1) HWM FROM DBA_EXTENTS GROUP BY FILE_ID ) DBAFS
WHERE DBADF.FILE_ID = DBAFS.FILE_ID(+) 
ORDER BY CEIL( BLOCKS*(bytes/blocks)/1024/1024) - CEIL( (NVL(HWM,1)*(bytes/blocks))/1024/1024 );

