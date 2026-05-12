/***************************************************************************************************
Project:        Lincoln Center Tessitura Connect: Intro to SQL Training Database

Purpose:
Creates a simplified, Tessitura-inspired training database for the
LCTC Intro to SQL Lunch & Learn session on 5/19/2026.

This script is designed for SQLiteOnline.com and includes:
    - Sample constituent data
    - Contributions and campaigns
    - Ticketing and performance records
    - Realistic relational structures for SQL practice
    - Beginner-friendly datasets aligned to workshop exercises

Environment:
    https://sqliteonline.com/

Author:
    Brian Ralston

Primary Presenter:
    Sheela Sur-Luk

Created:
    2026-05-12


Notes:
    - Table and field names are inspired by Tessitura structures
    - Schema intentionally simplified for educational purposes
    - Data is fictional and generated for training only
    - SQLite and T-SQL have differences such as SELECT TOP 50 * vs LIMIT 100 --> Please explain if demoing on SQL Server Environment. 

Recommended Usage:
    1. Open SQLiteOnline
    2. Paste entire script
    3. Execute all statements
    4. Validate setup with:
           SELECT * FROM T_CUSTOMER LIMIT 10;

Modification History:
----------------------------------------------------------------------------------------------------
Date         Author              Description
----------------------------------------------------------------------------------------------------
2026-05-12   Brian Ralston       Initial workshop training database creation

***************************************************************************************************/
DROP TABLE IF EXISTS T_SUB_LINEITEM;
DROP TABLE IF EXISTS T_ORDER;
DROP TABLE IF EXISTS T_CONTRIBUTION;
DROP TABLE IF EXISTS T_PERF;
DROP TABLE IF EXISTS T_INVENTORY;
DROP TABLE IF EXISTS T_CAMPAIGN;
DROP TABLE IF EXISTS T_FUND;
DROP TABLE IF EXISTS T_CUSTOMER;

CREATE TABLE T_CUSTOMER (
    customer_no INTEGER PRIMARY KEY,
    cust_type INTEGER,
    prefix TEXT,
    fname TEXT,
    mname TEXT,
    lname TEXT,
    suffix TEXT,
    name_status INTEGER,
    mail_ind INTEGER,
    phone_ind INTEGER,
    last_activity_dt TEXT,
    last_gift_dt TEXT,
    last_ticket_dt TEXT,
    emarket_ind INTEGER,
    primary_address_no INTEGER,
    email TEXT,
    inactive INTEGER,
    inactive_reason TEXT,
    sort_name TEXT,
    city TEXT,
    state TEXT
);

CREATE TABLE T_CONTRIBUTION (
    ref_no INTEGER PRIMARY KEY,
    customer_no INTEGER,
    cont_dt TEXT,
    recd_amt REAL,
    cont_amt REAL,
    cont_type TEXT,
    campaign_no INTEGER,
    appeal_no INTEGER,
    media_type INTEGER,
    source_no INTEGER,
    notes TEXT,
    cancel TEXT,
    fund_no INTEGER,
    n1n2_ind INTEGER,
    channel INTEGER
);

CREATE TABLE T_CAMPAIGN (
    campaign_no INTEGER PRIMARY KEY,
    default_fund INTEGER,
    description TEXT,
    camp_type TEXT,
    goal_amt REAL,
    start_dt TEXT,
    end_dt TEXT,
    status TEXT,
    category INTEGER,
    fyear INTEGER,
    inactive TEXT
);

CREATE TABLE T_FUND (
    fund_no INTEGER PRIMARY KEY,
    description TEXT,
    ticketing_ind TEXT,
    inactive TEXT,
    BU INTEGER
);

CREATE TABLE T_INVENTORY (
    inv_no INTEGER PRIMARY KEY,
    description TEXT,
    type TEXT,
    short_name TEXT
);

CREATE TABLE T_PERF (
    perf_no INTEGER PRIMARY KEY,
    prod_season_no INTEGER,
    bsmap_no INTEGER,
    zmap_no INTEGER,
    facility_no INTEGER,
    ben_fund_no INTEGER,
    perf_code TEXT,
    perf_type INTEGER,
    perf_dt TEXT,
    perf_status INTEGER,
    def_start_sale_dt TEXT,
    def_end_sale_dt TEXT,
    time_slot INTEGER,
    campaign_no INTEGER,
    season INTEGER
);

CREATE TABLE T_ORDER (
    order_no INTEGER PRIMARY KEY,
    appeal_no INTEGER,
    source_no INTEGER,
    customer_no INTEGER,
    cancel_ind TEXT,
    order_dt TEXT,
    batch_no INTEGER,
    tot_ticket_purch_amt REAL,
    tot_ticket_return_amt REAL,
    tot_fee_amt REAL,
    tot_contribution_amt REAL,
    tot_due_amt REAL,
    tot_paid_amt REAL,
    delivery INTEGER,
    channel INTEGER,
    fully_paid_ind INTEGER
);

