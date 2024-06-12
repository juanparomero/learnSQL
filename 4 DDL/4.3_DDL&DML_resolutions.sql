
/*
NOTE: Some exercises may cause errors that need to be tested (to see the error) and corrected.
*/

/*1
Register the building headquarters
*/
insert into facilities(id,name)
values(1,'Headquarters');
/*2
Register Floor 1, Floor 2, and Floor 3
in the headquarters building with a height of 3.69m
*/
insert into floors(id, name, facilityid, height)
    select 1, 'Floor 1', 1, 3.69 from dual
    UNION
    select 2, 'Floor 2', 1, 3.69 from dual
    UNION
    select 3, 'Floor 3', 1, 3.69 from dual ;

/*3
Register in Floor 1 the spaces: Reception, Room1, Room2
*/
insert into spaces(id, name, floorid)
    select 1, 'Reception', 1 from dual
    UNION
    select 2, 'Room 1', 1 from dual
    UNION
    select 3, 'Room 2', 1 from dual ;
/*4
Register the types: 
Square wooden table 1x1x1
Round wooden table 2x1
Reclining chair TPM
*/
insert into types(id, name)
    select 1, 'Square wooden table 1x1x1' from dual
    UNION
    select 2, 'Round wooden table 2x1' from dual
    UNION
    select 3, 'Reclining chair TPM' from dual ;

/*5
Register the components: 
[{
"name": "Furniture_Square wooden table 1x1x1",
"serialNumber": "ASD-3322",
"assetId": "MOB-MES-1234",
"space": "Room 1",
"type": "Square wooden table 1x1x1"
},
{
"name": "Furniture_Square wooden table 1x1x1",
"serialNumber": "ASD-3355",
"assetId": "MOB-MES-4321",
"space": "Room 2",
"type": "Square wooden table 1x1x1"
}
]
*/
/*
Note:
- A field is needed to store the given code that is independent of ours.
- The restriction that component names cannot be repeated is removed.
*/
alter table components add
    assetId varchar2(4000);

alter table components
drop constraint uq_components_name;

insert into components(id, name, serialNumber, assetId, spaceId, typeId)
    select 1, 'Furniture_Square wooden table 1x1x1','ASD-3322','MOB-MES-1234', 2, 1 from dual
    UNION
    select 2, 'Furniture_Square wooden table 1x1x1','ASD-3355','MOB-MES-4321', 3, 1 from dual;

/*6
Update the installation date of component number 2
to June 31, 2020
*/
update components
set installatedOn = to_Date('2020-06-31','yyyy-mm-dd')
where id = 2;

/*
June 31 does not exist. We set it to June 1.
*/
update components
set installatedOn = to_Date('2020-06-1','yyyy-mm-dd')
where id = 2;

/*7
Remove restriction that forces components
to have a space
*/
alter table components
modify spaceId number null;

/*8
Remove restriction that forces components
to have a type
*/
alter table components
modify typeid number null;
