#!/usr/bin/python

#Copy this script to check_mk_agent/local/ folder.
#This Script Checks dot-net Components of optima

#print('<<<local_optima-net>>>')
#exit (0)

import http.client as hc
import xml.etree.ElementTree as etree

net_server = '10.0.23.4'
net_port = 1800
services = { 'tre', 'vtFCD', 'vms'}


def check_windows_net_server_services(server, service_name ):
    server.request("GET", '/'+service_name)
    try:
        response = server.getresponse()
        if( response.status == 200):
            print('0 optima-net-'+service_name+'-connection count=' +str(response.status)+' HTTP-Response: '+str(response.status)+' '+str(response.reason)+', reachable' )
            answer = response.read()
            if(answer):
                #Parse the XML-File now!
                tree_root = etree.fromstring(answer)
                #tree = etree.parse(answer)
                #print(tree_root.attrib)
                #print(tree_root.tag)
                if (tree_root[0].text == '1'):
                    print('0 optima-net-'+service_name+'-xml count='+tree_root[0].text+' Status: '+tree_root[0].text+' idle')
                else:
                    print('1 optima-net-'+service_name+'-xml count='+tree_root[0].text+' Status: '+tree_root[0].text+' non-idle')
            else:
                print('3 optima-net-'+service_name+'-xml count=10 Status: no answer, empty answer')
                 
        else:
            print('2 optima-net-'+service_name+'-connection count='+str(response.status)+' HTTP-Response: '+str(response.status)+' '+str(response.reason)+', not reachable')
            print('2 optima-net-'+service_name+'-xml count=2 Error: Not in Service')
    
    except hc.HTTPException as e:
        print('2 optima-net-'+service_name+'-connection count=1000 Error: Exception '+e+' raised')
        print('2 optima-net-'+service_name+'-xml count=2 Error: Not in Service')

http_net_server = hc.HTTPConnection(net_server, net_port, timeout=10)
check_windows_net_server_services(http_net_server, 'tre')
check_windows_net_server_services(http_net_server, 'vms')
check_windows_net_server_services(http_net_server, 'mtf')
check_windows_net_server_services(http_net_server, 'vtFCD')
check_windows_net_server_services(http_net_server, 'vtPortal')