CREATE TABLE T_SUB_LINEITEM (
    sli_no INTEGER PRIMARY KEY,
    li_seq_no INTEGER,
    unseatable_code TEXT,
    fee_amt REAL,
    due_amt REAL,
    paid_amt REAL,
    price_type INTEGER,
    seat_no INTEGER,
    ticket_no INTEGER,
    cancel_ind TEXT,
    sr_ind TEXT,
    sli_status INTEGER,
    perf_no INTEGER,
    pkg_no INTEGER,
    zone_no INTEGER,
    sli_status_code TEXT,
    batch_no INTEGER,
    mir_lock INTEGER,
    ret_parent_sli_no INTEGER,
    order_no INTEGER,
    recipient_no INTEGER,
    rule_id INTEGER,
    rule_ind TEXT,
    original_price_type INTEGER
);

INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1001, 1, NULL, 'Maya', NULL, 'Jones', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Jones/Maya', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1002, 1, NULL, 'Robert', NULL, 'Sur', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Sur/Robert', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1003, 1, NULL, 'Priya', NULL, 'Chen', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Chen/Priya', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1004, 1, NULL, 'Daniel', NULL, 'Patel', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Patel/Daniel', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1005, 1, NULL, 'Elena', NULL, 'Jones', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Jones/Elena', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1006, 1, NULL, 'Marcus', NULL, 'Rodriguez', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Rodriguez/Marcus', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1007, 1, NULL, 'Sofia', NULL, 'Nguyen', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Nguyen/Sofia', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1008, 1, NULL, 'James', NULL, 'Garcia', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Garcia/James', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1009, 1, NULL, 'Aisha', NULL, 'Williams', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Williams/Aisha', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1010, 1, NULL, 'Noah', NULL, 'Brown', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Brown/Noah', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1011, 1, NULL, 'Grace', NULL, 'Davis', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Davis/Grace', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1012, 1, NULL, 'Henry', NULL, 'Suri', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Suri/Henry', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1013, 1, NULL, 'Lena', NULL, 'Anderson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Anderson/Lena', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1014, 1, NULL, 'Owen', NULL, 'Thomas', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Thomas/Owen', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1015, 1, NULL, 'Nina', NULL, 'Moore', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Moore/Nina', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1016, 1, NULL, 'Carlos', NULL, 'Martin', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Martin/Carlos', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1017, 1, NULL, 'Amara', NULL, 'Lee', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Lee/Amara', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1018, 1, NULL, 'Evan', NULL, 'Perez', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 1, NULL, 'Perez/Evan', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1019, 1, NULL, 'Isabel', NULL, 'Thompson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Thompson/Isabel', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1020, 1, NULL, 'Thomas', NULL, 'White', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'White/Thomas', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1021, 1, NULL, 'Mei', NULL, 'Harris', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Harris/Mei', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1022, 1, NULL, 'David', NULL, 'Basurto', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Basurto/David', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1023, 1, NULL, 'Rachel', NULL, 'Lewis', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Lewis/Rachel', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1024, 1, NULL, 'Samir', NULL, 'Robinson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Robinson/Samir', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1025, 1, NULL, 'Julia', NULL, 'Jones', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Jones/Julia', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1026, 1, NULL, 'Andre', NULL, 'Young', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Young/Andre', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1027, 1, NULL, 'Clara', NULL, 'Allen', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Allen/Clara', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1028, 1, NULL, 'Miles', NULL, 'King', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'King/Miles', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1029, 1, NULL, 'Hannah', NULL, 'Wright', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Wright/Hannah', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1030, 1, NULL, 'Leo', NULL, 'Scott', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Scott/Leo', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1031, 1, NULL, 'Nadia', NULL, 'Torres', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Torres/Nadia', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1032, 1, NULL, 'Peter', NULL, 'Mansur', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Mansur/Peter', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1033, 1, NULL, 'Chloe', NULL, 'Green', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Green/Chloe', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1034, 1, NULL, 'Mateo', NULL, 'Adams', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Adams/Mateo', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1035, 1, NULL, 'Avery', NULL, 'Baker', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Baker/Avery', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1036, 1, NULL, 'Jasmine', NULL, 'Nelson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Nelson/Jasmine', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1037, 1, NULL, 'Elliot', NULL, 'Carter', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Carter/Elliot', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1038, 1, NULL, 'Rina', NULL, 'Mitchell', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Mitchell/Rina', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1039, 1, NULL, 'Victor', NULL, 'Turner', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Turner/Victor', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1040, 1, NULL, 'Talia', NULL, 'Phillips', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Phillips/Talia', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1041, 1, NULL, 'Gabe', NULL, 'Campbell', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Campbell/Gabe', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1042, 1, NULL, 'Miriam', NULL, 'Parker', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Parker/Miriam', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1043, 1, NULL, 'Jonah', NULL, 'Evans', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Evans/Jonah', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1044, 1, NULL, 'Leah', NULL, 'Edwards', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 1, NULL, 'Edwards/Leah', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1045, 1, NULL, 'Anika', NULL, 'Jones', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Jones/Anika', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1046, 1, NULL, 'Simon', NULL, 'Stewart', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Stewart/Simon', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1047, 1, NULL, 'Beatrice', NULL, 'Sanchez', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Sanchez/Beatrice', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1048, 1, NULL, 'Max', NULL, 'Morris', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Morris/Max', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1049, 1, NULL, 'Olivia', NULL, 'Rogers', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Rogers/Olivia', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1050, 1, NULL, 'Theo', NULL, 'Reed', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Reed/Theo', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1051, 1, NULL, 'Fatima', NULL, 'Cook', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Cook/Fatima', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1052, 1, NULL, 'George', NULL, 'Morgan', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Morgan/George', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1053, 1, NULL, 'Iris', NULL, 'Bell', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Bell/Iris', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1054, 1, NULL, 'Ben', NULL, 'Murphy', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Murphy/Ben', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1055, 1, NULL, 'Diana', NULL, 'Bailey', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Bailey/Diana', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1056, 1, NULL, 'Kai', NULL, 'Rivera', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Rivera/Kai', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1057, 1, NULL, 'Monica', NULL, 'Cooper', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Cooper/Monica', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1058, 1, NULL, 'Luis', NULL, 'Richardson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Richardson/Luis', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1059, 1, NULL, 'Emily', NULL, 'Cox', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Cox/Emily', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1060, 1, NULL, 'Arjun', NULL, 'Howard', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Howard/Arjun', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1061, 1, NULL, 'Marisol', NULL, 'Ward', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Ward/Marisol', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1062, 1, NULL, 'Caleb', NULL, 'Peterson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Peterson/Caleb', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1063, 1, NULL, 'Freya', NULL, 'Gray', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Gray/Freya', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1064, 1, NULL, 'Omar', NULL, 'Ramirez', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Ramirez/Omar', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1065, 1, NULL, 'Zoe', NULL, 'James', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'James/Zoe', 'Hoboken', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1066, 1, NULL, 'Nathan', NULL, 'Watson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Watson/Nathan', 'White Plains', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1067, 1, NULL, 'Yara', NULL, 'Brooks', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Brooks/Yara', 'Newark', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1068, 1, NULL, 'Lucas', NULL, 'Kelly', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Kelly/Lucas', 'Stamford', 'CT');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1069, 1, NULL, 'Claire', NULL, 'Sanders', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Sanders/Claire', 'Yonkers', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1070, 1, NULL, 'Ethan', NULL, 'Price', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 1, NULL, 'Price/Ethan', 'Beacon', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1071, 1, NULL, 'Mina', NULL, 'Bennett', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Bennett/Mina', 'Brooklyn', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1072, 1, NULL, 'Adrian', NULL, 'Wood', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Wood/Adrian', 'New York', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1073, 1, NULL, 'Tara', NULL, 'Barnes', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Barnes/Tara', 'Queens', 'NY');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1074, 1, NULL, 'Cole', NULL, 'Ross', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Ross/Cole', 'Jersey City', 'NJ');
INSERT INTO T_CUSTOMER (customer_no, cust_type, prefix, fname, mname, lname, suffix, name_status, mail_ind, phone_ind, last_activity_dt, last_gift_dt, last_ticket_dt, emarket_ind, primary_address_no, email, inactive, inactive_reason, sort_name, city, state) VALUES (1075, 1, NULL, 'Vivian', NULL, 'Henderson', NULL, 1, 3, 3, NULL, NULL, NULL, 3, NULL, NULL, 0, NULL, 'Henderson/Vivian', 'Hoboken', 'NJ');

