
/*
Requests regarding components need to be managed. And for that, the following needs to be stored:
Information about a request: subject, type of request (incident, service request), description, 
and the status (created, assigned, completed, closed). Also, the components on which it is generated.
Requests can generate work orders, and the following information should be captured: type of problem, 
company to which it is assigned, a level of criticality (low, medium, high, urgent), 
a status (created, in progress, completed, closed), and the working time.

Additionally, the cost of materials used in each work order needs to be tracked. Both the number of units 
and the value of the material used.

The following restrictions are described:
- Each table has an id.
- Every work order belongs to a request.
- The type of request must be Incident or Service Request if a work order is generated.
- The quantity of units and the cost cannot be less than zero.

Note: As with any project, the client provides ideas of what they want. 
Some are useful, and others are not. It's necessary to deduce and clarify what the client wants.

1. Generate the following tables

COMPONENTS
id
guid
name
description
serialNumber
installatedOn
spaceId
typeId

TICKETS
id
subject
ticketTypeId
description
statusId

TICKET_TYPE
id
name

TICKET_STATUS
id
name

TICKET_COMPONENT
ticketId
componentId

ORDERS
id
problemTypeId
companyId
criticalityId
statusId
ticketId
workingHours

COMPANY
id
name

PROBLEM_TYPE
id
name

ORDER_STATUS
id
name

CRITICALLY
id
name

MATERIALS
id
name

COSTS
id
cost
quantity
orderId
materialId

Define the following restrictions:
- Every work order belongs to a request.
- The quantity of units and the cost cannot be less than zero.
- Every request has a status.
- Every work order has a status.
- Every work order has a problem type.
- Every work order has a level of criticality.
- The names of the states are unique.
- The types of problems are unique.
- Referential integrity must be maintained.
*/

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

create table TICKETS(
    id              number,
    subject         varchar2(4000),
    description     varchar2(4000),
    ticketTypeId    number,
    statusId        number not null,
    constraint pk_tickets_id primary key(id)
);

create table TICKET_TYPE(
    id      number,
    name    varchar2(4000),
    constraint pk_ticket_type_id primary key(id),
    constraint uq_ticket_type_name unique(name)
);

create table TICKET_STATUS(
    id      number,
    name    varchar2(4000),
    constraint pk_ticket_status_id primary key(id),
    constraint uq_ticket_status_name unique(name)
);

create table TICKET_COMPONENT(
    ticketId    number,
    componentId number,
    constraint pk_ticket_component primary key(ticketId, componentId)
);

create table ORDERS(
    id              number,
    problemTypeId   number not null,
    companyId       number,
    criticalityId    number not null,
    statusId        number not null,
    workingHours    number,
    ticketId        number,
    constraint pk_orders_id primary key(id)
);

create table COMPANY(
    id      number,
    name    varchar2(4000),
    constraint pk_company_id primary key(id),
    constraint uq_company_name unique(name)
);

create table PROBLEM_TYPE(
    id      number,
    name    varchar2(4000),
    constraint pk_problem_type_id primary key(id),
    constraint uq_problem_type_name unique(name)
);

create table ORDER_STATUS(
    id      number,
    name    varchar2(4000),
    constraint pk_order_status_id primary key(id),
    constraint uq_order_status_name unique(name)
);

create table CRITICALITIES(
    id      number,
    name    varchar2(4000),
    constraint pk_critically_id primary key(id),
    constraint uq_critically_name unique(name)
);

create table MATERIALS(
    id      number,
    name    varchar2(4000),
    constraint pk_materials_id primary key(id),
    constraint uq_materials_name unique(name)
);

create table COSTS(
    id          number,
    cost        number,
    quantity    number,
    orderId     number,
    materialId  number,
    constraint pk_costs_id primary key(id),
    constraint ck_costs_quantity check(quantity > 0),
    constraint ck_costs_cost check(cost > 0)
);

alter table tickets add(
    constraint fk_tickets_status foreign key(statusId)
        references ticket_status(id),
    constraint fk_tickets_type foreign key(ticketTypeId)
        references ticket_type(id)
);

alter table ticket_component add (
    constraint fk_ticket_component_ticket foreign key(ticketId)
        references tickets(id),
    constraint fk_ticket_component_comp foreign key(componentId)
        references components(id)
);

alter table orders add(
    constraint fk_orders_problem foreign key(problemTypeId)
        references problem_type(id),
    constraint fk_orders_companyId foreign key(companyId)
        references company(id),
    constraint fk_orders_criticalityId foreign key(criticalityId)
        references criticalities(id),
    constraint fk_orders_statusId foreign key(statusId)
        references order_status(id),
    constraint fk_orders_ticketId foreign key(ticketId)
        references tickets(id)
);
