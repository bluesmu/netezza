1. 复制表结构及其数据：

create table table_name_new as select * from table_name_old

2. 只复制表结构：

create table table_name_new as select * from table_name_old where 1=2;

或者：

create table table_name_new like table_name_old

3. 只复制表数据：

如果两个表结构一样：

insert into table_name_new select * from table_name_old

如果两个表结构不一样：

insert into table_name_new(column1,column2...) select column1,column2... from table_name_old



alter table 表名 modify column(列名 类型（长度）)  修改列的属性
alter table old_table_name rename to new_table_name; 修改表名
alter table 表名 rename column  老列名 to 新列名



select * from _V_session

自增列：int identity(1,1)\n

oracle 
创建标准索引： 
CREATE  INDEX 索引名 ON 表名 (列名)  TABLESPACE 表空间名; 
创建唯一索引: 
CREATE unique INDEX 索引名 ON 表名 (列名)  TABLESPACE 表空间名; 
创建组合索引: 
CREATE INDEX 索引名 ON 表名 (列名1,列名2)  TABLESPACE 表空间名; 
创建反向键索引: 
CREATE INDEX 索引名 ON 表名 (列名) reverse TABLESPACE 表空间名; 

select procedure from _v_procedure where proceduresource like '%%'
select *
from _v_relation_column

select count(*),count(distinct column_name) from smb_qa_eb..table_name;    看是否有重复数据

decode(value,if1,then1,if2,then2,...,else)   如果value 等于if1时，DECODE函数的结果返回then1,...,如果不等于任何一个if值，则返回else。


select * from smb_qa_eb..table_name limit 10 offset 5;    取从第五行开始的十行数据


http://blog.csdn.net/qq_35052774/article/details/52184164 oracle误删除恢复方式，flashback

_v_qryhist 搜索执行的SP每一部分的具体时间

*****************************************************************************
putty 跑sp ： hqdellnz06 nzsql   
select * from smb_stage..meta_extract_files;
我的putty路径：/mnt/delsm/dev/infa_shared/srcfiles/bmu
export NZ_USER=
export NZ_PASSWORD=
./scr_extract_data_to_file_dynamic.sh smb_preprod_stage -i 13
wc -l
head -100 XXX.txt> xxx.txt
grep -o ‘字符串’ file_name |wc -l  找文件中字符串出现次数
切分文件为10 million records per file : ./dell_split_files.sh -file_dir /mnt/delsm/dev/infa_shared/srcfiles/bmu/HH_IN_8259 -file_mask post_cdi_HH_extract_20171130_00.txt -threshold 10000000 -header_flg Y
分别压缩文件夹下的所有子文件： ls |grep csv  |while read line;do zip $line.zip $line;done
*******************************************************************************************
查动态语句错误： raise notice 'v_sql %',v_sql;



smb_preprod_stage   这个db里面一般会存raw stg hist error这种表 NZ06

vw_error_summery
从error_表找file_id；
从error_event找error_code;
从lookup_error_code看error_code对应的错误是什么


去重操作：
create table dell_2100_emea_bau_iid_dedupe
as select a.* from 
(select a.*,row_number() over(partition by individual_iid order by email_id desc,language_code asc) as row_id from dell_2100_emea_bau_iid a) a
where a.row_id=1; 
 

code to identify tables on one data slice
select sys.objid, sys.owner, objname as table_name,
       sys.createdate, database as db_name,
       hwid as spu_id, dsid,
       (allocated_bytes/1048576) as allocated_mbytes
  from _v_sys_relation_xdb sys,
       _v_sys_object_dslice_info ds
where ds.tblid = sys.objid
  and ds.hwid = 2220    --- SPU ID
  and ds.dsid = 1       --- ID
order by  allocated_mbytes desc, table_name,db_name 
limit 999;


smb_qa_wrk_ea
sp_wrk_stg_from_ai_all 
sp_stg_from_ai_interim_all 
sp_stg_from_ai_current_all 
->  sp_stg_from_ai_current_daily 
1. stg_from_ai_interim 和 stg_from_ai_current 需要copy到wrk-ea
2. sp_wrk_stg_from_ai 的source需要改成你们cdi回来的表
3. 需要找一下sp_stg_from_ai_interim 和sp_stg_from_ai_current_daily  用到了哪些表   建view指eb
数据是否导到stg_from_ai, stg_from_ai_interim 和 stg_from_ai_current 可以用sequence num来check

pick best
sp_pick_best_emea_apj_part1
sp_pick_best_emea_apj_part2
sp_pick_best_emea_apj_part3
sp_pick_best_emea_apj_part4
sp_pick_best_emea_apj_part5 



