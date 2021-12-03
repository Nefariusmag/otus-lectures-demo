import logging
import os
import pyodbc
import pathlib

import azure.functions as func

sql_server_host = os.getenv('SQL_SERVER_HOST', '')
sql_db_name = os.getenv('SQL_SERVER_DATABASE_NAME', '')
sql_username = os.getenv('SQL_SERVER_USERNAME', '')
sql_password = os.getenv('SQL_SERVER_PASSWORD', '')

sql_script = """DROP TABLE IF EXISTS health
CREATE TABLE health(
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[body_report] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]"""


def main(req: func.HttpRequest) -> func.HttpResponse:

    test = req.params.get('health')
    if test:

        try:
            conn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};'
                'SERVER=' + sql_server_host + ';'
                'DATABASE=' + sql_db_name + ';'
                'UID=' + sql_username + ';'
                'PWD=' + sql_password, autocommit=True)
        except pyodbc.InterfaceError:
            conn = 0

        if conn != 0:
            cursor = conn.cursor()
            try:
                cursor.execute(sql_script)
                cursor.execute('SELECT id FROM health')
                cursor.execute('DROP TABLE health')
                status_connection_to_db = 1
            except pyodbc.ProgrammingError:
                status_connection_to_db = 0

        return func.HttpResponse(str(status_connection_to_db))

    current_dir = pathlib.Path(__file__).parent.absolute()
    file_changelog = open(f'{current_dir}/../CHANGELOG.md', 'r')
    count = 0
    for line in file_changelog:
        if '## [' in line:
            if count == 1:
                text_changelog = line
                break
            count += 1

    version = text_changelog.split(' - ')[0][3:]

    return func.HttpResponse(version, status_code=200)
