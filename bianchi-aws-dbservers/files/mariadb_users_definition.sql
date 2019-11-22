-- mariadb user
CREATE USER mariadb@'10.0.%' IDENTIFIED BY '123';
GRANT RELOAD, REPLICATION SLAVE ON *.* TO mariadb@'10.0.%';
-- maxusr user
CREATE USER 'maxusr'@'10.0.%' IDENTIFIED BY '123';
GRANT SELECT ON mysql.user TO 'maxusr'@'10.0.%';
GRANT SELECT ON mysql.db TO 'maxusr'@'10.0.%';
GRANT SELECT ON mysql.tables_priv TO 'maxusr'@'10.0.%';
GRANT SHOW DATABASES ON *.* TO 'maxusr'@'10.0.%';
GRANT SELECT ON mysql.roles_mapping TO maxusr@'10.0.%';
-- maxmon
CREATE USER 'maxmon'@'10.0.%' IDENTIFIED BY '321';
GRANT SELECT ON mysql.user  TO 'maxmon'@'10.0.%'; 
GRANT RELOAD, SUPER, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'maxmon'@'10.0.%';
GRANT CREATE, SELECT, UPDATE, INSERT, DELETE ON maxscale_schema.* TO 'maxmon'@'10.0.%';