HH stg_from_ai_current 

1.	Copy dim_plat_phone/dim_plat_email from prod to dev
2.	Create views on dev   
3.	Run the following SPs.
4.	Test. 
1)	All HH emails and phone will be loaded into dim_plat_phone/ dim_plat_email
2)	Take a look at market flg for HH emails and phones.   Y, N, U

The following SPs are to load data into dim_plat_phone

12.03 sp_wrk_plat_phone :  stg_from_ai_current -> wrk_plat_phone  (wrk_ea)
12.04 sp_dim_plat_phone : wrk_plat_phone -> dim_plat_phone (ea)

The following SPs are to load data into dim_plat_email

12.15 sp_wrk_plat_email: stg_from_ai_current -> wrk_plat_email  (wrk_ea)
12.16 sp_dim_plat_email: 

The following SPs are to decide the market flag and suppress flag of plat tables

12.24 sp_marketability_sync:    fact_marketability -> plat  tables (ea)
13.01 sp_wrk_suppression_match: keyword list suppression ->   (wrk_ea)
13.02 sp_dim_suppression_match: (ea)
13.03 sp_miller_merci_suppression_emea_apj (ea)
13.04 sp_apply_suppressions_to_plat (ea)


&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
检查自己建的表在DB里面的占有内存
select cast(objname as varchar(1024)) as objname
	, cast(database as varchar(1024)) as database
	, cast(owner as varchar(1024)) as owner
	, cast(x.createdate as datetime) as create_dt
	, cast((sum(used_bytes)/1073741824.00) as decimal(8,2)) as size_in_gb
from _v_obj_relation_xdb  x
join _v_sys_object_dslice_info 
on (objid = tblid) 
group by 1,2,3,4
order by 1,3 desc
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

跑SP用到的tidal脚本：
/scripts/exec_dell_smb_proc.sh
跑Wrkflow用的：
/data/etlbin/<DELL SMB Inf Wrapper.757>



Meta_ctl_process (log table to record files get loaded into raw table ) target_table_name
Meta_process_parameter(table to record workflow information) param_indirect_file
Meta_ctl_file(table to record the source file name convention of each workflow) file_received
Meta_table(table to record feed information)
Meta_column(table to store all of the column information for each feed)

update meta_ctl_job_list
call sp_updt_last_row_id()

update meta_ctl_job_proc
call sp_log_batch_job


********************************************************************************
提取table 到 flat file
export NZ_USER=bmu
export NZ_PASSWORD=
export NZ_DATABASE=smb_sandbox
export nz_sql="nzsql -Aq -d ${NZ_DATABASE} -v ON_ERROR_STOP=1"
${nz_sql} -c "select * from Top_Account_Q3_email_apend_OUTPUT order by email_address desc;"|sed '$d' > filename.csv
***********************************************************************************

Host: sftp://fm.merkleinc.com
Username: DELLSMBEMEA1385
Password: YhP`F8HjdL=_fEwk 
文件传输的FTP


看表是否被SP用到
select * from _v_procedure
where lower(proceduresource) like
'%stg_eps_email_send_act_emeaapj%'

select * from _v_view
where lower(definition) like 
'%stg_eps_email_send_act_emeaapj%'


putty hqetlutil01 看文件

cd $prod_src/arc/lan 
find RE_EMEA*

http://blog.csdn.net/TechChan/article/details/46923927  (regexp_like 正则)

************************************************************************
--Tidal variables--
NZ03 databases
<Dell SMB Target Database.1049> – smb_prod_etl
<Dell SMB Stage Database.1058> – smb_prod_wrk
<DELL SMB NA Stage Database.1691> – smb_stage
hard code smb_prod_a
 
NZ04 databases
hard code smb_prod_a database
 
NZ06 databases – EMEA/AJ
<DELL SMB EA Work Database.1388> – smb_qa_wrk_eb
<DELL SMB EA Target Database.1381> – smb_qa_eb
<DELL SMB EA Stage Database.1382> – smb_stage
<Dell SMB EC Target Database.1666> – smb_qa_ec
 
NZ06 – Latam DBS
<Dell SMB LatAm Work DB.2039> – latam_qa_wrk
<Dell SMB LatAm Stage DB.2041> – latam_stage
<Dell SMB LatAm Target DB.2040> – latam_qa_etl
<Dell SMB LatAm CampaignTarget DB.2042> – latam_prod_a
 
NZ06 – PMC Global
<DELL PMC GMDB GLOBAL Work Database.2267> – smb_pmc_qa_wrk
**********************************************************************


















