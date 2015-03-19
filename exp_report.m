function exp_report(exp_id, reportdata, reporttext, explink)
    reporttext_san = strrep(reporttext, '''', '''''');
    explink_san = strrep(explink, '''', '''''');
    report_bytes = getByteStreamFromArray(reportdata);
    report_string = reshape(dec2hex(report_bytes)', 1, numel(report_bytes)*2);
    conn = db_connect();
    db_query(conn, sprintf('UPDATE experiments SET report = ''%s'', reportdata = decode(''%s'', ''hex''), explink = ''%s'' WHERE id = %d;', reporttext_san, report_string, explink_san, exp_id));
    conn.close();
end
