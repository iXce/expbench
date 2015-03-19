function conn = db_connect()
    db_creds;
    props = java.util.Properties;
    props.setProperty('user', db_user);
    props.setProperty('password', db_password);
    % Create the database connection (port 5432 is the default postgres chooses
    % on installation)
    driver = org.postgresql.Driver;
    url = sprintf('jdbc:postgresql://%s:%d/%s', db_host, db_port, db_database);
    conn = driver.connect(url, props);

