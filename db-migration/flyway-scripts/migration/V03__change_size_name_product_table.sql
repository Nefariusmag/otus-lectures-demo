alter table products alter column name type varchar(50) using name::varchar(50);
alter table products alter column picture_url type varchar(255) using picture_url::varchar(255);