INSERT INTO T_FUND (fund_no, description, ticketing_ind, inactive, BU) VALUES (4, 'Friends Fund', 'Y', 'N', 1);
INSERT INTO T_FUND (fund_no, description, ticketing_ind, inactive, BU) VALUES (5, 'Education Fund', 'N', 'N', 1);
INSERT INTO T_FUND (fund_no, description, ticketing_ind, inactive, BU) VALUES (6, 'Special Events Fund', 'N', 'N', 1);
INSERT INTO T_FUND (fund_no, description, ticketing_ind, inactive, BU) VALUES (7, 'Community Programs Fund', 'N', 'N', 1);

INSERT INTO T_CAMPAIGN (campaign_no, default_fund, description, camp_type, goal_amt, start_dt, end_dt, status, category, fyear, inactive) VALUES (12345, 4, 'Annual Giving FY26', 'C', 250000.00, '2025-07-01 00:00:00.000', '2026-06-30 23:59:59.997', 'A', 22, 2026, 'N');
INSERT INTO T_CAMPAIGN (campaign_no, default_fund, description, camp_type, goal_amt, start_dt, end_dt, status, category, fyear, inactive) VALUES (12346, 4, 'Spring Membership Campaign', 'C', 75000.00, '2026-03-01 00:00:00.000', '2026-05-31 23:59:59.997', 'A', 22, 2026, 'N');
INSERT INTO T_CAMPAIGN (campaign_no, default_fund, description, camp_type, goal_amt, start_dt, end_dt, status, category, fyear, inactive) VALUES (12347, 5, 'Education Access Fund', 'C', 100000.00, '2025-09-01 00:00:00.000', '2026-08-31 23:59:59.997', 'A', 31, 2026, 'N');
INSERT INTO T_CAMPAIGN (campaign_no, default_fund, description, camp_type, goal_amt, start_dt, end_dt, status, category, fyear, inactive) VALUES (12348, 6, 'Opening Night Benefit', 'C', 150000.00, '2026-01-01 00:00:00.000', '2026-04-30 23:59:59.997', 'A', 18, 2026, 'N');
INSERT INTO T_CAMPAIGN (campaign_no, default_fund, description, camp_type, goal_amt, start_dt, end_dt, status, category, fyear, inactive) VALUES (12349, 7, 'Community Arts Campaign', 'C', 50000.00, '2025-07-01 00:00:00.000', '2026-06-30 23:59:59.997', 'A', 22, 2026, 'N');
INSERT INTO T_CAMPAIGN (campaign_no, default_fund, description, camp_type, goal_amt, start_dt, end_dt, status, category, fyear, inactive) VALUES (12350, 4, 'Prior Year Annual Giving FY25', 'C', 200000.00, '2024-07-01 00:00:00.000', '2025-06-30 23:59:59.997', 'C', 22, 2025, 'N');

INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (100, 'Mainstage Music Series', 'T', 'MainMusic');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (101, 'Spring Dance Festival', 'T', 'DanceFest');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (102, 'Family Matinee Series', 'T', 'FamilyMat');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (103, 'New Works Theater', 'T', 'NewWorks');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (104, 'Community Concerts', 'T', 'CommConc');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (200, '2026 Mainstage Music Season', 'S', '26Music');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (201, '2026 Dance Festival Season', 'S', '26Dance');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (202, '2026 Family Matinee Season', 'S', '26Family');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (203, '2026 Theater Season', 'S', '26Theater');
INSERT INTO T_INVENTORY (inv_no, description, type, short_name) VALUES (204, '2026 Community Season', 'S', '26Comm');

INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2001, 200, 1, 1, 10, NULL, 'MUSIC01', 86, '2026-01-10 20:00:00.000', 1, '2025-10-01 10:00:00.000', '2026-01-10 20:00:00.000', 1, 12345, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2002, 200, 1, 1, 10, NULL, 'MUSIC02', 86, '2026-01-11 15:00:00.000', 1, '2025-10-01 10:00:00.000', '2026-01-11 15:00:00.000', 1, 12345, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2003, 201, 1, 1, 20, NULL, 'DANCE01', 86, '2026-02-14 19:30:00.000', 1, '2025-11-15 10:00:00.000', '2026-02-14 19:30:00.000', 1, 12346, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2004, 201, 1, 1, 20, NULL, 'DANCE02', 86, '2026-02-15 14:00:00.000', 1, '2025-11-15 10:00:00.000', '2026-02-15 14:00:00.000', 1, 12346, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2005, 202, 1, 1, 30, NULL, 'FAMILY01', 86, '2026-03-07 11:00:00.000', 1, '2025-12-01 10:00:00.000', '2026-03-07 11:00:00.000', 1, 12347, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2006, 202, 1, 1, 30, NULL, 'FAMILY02', 86, '2026-03-07 14:00:00.000', 1, '2025-12-01 10:00:00.000', '2026-03-07 14:00:00.000', 1, 12347, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2007, 203, 1, 1, 40, NULL, 'THEATER1', 86, '2026-04-03 20:00:00.000', 1, '2026-01-05 10:00:00.000', '2026-04-03 20:00:00.000', 1, 12348, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2008, 203, 1, 1, 40, NULL, 'THEATER2', 86, '2026-04-04 20:00:00.000', 1, '2026-01-05 10:00:00.000', '2026-04-04 20:00:00.000', 1, 12348, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2009, 204, 1, 1, 50, NULL, 'COMM001', 86, '2026-05-16 18:00:00.000', 1, '2026-02-01 10:00:00.000', '2026-05-16 18:00:00.000', 1, 12349, 2);
INSERT INTO T_PERF (perf_no, prod_season_no, bsmap_no, zmap_no, facility_no, ben_fund_no, perf_code, perf_type, perf_dt, perf_status, def_start_sale_dt, def_end_sale_dt, time_slot, campaign_no, season) VALUES (2010, 204, 1, 1, 50, NULL, 'COMM002', 86, '2026-06-20 18:00:00.000', 1, '2026-02-01 10:00:00.000', '2026-06-20 18:00:00.000', 1, 12349, 2);

INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (600, 1005, '2026-01-02 00:00:00.000', 5.00, 5.00, 'G', 12345, 3600, 1, NULL, 'Practice contribution for $5.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (601, 1006, '2026-01-03 13:30:00.000', 5.00, 5.00, 'G', 12345, 3601, 1, NULL, 'Practice contribution for $5.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (602, 1007, '2025-12-15 00:00:00.000', 5.00, 5.00, 'G', 12345, 3602, 1, NULL, 'Practice contribution for $5.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (603, 1008, '2026-02-01 09:15:00.000', 10.00, 10.00, 'G', 12345, 3603, 1, NULL, 'Practice contribution for $10.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (604, 1009, '2026-02-02 00:00:00.000', 10.00, 10.00, 'G', 12346, 3604, 1, NULL, 'Practice contribution for $10.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (605, 1010, '2026-03-05 00:00:00.000', 5.00, 5.00, 'G', 12346, 3605, 1, NULL, 'Practice contribution for $5.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (606, 1011, '2026-03-06 12:00:00.000', 5.00, 5.00, 'G', 12347, 3606, 1, NULL, 'Practice contribution for $5.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (607, 1012, '2026-04-01 00:00:00.000', 25.00, 25.00, 'G', 12345, 3607, 1, NULL, 'Practice contribution for $25.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (608, 1013, '2026-04-10 00:00:00.000', 100.00, 100.00, 'G', 12348, 3608, 1, NULL, 'Practice contribution for $100.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (609, 1014, '2026-05-01 00:00:00.000', 250.00, 250.00, 'G', 12349, 3609, 1, NULL, 'Practice contribution for $250.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (610, 1001, '2025-07-01 00:00:00.000', 50, 50, 'G', 12345, 3610, 1, NULL, 'Practice contribution for $50.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (611, 1004, '2025-07-09 00:00:00.000', 75, 75, 'G', 12346, 3611, 1, NULL, 'Practice contribution for $75.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (612, 1007, '2025-07-17 00:00:00.000', 100, 100, 'G', 12347, 3612, 1, NULL, 'Practice contribution for $100.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (613, 1010, '2025-07-25 00:00:00.000', 125, 125, 'G', 12348, 3613, 1, NULL, 'Practice contribution for $125.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (614, 1013, '2025-08-02 00:00:00.000', 150, 150, 'G', 12349, 3614, 1, NULL, 'Practice contribution for $150.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (615, 1016, '2025-08-10 00:00:00.000', 250, 250, 'G', 12350, 3615, 1, NULL, 'Practice contribution for $250.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (616, 1019, '2025-08-18 00:00:00.000', 500, 500, 'G', 12345, 3616, 1, NULL, 'Practice contribution for $500.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (617, 1022, '2025-08-26 00:00:00.000', 1000, 1000, 'G', 12346, 3617, 1, NULL, 'Practice contribution for $1000.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (618, 1025, '2025-09-03 00:00:00.000', 1500, 1500, 'G', 12347, 3618, 1, NULL, 'Practice contribution for $1500.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (619, 1028, '2025-09-11 00:00:00.000', 2500, 2500, 'G', 12348, 3619, 1, NULL, 'Practice contribution for $2500.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (620, 1031, '2025-09-19 00:00:00.000', 50, 50, 'G', 12349, 3620, 1, NULL, 'Practice contribution for $50.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (621, 1034, '2025-09-27 00:00:00.000', 75, 75, 'G', 12350, 3621, 1, NULL, 'Practice contribution for $75.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (622, 1037, '2025-10-05 00:00:00.000', 100, 100, 'G', 12345, 3622, 1, NULL, 'Practice contribution for $100.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (623, 1040, '2025-10-13 00:00:00.000', 125, 125, 'G', 12346, 3623, 1, NULL, 'Practice contribution for $125.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (624, 1043, '2025-10-21 00:00:00.000', 150, 150, 'G', 12347, 3624, 1, NULL, 'Practice contribution for $150.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (625, 1046, '2025-10-29 00:00:00.000', 250, 250, 'G', 12348, 3625, 1, NULL, 'Practice contribution for $250.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (626, 1049, '2025-11-06 00:00:00.000', 500, 500, 'G', 12349, 3626, 1, NULL, 'Practice contribution for $500.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (627, 1052, '2025-11-14 00:00:00.000', 1000, 1000, 'G', 12350, 3627, 1, NULL, 'Practice contribution for $1000.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (628, 1055, '2025-11-22 00:00:00.000', 1500, 1500, 'G', 12345, 3628, 1, NULL, 'Practice contribution for $1500.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (629, 1058, '2025-11-30 00:00:00.000', 2500, 2500, 'G', 12346, 3629, 1, NULL, 'Practice contribution for $2500.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (630, 1001, '2025-12-08 00:00:00.000', 50, 50, 'G', 12347, 3630, 1, NULL, 'Practice contribution for $50.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (631, 1004, '2025-12-16 00:00:00.000', 75, 75, 'G', 12348, 3631, 1, NULL, 'Practice contribution for $75.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (632, 1007, '2025-12-24 00:00:00.000', 100, 100, 'G', 12349, 3632, 1, NULL, 'Practice contribution for $100.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (633, 1010, '2026-01-01 00:00:00.000', 125, 125, 'G', 12350, 3633, 1, NULL, 'Practice contribution for $125.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (634, 1013, '2026-01-09 00:00:00.000', 150, 150, 'G', 12345, 3634, 1, NULL, 'Practice contribution for $150.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (635, 1016, '2026-01-17 00:00:00.000', 250, 250, 'G', 12346, 3635, 1, NULL, 'Practice contribution for $250.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (636, 1019, '2026-01-25 00:00:00.000', 500, 500, 'G', 12347, 3636, 1, NULL, 'Practice contribution for $500.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (637, 1022, '2026-02-02 00:00:00.000', 1000, 1000, 'G', 12348, 3637, 1, NULL, 'Practice contribution for $1000.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (638, 1025, '2026-02-10 00:00:00.000', 1500, 1500, 'G', 12349, 3638, 1, NULL, 'Practice contribution for $1500.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (639, 1028, '2026-02-18 00:00:00.000', 2500, 2500, 'G', 12350, 3639, 1, NULL, 'Practice contribution for $2500.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (640, 1031, '2026-02-26 00:00:00.000', 50, 50, 'G', 12345, 3640, 1, NULL, 'Practice contribution for $50.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (641, 1034, '2026-03-06 00:00:00.000', 75, 75, 'G', 12346, 3641, 1, NULL, 'Practice contribution for $75.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (642, 1037, '2026-03-14 00:00:00.000', 100, 100, 'G', 12347, 3642, 1, NULL, 'Practice contribution for $100.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (643, 1040, '2026-03-22 00:00:00.000', 125, 125, 'G', 12348, 3643, 1, NULL, 'Practice contribution for $125.', 'N', 6, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (644, 1043, '2026-03-30 00:00:00.000', 150, 150, 'G', 12349, 3644, 1, NULL, 'Practice contribution for $150.', 'N', 7, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (645, 1046, '2026-04-07 00:00:00.000', 250, 250, 'G', 12350, 3645, 1, NULL, 'Practice contribution for $250.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (646, 1049, '2026-04-15 00:00:00.000', 500, 500, 'G', 12345, 3646, 1, NULL, 'Practice contribution for $500.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (647, 1052, '2026-04-23 00:00:00.000', 1000, 1000, 'G', 12346, 3647, 1, NULL, 'Practice contribution for $1000.', 'N', 4, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (648, 1055, '2026-05-01 00:00:00.000', 1500, 1500, 'G', 12347, 3648, 1, NULL, 'Practice contribution for $1500.', 'N', 5, 3, 6);
INSERT INTO T_CONTRIBUTION (ref_no, customer_no, cont_dt, recd_amt, cont_amt, cont_type, campaign_no, appeal_no, media_type, source_no, notes, cancel, fund_no, n1n2_ind, channel) VALUES (649, 1058, '2026-05-09 00:00:00.000', 2500, 2500, 'G', 12348, 3649, 1, NULL, 'Practice contribution for $2500.', 'N', 6, 3, 6);

INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5001, 301, 401, 1003, 'N', '2026-01-06 13:00:00.000', 1, 60, 0.00, 0.00, 0.00, 60, 60, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5002, 302, 402, 1005, 'N', '2026-01-11 13:00:00.000', 1, 90, 0.00, 0.00, 0.00, 90, 90, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5003, 303, 403, 1007, 'N', '2026-01-16 13:00:00.000', 1, 120, 0.00, 0.00, 0.00, 120, 120, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5004, 304, 404, 1009, 'N', '2026-01-21 13:00:00.000', 1, 150, 0.00, 0.00, 0.00, 150, 150, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5005, 305, 405, 1011, 'N', '2026-01-26 13:00:00.000', 1, 45, 0.00, 0.00, 0.00, 45, 45, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5006, 306, 406, 1013, 'N', '2026-01-31 13:00:00.000', 1, 60, 0.00, 0.00, 0.00, 60, 60, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5007, 307, 407, 1015, 'N', '2026-02-05 13:00:00.000', 1, 90, 0.00, 0.00, 0.00, 90, 90, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5008, 308, 408, 1017, 'N', '2026-02-10 13:00:00.000', 1, 120, 0.00, 0.00, 0.00, 120, 120, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5009, 309, 409, 1019, 'N', '2026-02-15 13:00:00.000', 1, 150, 0.00, 0.00, 0.00, 150, 150, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5010, 310, 410, 1021, 'N', '2026-02-20 13:00:00.000', 1, 45, 0.00, 0.00, 0.00, 45, 45, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5011, 311, 411, 1023, 'N', '2026-02-25 13:00:00.000', 1, 60, 0.00, 0.00, 0.00, 60, 60, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5012, 312, 412, 1025, 'N', '2026-03-02 13:00:00.000', 1, 90, 0.00, 0.00, 0.00, 90, 90, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5013, 313, 413, 1027, 'N', '2026-03-07 13:00:00.000', 1, 120, 0.00, 0.00, 0.00, 120, 120, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5014, 314, 414, 1029, 'N', '2026-03-12 13:00:00.000', 1, 150, 0.00, 0.00, 0.00, 150, 150, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5015, 315, 415, 1031, 'N', '2026-03-17 13:00:00.000', 1, 45, 0.00, 0.00, 0.00, 45, 45, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5016, 316, 416, 1033, 'N', '2026-03-22 13:00:00.000', 1, 60, 0.00, 0.00, 0.00, 60, 60, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5017, 317, 417, 1035, 'N', '2026-03-27 13:00:00.000', 1, 90, 0.00, 0.00, 0.00, 90, 90, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5018, 318, 418, 1037, 'N', '2026-04-01 13:00:00.000', 1, 120, 0.00, 0.00, 0.00, 120, 120, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5019, 319, 419, 1039, 'N', '2026-04-06 13:00:00.000', 1, 150, 0.00, 0.00, 0.00, 150, 150, 3, 6, 1);
INSERT INTO T_ORDER (order_no, appeal_no, source_no, customer_no, cancel_ind, order_dt, batch_no, tot_ticket_purch_amt, tot_ticket_return_amt, tot_fee_amt, tot_contribution_amt, tot_due_amt, tot_paid_amt, delivery, channel, fully_paid_ind) VALUES (5020, 320, 420, 1041, 'N', '2026-04-11 13:00:00.000', 1, 45, 0.00, 0.00, 0.00, 45, 45, 3, 6, 1);

INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8000, 1, NULL, NULL, 25, 25, 1, 100000, 9000, NULL, NULL, 7, 2001, 0, 10, NULL, 11, 0, NULL, 5001, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8001, 2, NULL, NULL, 35, 35, 2, 100001, 9001, NULL, NULL, 7, 2002, 0, 11, NULL, 11, 0, NULL, 5002, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8002, 3, NULL, NULL, 45, 45, 3, 100002, 9002, NULL, NULL, 7, 2003, 0, 12, NULL, 11, 0, NULL, 5003, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8003, 4, NULL, NULL, 60, 60, 4, 100003, 9003, NULL, NULL, 7, 2004, 0, 13, NULL, 11, 0, NULL, 5004, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8004, 5, NULL, NULL, 75, 75, 1, 100004, 9004, NULL, NULL, 7, 2005, 0, 14, NULL, 11, 0, NULL, 5005, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8005, 6, NULL, NULL, 25, 25, 2, 100005, 9005, NULL, NULL, 7, 2006, 0, 10, NULL, 11, 0, NULL, 5006, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8006, 7, NULL, NULL, 35, 35, 3, 100006, 9006, NULL, NULL, 7, 2007, 0, 11, NULL, 11, 0, NULL, 5007, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8007, 8, NULL, NULL, 45, 45, 4, 100007, 9007, NULL, NULL, 7, 2008, 0, 12, NULL, 11, 0, NULL, 5008, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8008, 9, NULL, NULL, 60, 60, 1, 100008, 9008, NULL, NULL, 7, 2009, 0, 13, NULL, 11, 0, NULL, 5009, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8009, 10, NULL, NULL, 75, 75, 2, 100009, 9009, NULL, NULL, 7, 2010, 0, 14, NULL, 11, 0, NULL, 5010, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8010, 11, NULL, NULL, 25, 25, 3, 100010, 9010, NULL, NULL, 7, 2001, 0, 10, NULL, 11, 0, NULL, 5011, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8011, 12, NULL, NULL, 35, 35, 4, 100011, 9011, NULL, NULL, 7, 2002, 0, 11, NULL, 11, 0, NULL, 5012, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8012, 13, NULL, NULL, 45, 45, 1, 100012, 9012, NULL, NULL, 7, 2003, 0, 12, NULL, 11, 0, NULL, 5013, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8013, 14, NULL, NULL, 60, 60, 2, 100013, 9013, NULL, NULL, 7, 2004, 0, 13, NULL, 11, 0, NULL, 5014, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8014, 15, NULL, NULL, 75, 75, 3, 100014, 9014, NULL, NULL, 7, 2005, 0, 14, NULL, 11, 0, NULL, 5015, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8015, 16, NULL, NULL, 25, 25, 4, 100015, 9015, NULL, NULL, 7, 2006, 0, 10, NULL, 11, 0, NULL, 5016, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8016, 17, NULL, NULL, 35, 35, 1, 100016, 9016, NULL, NULL, 7, 2007, 0, 11, NULL, 11, 0, NULL, 5017, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8017, 18, NULL, NULL, 45, 45, 2, 100017, 9017, NULL, NULL, 7, 2008, 0, 12, NULL, 11, 0, NULL, 5018, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8018, 19, NULL, NULL, 60, 60, 3, 100018, 9018, NULL, NULL, 7, 2009, 0, 13, NULL, 11, 0, NULL, 5019, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8019, 20, NULL, NULL, 75, 75, 4, 100019, 9019, NULL, NULL, 7, 2010, 0, 14, NULL, 11, 0, NULL, 5020, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8020, 21, NULL, NULL, 25, 25, 1, 100020, 9020, NULL, NULL, 7, 2001, 0, 10, NULL, 11, 0, NULL, 5001, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8021, 22, NULL, NULL, 35, 35, 2, 100021, 9021, NULL, NULL, 7, 2002, 0, 11, NULL, 11, 0, NULL, 5002, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8022, 23, NULL, NULL, 45, 45, 3, 100022, 9022, NULL, NULL, 7, 2003, 0, 12, NULL, 11, 0, NULL, 5003, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8023, 24, NULL, NULL, 60, 60, 4, 100023, 9023, NULL, NULL, 7, 2004, 0, 13, NULL, 11, 0, NULL, 5004, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8024, 25, NULL, NULL, 75, 75, 1, 100024, 9024, NULL, NULL, 7, 2005, 0, 14, NULL, 11, 0, NULL, 5005, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8025, 26, NULL, NULL, 25, 25, 2, 100025, 9025, NULL, NULL, 7, 2006, 0, 10, NULL, 11, 0, NULL, 5006, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8026, 27, NULL, NULL, 35, 35, 3, 100026, 9026, NULL, NULL, 7, 2007, 0, 11, NULL, 11, 0, NULL, 5007, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8027, 28, NULL, NULL, 45, 45, 4, 100027, 9027, NULL, NULL, 7, 2008, 0, 12, NULL, 11, 0, NULL, 5008, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8028, 29, NULL, NULL, 60, 60, 1, 100028, 9028, NULL, NULL, 7, 2009, 0, 13, NULL, 11, 0, NULL, 5009, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8029, 30, NULL, NULL, 75, 75, 2, 100029, 9029, NULL, NULL, 7, 2010, 0, 14, NULL, 11, 0, NULL, 5010, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8030, 31, NULL, NULL, 25, 25, 3, 100030, 9030, NULL, NULL, 7, 2001, 0, 10, NULL, 11, 0, NULL, 5011, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8031, 32, NULL, NULL, 35, 35, 4, 100031, 9031, NULL, NULL, 7, 2002, 0, 11, NULL, 11, 0, NULL, 5012, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8032, 33, NULL, NULL, 45, 45, 1, 100032, 9032, NULL, NULL, 7, 2003, 0, 12, NULL, 11, 0, NULL, 5013, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8033, 34, NULL, NULL, 60, 60, 2, 100033, 9033, NULL, NULL, 7, 2004, 0, 13, NULL, 11, 0, NULL, 5014, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8034, 35, NULL, NULL, 75, 75, 3, 100034, 9034, NULL, NULL, 7, 2005, 0, 14, NULL, 11, 0, NULL, 5015, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8035, 36, NULL, NULL, 25, 25, 4, 100035, 9035, NULL, NULL, 7, 2006, 0, 10, NULL, 11, 0, NULL, 5016, NULL, NULL, NULL, 4);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8036, 37, NULL, NULL, 35, 35, 1, 100036, 9036, NULL, NULL, 7, 2007, 0, 11, NULL, 11, 0, NULL, 5017, NULL, NULL, NULL, 1);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8037, 38, NULL, NULL, 45, 45, 2, 100037, 9037, NULL, NULL, 7, 2008, 0, 12, NULL, 11, 0, NULL, 5018, NULL, NULL, NULL, 2);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8038, 39, NULL, NULL, 60, 60, 3, 100038, 9038, NULL, NULL, 7, 2009, 0, 13, NULL, 11, 0, NULL, 5019, NULL, NULL, NULL, 3);
INSERT INTO T_SUB_LINEITEM (sli_no, li_seq_no, unseatable_code, fee_amt, due_amt, paid_amt, price_type, seat_no, ticket_no, cancel_ind, sr_ind, sli_status, perf_no, pkg_no, zone_no, sli_status_code, batch_no, mir_lock, ret_parent_sli_no, order_no, recipient_no, rule_id, rule_ind, original_price_type) VALUES (8039, 40, NULL, NULL, 75, 75, 4, 100039, 9039, NULL, NULL, 7, 2010, 0, 14, NULL, 11, 0, NULL, 5020, NULL, NULL, NULL, 4);

-- Verify setup
SELECT 'T_CUSTOMER' AS table_name, COUNT(*) AS row_count FROM T_CUSTOMER
UNION ALL SELECT 'T_CONTRIBUTION', COUNT(*) FROM T_CONTRIBUTION
UNION ALL SELECT 'T_PERF', COUNT(*) FROM T_PERF
UNION ALL SELECT 'T_ORDER', COUNT(*) FROM T_ORDER
UNION ALL SELECT 'T_SUB_LINEITEM', COUNT(*) FROM T_SUB_LINEITEM
UNION ALL SELECT 'T_CAMPAIGN', COUNT(*) FROM T_CAMPAIGN
UNION ALL SELECT 'T_FUND', COUNT(*) FROM T_FUND
UNION ALL SELECT 'T_INVENTORY', COUNT(*) FROM T_INVENTORY;
