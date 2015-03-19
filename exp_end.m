allresults = APT_run(apt_taskid, 'NoLoad', 0);

conn = db_connect();
db_query(conn, sprintf('UPDATE experiments SET status = ''Finished'', apt_taskid = %d WHERE id = %d;', apt_taskid, exp_id));
conn.close();
