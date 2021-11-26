
### One table

# This will export the tableName to the file tableName.sql.
mysqldump -p --user=username dbname tableName > tableName.sql
# Importing the Table
mysql -u username -p -D dbname < tableName.sql


### Whole DB

mysqldump -u YourUser -p YourDatabaseName > wantedsqlfile.sql


# For Export:
mysqldump -u [user] -p [db_name] | gzip > [filename_to_compress.sql.gz] 
# For Import:
gunzip < [compressed_filename.sql.gz]  | mysql -u [user] -p[password] [databasename] 
# Note: There is no space between the keyword '-p' and your password.