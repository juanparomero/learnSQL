
-- Execute this script with a user that has sufficient privileges
-- to perform the following operations. Eg. SYSTEM

-- The schema is dropped in order to rebuild it
DROP USER student1 CASCADE;

-- The user is created
CREATE USER student1 -- name
IDENTIFIED BY STUDENT1 -- password
DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP; -- optionally specify the tablespaces to use. These are default

-- Privileges are granted
GRANT CONNECT, RESOURCE TO student1; -- privileges to connect and RESOURCE is a role with a set of privileges to work with
GRANT DEBUG CONNECT SESSION, DEBUG ANY PROCEDURE TO student1; -- necessary for debugging from sqldeveloper

-- Connection is made with the new user
CONNECT STUDENT1/STUDENT1;

-- The scripts are executed to create objects in the HR schema (example schema provided by Oracle)
-- The scripts must be executed in the following order. Taking into account, that in this example, the three files
-- are in a folder called Schema HR on the desktop of a Windows operating system. If necessary
-- this should be modified indicating the path to the files.
-- If you execute these files being connected as student1 the objects will be created in student1.
START "%USERPROFILE%\DESKTOP\Schema HR\HR_CRE.SQL"
START "%USERPROFILE%\DESKTOP\Schema HR\HR_POPUL.SQL"
START "%USERPROFILE%\DESKTOP\Schema HR\HR_IDX.SQL"
