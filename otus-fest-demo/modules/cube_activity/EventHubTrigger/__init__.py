import os
import logging
import json
import pyodbc
import azure.functions as func
from typing import List

sql_server_host = os.getenv('SQL_SERVER_HOST', '')
sql_db_name = os.getenv('SQL_SERVER_DATABASE_NAME', '')
sql_username = os.getenv('SQL_SERVER_USERNAME', '')
sql_password = os.getenv('SQL_SERVER_PASSWORD', '')

list_users_not_checked = os.getenv('LIST_SERVICE_USER', ['', 'SYSTEM'])

initial_db = """if not exists (select * from events)
CREATE TABLE events(
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](70) NULL,
	[type_application] [nvarchar](150) NULL,
	[datetime] [nvarchar](30) NULL,
	[database_name] [nvarchar](15) NULL,
	[query] [nvarchar](max) NULL,
	[duration] [int] NULL,
	[host] [nvarchar](70) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
"""


class Event(object):

    def __init__(self, user_name, type_application, datetime, query, duration, host, database_name):
        self.user_name = user_name
        self.type_application = type_application
        self.datetime = datetime
        self.query = query
        self.duration = duration
        self.host = host
        self.database_name = database_name

    def insert_event(self):

        try:
            logging.info(f'Start connect to SQL server {sql_server_host} to database "{sql_db_name}"')
            conn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + sql_server_host + ';DATABASE=' + sql_db_name + ';UID=' + sql_username + ';PWD=' + sql_password, autocommit=True)
            logging.info(f'Connect to SQL server {sql_server_host} to database "{sql_db_name}"" - Success')
        except pyodbc.InterfaceError:
            logging.info(f'Connect to the database "{sql_server_host}" - Failed')
            exit(403)

        cursor = conn.cursor()
        cursor.execute("INSERT INTO events (user_name, type_application, datetime, database_name, query, duration, host) VALUES (?, ?, ?, ?, ?, ?, ?)",
                       self.user_name, self.type_application, self.datetime, self.database_name, self.query, self.duration, self.host)
        logging.info(f'Insert to the database "{sql_server_host}" new event of user "{self.user_name}"')


def main(events: List[func.EventHubEvent]):
    for event in events:
        body = event.get_body().decode('utf-8')

        # logging.info(f'Body = {event}')
        j = json.loads(body)
        test = j['records']
        for i in range(test.__len__()):

            new_event = Event(test[i]['properties']['EffectiveUsername'], test[i]['properties']['ApplicationName'],
                              test[i]['properties']['StartTime'], test[i]['properties']['TextData'],
                              test[i]['properties']['Duration'], test[i]['properties']['ClientHostName'],
                              test[i]['properties']['DatabaseName'])

            if new_event.user_name not in list_users_not_checked and new_event.query != '':
                if 'select' in new_event.query.lower() and new_event.duration is None:
                    break

                new_event.insert_event()
