#!/usr/bin/python3.4

#Copy this script to check_mk_agent/local/ folder.

#print('<<<local_optima-qos>>>')

import psycopg2
import datetime
from datetime import timedelta,datetime

postgres_server = '10.0.23.6'
postgres_port = 5432
postgres_user = 'postgres'
postgres_password = 'postgres'
postgres_db = 'optima'

#-15minutes
#-15min, 0min, 15min, 30min, 45min, 60min, in seconds
simulation_timepoints = -900,0,900,1800,2700,3600
simulation_steps = len(simulation_timepoints)

postgres_dateformat = '%y-%m-%d  %H:%M:%S'

#First value to print is
#0 for OK, 1 for WARNING, 2 for CRITICAL and 3 for UNKNOWN

#general Output-line is
#0 test-name variablename=value my free text comes here

#check_total_traveltime ##################################################################################################################
def check_total_traveltime(dbcursor, warn_level, critical_level):
    if dbcursor==None :
        print("3 optima-qos-traveltime minutes=0 CRITICAL, no connection")
        return
    
    result_list = list()
    
    for fore_val in simulation_timepoints:
        #print("%d" % fore_val)
        try:
            #SELECT CAST((sum(time*iflw)/3600)/4 AS DECIMAL(30,0)) FROM rlin_tsys_tre_rltm WHERE link>0 AND time<>'Infinity' AND simu=4704
            #dbcursor.execute("SELECT COUNT(1),sum(time*iflw) FROM rlin_tsys_tre_rltm WHERE fore="+str(fore_val) )
            dbcursor.execute("SELECT sum(time*iflw) FROM rlin_tsys_tre_rltm WHERE fore="+str(fore_val) )
        except psycopg2.ProgrammingError as e:
            print('2 optima-qos-traveltime minutes=0 CRITICAL malformed SQL-statement, simu may not exist' )
            conn.rollback()
            return  

        #Get a list such as [(20161128153530,), (20161128153028,)]

        #zipped_list = zip(time_list,iflw_list,fore_list)
        result_list.append(dbcursor.fetchone() )

    #modified
    print('0 optima-qos-traveltime minutes='+str(result_list)+' OK')

    if( len(result_list) == 0 ):
        print('2 optima-qos-traveltime minutes=0 table is empty, CRITICAL')
    
    return

#start ####################################################################
conn = psycopg2.extensions.connection
cursor = psycopg2.extensions.cursor
try:
    # use our connection values to establish a connection
    conn = psycopg2.connect(host=postgres_server, port=postgres_port, database=postgres_db, user=postgres_user,password=postgres_password)
    
    # create a psycopg2 cursor that can execute queries
    cursor = conn.cursor()
    
except Exception as e:
    cursor = None

#check_total_traveltime(cursor, -900, 10, 5)
#check_total_traveltime(cursor, 0, 10, 5)
#check_total_traveltime(cursor, 900, 10, 5)
#check_total_traveltime(cursor, 1800, 10, 5)
#check_total_traveltime(cursor, 2700, 10, 5)
#check_total_traveltime(cursor, 3600, 10, 5)
check_total_traveltime(cursor, 10, 5)

#print(conn)

if (conn.status == psycopg2.extensions.STATUS_IN_TRANSACTION) :
    conn.close()
#else:

exit(1)

