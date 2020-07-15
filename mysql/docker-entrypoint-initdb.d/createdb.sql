#
#     docker-compose exec mysql bash
#     mysql -u root -p < /docker-entrypoint-initdb.d/createdb.sql
#

CREATE DATABASE IF NOT EXISTS `sdj_db` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `sdj_db`.* TO 'sdj'@'%' ;

FLUSH PRIVILEGES ;
