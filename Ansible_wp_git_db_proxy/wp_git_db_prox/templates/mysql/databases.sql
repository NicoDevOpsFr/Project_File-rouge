CREATE DATABASE IF NOT EXISTS `"{{ name_database_wordpress }}"`;
CREATE DATABASE IF NOT EXISTS `"{{ name_database_git }}"`;

CREATE USER '"{{ user_database_wordpress }}"'@'localhost' IDENTIFIED BY '"{{ password_database_wordpress }}"';
GRANT ALL PRIVILEGES ON "{{ name_database_wordpress }}".* TO '"{{ user_database_wordpress }}"'@'"{{ ip_address_wordpress }}"';
FLUSH PRIVILEGES;

CREATE USER '"{{ user_database_git }}"'@'localhost' IDENTIFIED BY '"{{ password_database_git }}"';
GRANT ALL PRIVILEGES ON "{{ name_database_git }}".* TO '"{{ user_database_git }}"'@'"{{ ip_address_gitea }}"';
FLUSH PRIVILEGES;