CREATE DATABASE IF NOT EXISTS `wordpress`;
CREATE DATABASE IF NOT EXISTS `git`;

CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'217.182.205.43';
FLUSH PRIVILEGES;

CREATE USER 'git'@'localhost' IDENTIFIED BY 'git';
GRANT ALL PRIVILEGES ON git.* TO 'git'@'141.94.6.208';
FLUSH PRIVILEGES;