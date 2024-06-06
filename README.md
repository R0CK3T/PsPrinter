error 
“execution of scripts is disabled on this system.”

Bypass the security policy by running this command 
run in Powershell admin 
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
