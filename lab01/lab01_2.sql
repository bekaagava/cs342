/* The schema: 
Since DUAL can be accessed by every user, the schema for me is 'HR', since the schema usually 
has the same name as the database user. The original owner and then schema for DUAL is 'SYS', which owns the 
data dictionary.

The data values:
DUAL has a single VARCHAR2(1) column called DUMMY that has a value of 'X'.

*/

select sys_context( 'userenv', 'current_schema' ) 
from dual;

desc dual;

select * from dual;