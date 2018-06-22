#Persistent
Menu, tray, add
Menu, tray, add, Toggle Proxy, toggleproxy
 
Settimer, checkproxy, 1000
return
 
checkproxy:
  currentaddr = %A_IPAddress2%
  if (oldaddr != currentaddr) {
  global oldaddr = currentaddr
  if ((currentaddr = "172.16.101.76") or (currentaddr = "172.16.100.90"))
    setproxy("ON")
  else
    setproxy("OFF")
  }
return
 
 
toggleproxy:
 setproxy()
return
 
 
setproxy(state = ""){ 
  if (state = "")
    state = TOGGLE 
 
  if (state ="ON") {
    regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyServer,proxy.cnmca.meteoam.it:8080
    regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1
     ;Set proxy via Registry
     ;setproxy("proxy.cnmca.meteoam.it:8080","ON")
     ;Set Home Page, Change http://google.com to whatever you want
     ;RegWrite,REG_SZ,HKCU,Software\microsoft\Internet Explorer\Main,Start Page,http://google.com
     ;Set ProxyOverride to your exception list separated by ';'
     ;regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyOverride,exception1;exception2;exception3 
    regwrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,ProxyOverride,172.16.*.*; 172.20.48.*; 192.4.21.*; 172.19.*.*; 172.20.43.*; 10.17.44.*; *.dmz.meteoam.it; *.cnmca.meteoam.it;<local>
    TrayTip Connection Status, Proxy CNMCA Enabled myip:%A_IPAddress2%, 3

  } else if (state="OFF") {
    regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
    TrayTip Connection Status, Proxy CNMCA Disabled myip:%A_IPAddress2%, 3

  } else if (state = "TOGGLE") {
      if (regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 1) {
        regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,0
	TrayTip Connection Status, Proxy Disabled - %A_IPAddress2%, 3

      } else if (regread("HKCU","Software\Microsoft\Windows\CurrentVersion\Internet Settings","Proxyenable") = 0) {
        regwrite,REG_DWORD,HKCU,Software\Microsoft\Windows\CurrentVersion\Internet Settings,Proxyenable,1 
	TrayTip Connection Status, Proxy Enabled - %A_IPAddress2%, 3
      }
    }
  dllcall("wininet\InternetSetOptionW","int","0","int","39","int","0","int","0")
  dllcall("wininet\InternetSetOptionW","int","0","int","37","int","0","int","0")
  Return
}
 
RegRead(RootKey, SubKey, ValueName = "") {
	RegRead, v, %RootKey%, %SubKey%, %ValueName%
	Return, v
}