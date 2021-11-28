-- Then create a new database for Roundcube using the following command. 
-- This tutorial name it roundcube, you can use whatever name you like for the database.
CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Next, create a new database user on localhost using the following command. 
-- Again, this tutorial name it roundcubeuser, you can use whatever name you like. 
-- Replace password with your preferred password.
CREATE USER roundcubeuser@localhost IDENTIFIED BY 'example_password';
-- Then grant all permission of the new database to the new user so later on Roundcube webmail can write to the database.
GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;
-- Flush the privileges table for the changes to take effect.
flush privileges;