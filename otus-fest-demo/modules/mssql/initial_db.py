import logging
import os
import pyodbc
import sys
import re
import glob

level_logging = logging.INFO
logging.basicConfig(stream=sys.stdout, format='%(asctime)s %(message)s', datefmt='%Y-%m-%d %H:%M:%S',
                    level=level_logging)

sql_server_host = os.getenv('SQL_SERVER_HOST', '')
sql_db_name = os.getenv('SQL_SERVER_DATABASE_NAME', '')
sql_scripts = os.getenv('SQL_SCRIPTS', '')
sql_username = os.getenv('SQL_SERVER_USERNAME', '')
sql_password = os.getenv('SQL_SERVER_PASSWORD', '')


def main():
    def auth_data_base(sql_db_name):
        try:
            logging.info(f'Start to connect to SQL server {sql_server_host} to db {sql_db_name}')
            conn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + sql_server_host + ',1433;DATABASE=' + sql_db_name + ';UID=' + sql_username + ';PWD=' + sql_password,
                autocommit=True)
            logging.info(f'Connect to SQL server {sql_server_host} to db ({sql_db_name}) - Success')
        except pyodbc.InterfaceError:
            logging.info(f'Connect to the data base ({sql_server_host}) - Fail')
            conn = 0

        return conn

    def get_sql_content_from_file(sql_fle):
        with open(sql_fle, 'r', encoding='utf-8') as f:
            content = f.read()
            batch = re.split('\ngo|\nGO', content)

        logging.debug(batch)

        return batch

    def execute_sql(sql_scripts):

        if os.path.isdir(sql_scripts):
            list_sql = glob.glob(sql_scripts + '/*.sql')
        else:
            list_sql = re.split(',', sql_scripts)

        list_sql.sort()
        logging.info(list_sql)

        for name in list_sql:
            logging.info(name)

            for one_execute in get_sql_content_from_file(name):
                if one_execute == '':
                    continue
                logging.debug(one_execute)
                try:
                    cursor.execute(one_execute)
                    pass
                except Exception as e:
                    logging.info(one_execute)
                    logging.error(e)
                    exit(1)

    conn = auth_data_base(sql_db_name)

    if conn != 0:
        cursor = conn.cursor()

        logging.info('Start exec initial scripts')

        execute_sql(sql_scripts)
        conn.close()

        logging.info('Finished exec initial scripts')


if __name__ == '__main__':
    main()
