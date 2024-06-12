
------------------------------------------------------------------------------------------------
-- DDL
------------------------------------------------------------------------------------------------
/* 
A database is desired with information about facilities/buildings.
- Information about floors: name, category, description, GUID (Global Unique Identifier), height.
- Regarding spaces: name, category, description, usable height, area, GUID.
- Components: name, description, GUID, serial number, installation date.
- Component types: name, description, model, GUID, material, color, warranty years

Additionally, the following constraints are indicated:
- GUIDs must be unique.
- It is not possible to register a component without a type.
- It is not possible to register a space without a floor.
- It is not possible to register a floor without a facility.
- Two components cannot have the same name, the same applies to other entities.
- The default installation date for a component is the current date.
- Names cannot be empty in any of the entities.
- Warranty years cannot be zero or negative.
- Referential integrity must be maintained.
*/

create table facilities(
    id          number,
    guid        varchar2(4000),
    name        varchar2(4000) not null,
    description varchar2(4000),
    category    varchar2(4000),
    address     varchar2(4000),
    constraint pk_facilities_guid primary key(id),
    constraint uq_facilities_name unique(name),
    constraint uq_facilities_guid unique(guid)
);

create table floors(
    id              number,
    guid            varchar2(4000),
    name            varchar2(4000) not null,
    category        varchar2(4000),
    description     varchar2(4000),
    height          number,
    facilityId      number not null,
    constraint pk_floors_guid primary key(id),
    constraint uq_floors_name unique(name),
    constraint uq_floors_guid unique(guid)
);

create table spaces(
    id              number,
    guid            varchar2(4000),
    name            varchar2(4000) not null,
    category        varchar2(4000),
    description     varchar2(4000),
    usableHeight    number,
    area            number,
    floorId         number not null,
    constraint pk_spaces_guid primary key(id),
    constraint uq_spaces_name unique(name),
    constraint uq_spaces_guid unique(guid)
);

create table components(
    id              number,
    guid            varchar2(4000),
    name            varchar2(4000) not null,
    description     varchar2(4000),
    serialNumber    varchar2(4000),
    installatedOn   date default sysdate,
    spaceId         number,
    typeId          number not null,
    constraint pk_components_guid primary key(id),
    constraint uq_components_name unique(name),
    constraint uq_components_guid unique(guid)
);

create table types(
    id              number,
    guid            varchar2(4000),
    name            varchar2(4000) not null,
    description     varchar2(4000),
    modelNumber     varchar2(4000),
    color           varchar2(4000),
    warrantyYears   number,
    constraint pk_types_guid primary key(id),
    constraint uq_types_name unique(name),
    constraint uq_types_guid unique(guid)
);

alter table floors ADD
    constraint fk_floors_facility foreign key (facilityId)
        references facilities(id);

alter table spaces add
    constraint fk_spaces_floor foreign key (floorId)
        references floors (id);

alter table components ADD(
    constraint fk_components_space foreign key (spaceId)
        references spaces(id),
    constraint fk_components_type foreign key (typeId)
        references types(id)
);

alter table types add(
    constraint ck_types_warrantyYears check(warrantyYears > 0)
);
