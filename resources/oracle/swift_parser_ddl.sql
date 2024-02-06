  CREATE TABLE "DOC_REFERENCES" 
   (	"ID" NUMBER, 
	"DOC_ID" NUMBER, 
	"REFNO" VARCHAR2(4000), 
	"TEXT_DATA" CLOB, 
	"CREATED_AT" TIMESTAMP (6) WITH LOCAL TIME ZONE DEFAULT systimestamp, 
	"CURR" VARCHAR2(20), 
	"MESSAGE_TYPE" VARCHAR2(20), 
	"IO_MODE" VARCHAR2(20), 
	"TIME_STAMP" VARCHAR2(20), 
	"TDATE" DATE DEFAULT sysdate, 
	 CONSTRAINT "DOC_REFERENCES_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "SWIFT_DOCUMENT" 
   (	"ID" NUMBER, 
	"DOC" CLOB, 
	"TYPE_ID" NUMBER, 
	"CREATED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"FILENAME" VARCHAR2(500), 
	"SOURCE_FILE" CLOB, 
	"REFERENCE" VARCHAR2(200), 
	"STATUS" VARCHAR2(10) DEFAULT 'draft', 
	 CONSTRAINT "SWIFT_DOCUMENT_DOC_JSON" CHECK ( "DOC" is json) ENABLE, 
	 CONSTRAINT "SWIFT_DOCUMENT_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "SWIFT_DOCUMENT_CON" UNIQUE ("FILENAME") DISABLE
   ) ;

  CREATE TABLE "APPLICATIONS" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(20), 
	"DESCRIPTION" VARCHAR2(300), 
	 CONSTRAINT "APPLICATIONS_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "CURRENCY" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(100), 
	"DESCRIPTION" VARCHAR2(100), 
	 CONSTRAINT "CURRENCY_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "MESSAGE_TYPE" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(500), 
	"DESCRIPTION" VARCHAR2(500), 
	"PURPOSE" VARCHAR2(500), 
	"TYPE_ID" NUMBER, 
	 CONSTRAINT "MESSAGE_TYPE_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "ROLES" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(500), 
	"DESCRIPTION" VARCHAR2(100), 
	 CONSTRAINT "ROLES_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "SERVICES" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(20), 
	"DESCRIPTION" VARCHAR2(200), 
	 CONSTRAINT "SERVICES_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "SWIFT_FIELD" 
   (	"ID" NUMBER, 
	"NAME" VARCHAR2(500), 
	"TAG" VARCHAR2(30), 
	"TYPE_ID" NUMBER, 
	 CONSTRAINT "SWIFT_FIELD_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "USERS" 
   (	"ID" NUMBER, 
	"FNAME" VARCHAR2(100), 
	"LNAME" VARCHAR2(100), 
	"USERNAME" VARCHAR2(100), 
	"PASSWD" VARCHAR2(500), 
	"CREATED_AT" TIMESTAMP (6) DEFAULT systimestamp, 
	"MOBILE" VARCHAR2(100), 
	"CREATED_BY" NUMBER, 
	"ROLES" VARCHAR2(4000), 
	"PASSWORD_RESET_TOKEN" VARCHAR2(100), 
	 CONSTRAINT "USERS_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE, 
	 CONSTRAINT "USERS_UK1" UNIQUE ("USERNAME")
  USING INDEX  ENABLE
   ) ;

  CREATE TABLE "USER_ROLES" 
   (	"USER_ID" NUMBER, 
	"ROLE_ID" NUMBER, 
	 CONSTRAINT "USER_ROLES_PK" PRIMARY KEY ("USER_ID", "ROLE_ID")
  USING INDEX  ENABLE
   ) ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_APPLICATIONS" 
  before insert on "APPLICATIONS"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "APPLICATIONS_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_APPLICATIONS" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_CURRENCY" 
  before insert on "CURRENCY"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "CURRENCY_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_CURRENCY" ENABLE;

  CREATE INDEX "DOC_REFERENCES_IDX1" ON "DOC_REFERENCES" ("REFNO") 
  ;

  CREATE INDEX "DOC_REFERENCES_MESSAGETYPE_IDX" ON "DOC_REFERENCES" ("MESSAGE_TYPE") 
  ;

  CREATE INDEX "DOC_REFERENCES_CURR_IDX" ON "DOC_REFERENCES" ("CURR") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_DOC_REFERENCES" before 
  INSERT ON "DOC_REFERENCES" FOR EACH row BEGIN IF :NEW."ID" IS NULL THEN 
  SELECT "DOC_REFERENCES_SEQ".nextval INTO :NEW."ID" FROM sys.dual; 
END IF; 
:new.curr         := utl_swift.extract_currency(:new.text_data); 
:new.time_stamp   := utl_swift.extract_datetime(:new.text_data); 
:new.message_type := utl_swift.extract_message_type(:new.text_data); 
:new.io_mode      := utl_swift.extract_io_mode(:new.text_data); 
:new.tdate := nvl( to_date(:new.time_stamp,'YYMMDDHH24MI'),sysdate); 
END; 

/
ALTER TRIGGER "BI_DOC_REFERENCES" ENABLE;

  CREATE INDEX "MESSAGE_TYPE_ID_IDX" ON "MESSAGE_TYPE" ("TYPE_ID") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_MESSAGE_TYPE" 
  before insert on "MESSAGE_TYPE"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "MESSAGE_TYPE_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_MESSAGE_TYPE" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_ROLES" 
  before insert on "ROLES"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "ROLES_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_ROLES" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_SERVICES" 
  before insert on "SERVICES"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SERVICES_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_SERVICES" ENABLE;

  CREATE INDEX "SWIFT_DOC_STATUS_IDX" ON "SWIFT_DOCUMENT" ("STATUS") 
  ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_SWIFT_DOCUMENT" 
  before insert on "SWIFT_DOCUMENT"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SWIFT_DOCUMENT_SEQ".nextval into :NEW."ID" from sys.dual;  
      end if; 
end; 
 
 
 
 

/
ALTER TRIGGER "BI_SWIFT_DOCUMENT" ENABLE;
  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SWIFT_DOCUMENT_AI" 
AFTER 
insert on "SWIFT_DOCUMENT" 
for each row  
declare 
p_tokens apex_t_varchar2; 
p_text clob; 
p_doc_id number; 
p_ref varchar2(500); 
begin 
 p_tokens := apex_string.split(:new.source_file,'$'); 
 for i in 1..p_tokens.count loop 
 p_text := p_tokens(i); 
 -- dbms_output.put_line(p_text); 
 p_ref := utl_swift.extract_reference(p_text); 
 --  thi sis the issue , we need to get the reference into the doc_refernces table 
 insert into doc_references(doc_id,refno,text_data) values (:new.id,p_ref,p_text); 
 end loop; 
 exception  
 when others then null; 
end; 
 
 
 

/
ALTER TRIGGER "SWIFT_DOCUMENT_AI" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_SWIFT_FIELD" 
  before insert on "SWIFT_FIELD"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SWIFT_FIELD_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_SWIFT_FIELD" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_USERS" 
  before insert on "USERS"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "USERS_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_USERS" ENABLE;





























































  CREATE INDEX "DOC_REFERENCES_IDX1" ON "DOC_REFERENCES" ("REFNO") 
  ;

  CREATE INDEX "DOC_REFERENCE_TDATE_IDX" ON "DOC_REFERENCES" (TRUNC("TDATE")) 
  ;

  CREATE UNIQUE INDEX "USERS_UK1" ON "USERS" ("USERNAME") 
  ;

  CREATE INDEX "DOC_REFERENCES_MESSAGETYPE_IDX" ON "DOC_REFERENCES" ("MESSAGE_TYPE") 
  ;

  CREATE INDEX "DOC_REF_DATE_IDX" ON "DOC_REFERENCES" (TRUNC("CREATED_AT")) 
  ;

  CREATE INDEX "MESSAGE_TYPE_ID_IDX" ON "MESSAGE_TYPE" ("TYPE_ID") 
  ;

  CREATE INDEX "SWIFT_DOC_STATUS_IDX" ON "SWIFT_DOCUMENT" ("STATUS") 
  ;

  CREATE UNIQUE INDEX "USER_ROLES_PK" ON "USER_ROLES" ("USER_ID", "ROLE_ID") 
  ;

  CREATE INDEX "SWIFTDOC_MESSAGETYPE_IDX1" ON "SWIFT_DOCUMENT" (JSON_VALUE("DOC" FORMAT JSON , '$.MessageType' RETURNING VARCHAR2(4000) NULL ON ERROR)) 
  ;

  CREATE UNIQUE INDEX "SWIFT_FIELD_PK" ON "SWIFT_FIELD" ("ID") 
  ;

  CREATE UNIQUE INDEX "DOC_REFERENCES_PK" ON "DOC_REFERENCES" ("ID") 
  ;

  CREATE UNIQUE INDEX "CURRENCY_PK" ON "CURRENCY" ("ID") 
  ;

  CREATE UNIQUE INDEX "ROLES_PK" ON "ROLES" ("ID") 
  ;

  CREATE INDEX "DOC_REFERENCES_CURR_IDX" ON "DOC_REFERENCES" ("CURR") 
  ;

  CREATE UNIQUE INDEX "SWIFT_DOCUMENT_PK" ON "SWIFT_DOCUMENT" ("ID") 
  ;

  CREATE UNIQUE INDEX "APPLICATIONS_PK" ON "APPLICATIONS" ("ID") 
  ;

  CREATE INDEX "SWIFTDOC_MESSAGETYPE_IDX2" ON "SWIFT_DOCUMENT" (JSON_VALUE("DOC" FORMAT JSON , '$.Items[*].MessageType' RETURNING VARCHAR2(4000) NULL ON ERROR)) 
  ;

  CREATE UNIQUE INDEX "MESSAGE_TYPE_PK" ON "MESSAGE_TYPE" ("ID") 
  ;

  CREATE UNIQUE INDEX "SERVICES_PK" ON "SERVICES" ("ID") 
  ;

  CREATE UNIQUE INDEX "USERS_PK" ON "USERS" ("ID") 
  ;




















create or replace PACKAGE  "API" as  
  
FUNCTION validate_user (   
        p_username   IN VARCHAR2,   
        p_password   IN VARCHAR2   
    ) RETURN VARCHAR2;

function get_export_url(p_base_url in varchar2,p_from in varchar2,p_to varchar2,
 p_msg_type in varchar2, p_curr in varchar2,p_io_mode in varchar2) return varchar2;   
  
end;
/
create or replace PACKAGE  "AUTH" AS      
  
 procedure reset_password_with_token(p_token in varchar2,  
                                    p_password in varchar2);  
    
 FUNCTION has_role (    
        p_user   IN VARCHAR2,    
        p_role   IN VARCHAR2    
    ) RETURN BOOLEAN;    
     
function validate_username(p_username in varchar2) return varchar2;     
function validate_password(p_username in varchar2,p_password in varchar2) return varchar2;     
    PROCEDURE change_password (     
        p_username      IN VARCHAR2,     
        p_password   IN VARCHAR2     
    );     
    
    FUNCTION username_exists (     
        p_username IN VARCHAR2     
    ) RETURN BOOLEAN;     
     
    FUNCTION mobile_exists (     
        p_mobile IN VARCHAR2     
    ) RETURN BOOLEAN;     
     
    FUNCTION get_admin_id RETURN NUMBER;     
     
    PROCEDURE reset_password (     
        p_username   IN VARCHAR2,     
        p_passwd     IN VARCHAR2 DEFAULT NULL     
    );     
     
    FUNCTION verify_user (     
        p_username               IN VARCHAR2 DEFAULT NULL,     
        p_verification_code   IN VARCHAR2     
    ) RETURN BOOLEAN;     
     
    PROCEDURE create_user (     
        p_username       IN VARCHAR2 DEFAULT NULL,     
        p_mobile      IN VARCHAR2 DEFAULT NULL,     
        p_fname       IN VARCHAR2 DEFAULT NULL,     
        p_lname       IN VARCHAR2 DEFAULT NULL,     
        p_passwd      IN VARCHAR2 DEFAULT NULL,     
        p_loc_id      IN NUMBER DEFAULT NULL,     
        p_parent_id   IN NUMBER DEFAULT 1     
    );     
     
    
    FUNCTION login (     
        p_username   IN VARCHAR2,     
        p_password   IN VARCHAR2     
    ) RETURN BOOLEAN;     
     
    FUNCTION get_role (     
        p_id IN NUMBER     
    ) RETURN VARCHAR2;     
     
    FUNCTION user_role (     
        p_username IN VARCHAR2     
    ) RETURN VARCHAR2;     
     
    FUNCTION user_id (     
        p_username IN VARCHAR2     
    ) RETURN NUMBER;     
     
    FUNCTION user_currency (     
        p_username IN VARCHAR2     
    ) RETURN VARCHAR2;     
     
END;    
/
create or replace package"EMAIL_CONFIG" as  

p_mail_api varchar2(500) := 'http://172.30.0.1:8000/mail/password-reset' ;
procedure Mail_config( 
    p_message varchar2 default null, 
    p_to varchar2 default null 
); 
  
end EMAIL_CONFIG;
/
create or replace PACKAGE  "HELPERS"   
AS  

function http_get(
    l_url varchar2
) 
return clob;

function http_get_json(
    l_url varchar2
) 
return json;
function  CLOB_TO_BLOB (p_clob CLOB) return BLOB; 
function is_number (p_string IN VARCHAR2)  
  RETURN int;  
    
function string_between(p_str in CLOB,p_start in varchar,p_end in varchar)     
return varchar2;    
    
PROCEDURE http_raw_post (      
        p_endpoint   IN VARCHAR2,      
        p_body       IN VARCHAR2,      
        p_result IN OUT VARCHAR2,      
        p_type       IN VARCHAR2 DEFAULT 'text/plain'    );      
         
         
          
    PROCEDURE flash (      
        p_message   IN VARCHAR2,      
        p_type      IN VARCHAR2 DEFAULT 'Success'    );      
      
    FUNCTION urldecode (      
        p_string IN VARCHAR2      
    ) RETURN VARCHAR2;      
      
    FUNCTION md5 (      
        str IN VARCHAR2      
    ) RETURN VARCHAR2;      
--      
      
    FUNCTION blob_to_clob (      
        blob_in IN BLOB      
    ) RETURN CLOB;      
      
    FUNCTION str_replace (      
        p_in       IN CLOB,      
        p_search   IN VARCHAR2 DEFAULT ':',        p_with     IN VARCHAR2 DEFAULT ','    ) RETURN CLOB;      
      
    FUNCTION unix_time RETURN VARCHAR2;      
      
    FUNCTION hash (      
        str IN VARCHAR2      
    ) RETURN VARCHAR2;      
      
    FUNCTION random_string (      
        len IN NUMBER DEFAULT 5      
    ) RETURN VARCHAR2;      
      
    FUNCTION random_number (      
        p_start   IN NUMBER DEFAULT 100000,      
        p_end     IN NUMBER DEFAULT 999999      
    ) RETURN VARCHAR2;      
      
    FUNCTION generate_alphanum RETURN VARCHAR2;      
      
    FUNCTION call_url (      
        url IN VARCHAR2      
    ) RETURN CLOB;      
      
    FUNCTION url_encode (      
        p_data                    IN VARCHAR2,      
        p_escape_reserved_chars   IN BOOLEAN DEFAULT true      
    ) RETURN VARCHAR2;      
      
END;
/
create or replace PACKAGE  "PARSE"   
  /*     
  Generalized delimited string parsing package     
  Author: Steven Feuerstein, steven@stevenfeuerstein.com     
  Latest version always available on PL/SQL Obsession:     
  www.ToadWorld.com/SF     
  Click on "Trainings, Seminars and Presentations" and     
  then download the demo.zip file.     
  Modification History     
  Date          Change     
  10-APR-2009   Add support for nested list variations     
  Notes:     
  * This package does not validate correct use of delimiters.     
  It assumes valid construction of lists.     
  * Import the Q##PARSE.qut file into an installation of     
  Quest Code Tester 1.8.3 or higher in order to run     
  the regression test for this package.     
  */     
IS     
  SUBTYPE maxvarchar2_t IS VARCHAR2 (32767);     
  /*     
  Each of the collection types below correspond to (are returned by)     
  one of the parse functions.     
  items_tt - a simple list of strings     
  nested_items_tt - a list of lists of strings     
  named_nested_items_tt - a list of named lists of strings     
  This last type also demonstrates the power and elegance of string-indexed     
  collections. The name of the list of elements is the index value for     
  the "outer" collection.     
  */     
TYPE typStringTab     
IS     
  TABLE OF VARCHAR2(160) INDEX BY BINARY_INTEGER;     
TYPE items_tt     
IS     
  TABLE OF maxvarchar2_t INDEX BY PLS_INTEGER;     
TYPE nested_items_tt     
IS     
  TABLE OF items_tt INDEX BY PLS_INTEGER;     
TYPE named_nested_items_tt     
IS     
  TABLE OF items_tt INDEX BY maxvarchar2_t;     
FUNCTION get_split_for_special_chars(     
    p_text    IN VARCHAR2,     
    p_pattern IN VARCHAR2)     
  RETURN NUMBER;     
FUNCTION convert_to_date(     
    p_str IN VARCHAR2)     
  RETURN DATE;     
  /*     
  Slicing A Long PLSQL String Into Smaller Pieces     
  */     
FUNCTION slice_string(     
    pText IN VARCHAR2,     
    p_max IN NUMBER)     
  RETURN typStringTab;     
  /*     
  Parse lists with a single delimiter.     
  Example: a,b,c,d     
  Here is an example of using this function:     
  DECLARE     
  l_list parse.items_tt;     
  BEGIN     
  l_list := parse.string_to_list ('a,b,c,d', ',');     
  END;     
  */     
FUNCTION string_to_list(     
    string_in IN VARCHAR2,     
    delim_in  IN VARCHAR2)     
  RETURN items_tt;     
  /*     
  Parse lists with nested delimiters.     
  Example: a,b,c,d|1,2,3|x,y,z     
  Here is an example of using this function:     
  DECLARE     
  l_list parse.nested_items_tt;     
  BEGIN     
  l_list := parse.string_to_list ('a,b,c,d|1,2,3,4', '|', ',');     
  END;     
  */     
FUNCTION string_to_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 )     
  RETURN nested_items_tt;     
  /*     
  Parse named lists with nested delimiters.     
  Example: letters:a,b,c,d|numbers:1,2,3|names:steven,george     
  Here is an example of using this function:     
  DECLARE     
  l_list parse.named_nested_items_tt;     
  BEGIN     
  l_list := parse.string_to_list ('letters:a,b,c,d|numbers:1,2,3,4', '|', ':', ',');     
  END;     
  */     
FUNCTION string_to_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    name_delim_in  IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 )     
  RETURN named_nested_items_tt;     
PROCEDURE display_list(     
    string_in IN VARCHAR2 ,     
    delim_in  IN VARCHAR2:= ',' );     
PROCEDURE display_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 );     
PROCEDURE display_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    name_delim_in  IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 );     
PROCEDURE show_variations;     
  /* Helper function for automated testing */     
FUNCTION nested_eq(     
    list1_in    IN items_tt ,     
    list2_in    IN items_tt ,     
    nulls_eq_in IN BOOLEAN )     
  RETURN BOOLEAN;     
END parse;
/
create or replace PACKAGE  "UTL_JSON" is    
  function xml_to_json (input in xmltype) return clob;    
  function json_to_xml (input in clob) return xmltype;    
end utl_json;
/
create or replace PACKAGE "UTL_SWIFT" 
AS 
 
  function last_words(p_result clob,p_cnt number default 3) return clob; 
  FUNCTION remove_space_from_numbers( 
      p_clob CLOB) 
    RETURN CLOB; 
  FUNCTION extract_text2( 
      p_reference IN VARCHAR2, 
      p_source    IN CLOB) 
    RETURN VARCHAR2; 
  FUNCTION extract_customer( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION get_sender_country( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_message_type( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_io_mode( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_customer_account( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_transaction_amount( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_account_institution( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_remittance_information( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_beneficiary( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
    FUNCTION extract_country( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_datetime( 
      p_text IN CLOB ) 
    RETURN VARCHAR2; 
  FUNCTION extract_beneficiary_account( 
      p_text IN CLOB, 
      p_tag  IN VARCHAR2 DEFAULT '59' ) 
    RETURN VARCHAR2; 
  FUNCTION extract_reference( 
      p_text IN CLOB, 
      p_tag  IN VARCHAR2 DEFAULT '20' ) 
    RETURN VARCHAR2; 
  FUNCTION extract_currency( 
      p_text IN CLOB, 
      p_tag  IN VARCHAR2 DEFAULT '32' ) 
    RETURN VARCHAR2; 
  FUNCTION get_tag_value( 
      p_str IN CLOB, 
      p_tag IN VARCHAR2 ) 
    RETURN VARCHAR2; 
  FUNCTION format_text_block( 
      p_message_type IN VARCHAR2, 
      p_text         IN VARCHAR2 ) 
    RETURN VARCHAR2; 
  PROCEDURE get_file( 
      p_id IN VARCHAR2 ); 
  PROCEDURE get_json_file( 
      p_id IN NUMBER ); 
  PROCEDURE create_document( 
      p_json_doc    IN CLOB DEFAULT NULL, 
      p_filename    IN VARCHAR2 DEFAULT NULL, 
      p_source_file IN CLOB DEFAULT NULL ); 
  FUNCTION get_field_name( 
      p_type_id IN NUMBER, 
      p_tag     IN VARCHAR2 ) 
    RETURN VARCHAR2; 
  FUNCTION get_document( 
      p_reference IN NUMBER ) 
    RETURN CLOB; 
END;
/
create or replace PACKAGE  "UTL_SYNC" AS    
   
  /* TODO enter package declarations (types, exceptions, methods etc) here */    
  PROCEDURE get_messages;   
   
END UTL_SYNC;
/





























































































   CREATE SEQUENCE  "APPLICATIONS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "CURRENCY_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "MESSAGE_TYPE_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 2221 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "ROLES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "SERVICES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "USERS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 221 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "SWIFT_FIELD_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "DOC_REFERENCES_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

   CREATE SEQUENCE  "SWIFT_DOCUMENT_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;















































create or replace TRIGGER  "BI_APPLICATIONS"  
  before insert on "APPLICATIONS"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "APPLICATIONS_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "BI_CURRENCY"  
  before insert on "CURRENCY"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "CURRENCY_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "BI_DOC_REFERENCES" before 
  INSERT ON "DOC_REFERENCES" FOR EACH row BEGIN IF :NEW."ID" IS NULL THEN 
  SELECT "DOC_REFERENCES_SEQ".nextval INTO :NEW."ID" FROM sys.dual; 
END IF; 
:new.curr         := utl_swift.extract_currency(:new.text_data); 
:new.time_stamp   := utl_swift.extract_datetime(:new.text_data); 
:new.message_type := utl_swift.extract_message_type(:new.text_data); 
:new.io_mode      := utl_swift.extract_io_mode(:new.text_data); 
:new.tdate := nvl( to_date(:new.time_stamp,'YYMMDDHH24MI'),sysdate); 
END; 
/
create or replace TRIGGER  "BI_MESSAGE_TYPE"  
  before insert on "MESSAGE_TYPE"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "MESSAGE_TYPE_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "BI_ROLES"  
  before insert on "ROLES"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "ROLES_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "BI_SERVICES"  
  before insert on "SERVICES"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SERVICES_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "BI_SWIFT_DOCUMENT"  
  before insert on "SWIFT_DOCUMENT"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SWIFT_DOCUMENT_SEQ".nextval into :NEW."ID" from sys.dual;  
      end if; 
end; 
 
 
 
 
/
create or replace TRIGGER  "BI_SWIFT_FIELD"  
  before insert on "SWIFT_FIELD"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SWIFT_FIELD_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "BI_USERS"  
  before insert on "USERS"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "USERS_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 
/
create or replace TRIGGER  "SWIFT_DOCUMENT_AI"  
AFTER 
insert on "SWIFT_DOCUMENT" 
for each row  
declare 
p_tokens apex_t_varchar2; 
p_text clob; 
p_doc_id number; 
p_ref varchar2(500); 
begin 
 p_tokens := apex_string.split(:new.source_file,'$'); 
 for i in 1..p_tokens.count loop 
 p_text := p_tokens(i); 
 -- dbms_output.put_line(p_text); 
 p_ref := utl_swift.extract_reference(p_text); 
 --  thi sis the issue , we need to get the reference into the doc_refernces table 
 insert into doc_references(doc_id,refno,text_data) values (:new.id,p_ref,p_text); 
 end loop; 
 exception  
 when others then null; 
end; 
 
 
 
/




  CREATE OR REPLACE FORCE EDITIONABLE VIEW "FREE_FORMAT_MESSAGE_TYPES" ("TYPE_ID") AS 
  select type_id from message_type where type_id in (199,299,399,499,599,699,700,720,740,799,899,920,940,999);

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "MESSAGES" ("MESSAGE_TEXT", "ID", "FILENAME", "SOURCE_FILE", "CREATED_AT", "SENDER", "SENDER_ACCOUNT", "BENEFICIARY_ACCOUNT", "BENEFICIARY_CUSTOMER", "ACCOUNT_INSTITUTION", "TRANSACTION_AMOUNT", "CURR", "REFERENCE", "REMITTANCE_INFORMATION", "SERVICE_ID", "APP_ID", "ACK", "TERMINAL_ADDRESS", "SESSION_NUM", "SEQUENCE_NUM", "IO_MODE", "MESSAGE_TYPE", "TIME_STAMP", "RECIPIENT_BIC", "PRIORITY", "BANK_PRIORITY_CODE", "MUR", "AOK") AS 
  with swiftdoc as (select d.doc,d.filename,d.source_file,d.id,d.created_at,r.refno reference,r.text_data message_text,r.curr as currency,r.message_type,r.time_stamp,r.io_mode 
from swift_document d,doc_references r  
where d.id=r.doc_id) 
SELECT     
    s.message_text, 
    s.id,s.filename,dbms_lob.substr(s.source_file,30000) source_file,s.created_at,   
    utl_swift.extract_customer(message_text) sender,  
    utl_swift.extract_customer_account(message_text) sender_account,    
    utl_swift.extract_beneficiary_account(utl_swift.extract_text2(utl_swift.extract_reference(s.message_text),s.source_file)) beneficiary_account,   
    utl_swift.extract_beneficiary(utl_swift.extract_text2(utl_swift.extract_reference(s.message_text),s.source_file)) beneficiary_customer,   
    utl_swift.extract_account_institution(s.message_text) account_institution,   
    utl_swift.extract_transaction_amount(s.message_text) transaction_amount,    
    nvl(s.currency,utl_swift.extract_currency(s.message_text)) curr,    
    reference,  
    utl_swift.extract_remittance_information(s.message_text) remittance_information,  
    d."SERVICE_ID",d."APP_ID",d."ACK",d."TERMINAL_ADDRESS",d."SESSION_NUM",   
    d."SEQUENCE_NUM",nvl(s.io_mode,d."IO_MODE") io_mode,nvl(s.message_type,d."MESSAGE_TYPE") message_type,   
    nvl(s.time_stamp,   
        to_char(s.created_at,'YYMMDDHH24MI')) "TIME_STAMP",   
    d."RECIPIENT_BIC",d."PRIORITY",d."BANK_PRIORITY_CODE",d."MUR",d."AOK" 
FROM  
    swiftdoc s,      
    JSON_TABLE (doc, '$.Items[1]'     
            COLUMNS (     
                service_id VARCHAR2 ( 4000 ) PATH '$.ServiceId',     
                app_id VARCHAR2 ( 4000 ) PATH '$.ApplicationId',     
                ack VARCHAR2 ( 4000 ) PATH '$.Acknowledgment',     
                terminal_address VARCHAR2 ( 4000 ) PATH '$.TerminalAddress',     
                session_num VARCHAR2 ( 4000 ) PATH '$.SessionNumber',     
                sequence_num VARCHAR2 ( 4000 ) PATH '$.SequenceNumber',     
                io_mode VARCHAR2 ( 4000 ) PATH '$.Mode',     
                message_type number PATH '$.MessageType',     
                time_stamp VARCHAR2 ( 4000 ) PATH '$.Timestamp',     
                recipient_bic VARCHAR2 ( 4000 ) PATH '$.RecipientBIC',     
                priority VARCHAR2 ( 4000 ) PATH '$.MessagePriority',     
                bank_priority_code VARCHAR2 ( 4000 ) PATH '$.BankPriorityCode',     
                mur VARCHAR2 ( 4000 ) PATH '$.MessageUserReference',     
                aok VARCHAR2 ( 4000 ) PATH '$.AOK'   
            )     
        )     
    d 
;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "MESSAGES2" ("RECORD_ID", "ID", "REFNO", "MESSAGE_TEXT", "CREATED_AT", "MESSAGE_TYPE", "CURR", "IO_MODE", "TIME_STAMP", "TDATE", "FILENAME", "SOURCE_FILE", "SENDER", "SENDER_COUNTRY", "SENDER_ACCOUNT", "BENEFICIARY_ACCOUNT", "BENEFICIARY_CUSTOMER", "BENEFICIARY_COUNTRY", "ACCOUNT_INSTITUTION", "TRANSACTION_AMOUNT", "REMITTANCE_INFORMATION", "RECIPIENT_BIC", "PRIORITY", "BANK_PRIORITY_CODE", "MUR", "AOK", "SERVICE_ID", "APP_ID", "ACK", "TERMINAL_ADDRESS", "SESSION_NUM", "SEQUENCE_NUM") AS 
  select r.id record_id,r.doc_id id,r.refno,r. text_data message_text,r.created_at, 
r.message_type,r.curr,r.io_mode,r.time_stamp,r.tdate,s.filename,s.source_file, 
utl_swift.extract_customer(r.text_data) sender, 
utl_swift.get_sender_country(r.text_data) sender_country, 
utl_swift.extract_customer_account(r.text_data) sender_account,    
    utl_swift.extract_beneficiary_account(r.text_data) beneficiary_account,   
    utl_swift.extract_beneficiary(r.text_data) beneficiary_customer,   
     utl_swift.extract_country(r.text_data) beneficiary_country,   
    utl_swift.extract_account_institution(r.text_data) account_institution,   
    utl_swift.extract_transaction_amount(r.text_data) transaction_amount, 
    utl_swift.extract_remittance_information(r.text_data) remittance_information, 
    d."RECIPIENT_BIC",d."PRIORITY",d."BANK_PRIORITY_CODE",d."MUR",d."AOK", 
     d."SERVICE_ID",d."APP_ID",d."ACK",d."TERMINAL_ADDRESS",d."SESSION_NUM",   
    d."SEQUENCE_NUM" 
from doc_references r,swift_document s , 
JSON_TABLE (s.doc, '$.Items[1]'     
            COLUMNS (     
                service_id VARCHAR2 ( 4000 ) PATH '$.ServiceId',     
                app_id VARCHAR2 ( 4000 ) PATH '$.ApplicationId',     
                ack VARCHAR2 ( 4000 ) PATH '$.Acknowledgment',     
                terminal_address VARCHAR2 ( 4000 ) PATH '$.TerminalAddress',     
                session_num VARCHAR2 ( 4000 ) PATH '$.SessionNumber',     
                sequence_num VARCHAR2 ( 4000 ) PATH '$.SequenceNumber',        
                recipient_bic VARCHAR2 ( 4000 ) PATH '$.RecipientBIC',     
                priority VARCHAR2 ( 4000 ) PATH '$.MessagePriority',     
                bank_priority_code VARCHAR2 ( 4000 ) PATH '$.BankPriorityCode',     
                mur VARCHAR2 ( 4000 ) PATH '$.MessageUserReference',     
                aok VARCHAR2 ( 4000 ) PATH '$.AOK'   
            )     
        )     
    d 
where r.doc_id=s.id 
;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_APPLICATIONS" 
  before insert on "APPLICATIONS"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "APPLICATIONS_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_APPLICATIONS" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_CURRENCY" 
  before insert on "CURRENCY"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "CURRENCY_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_CURRENCY" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_DOC_REFERENCES" before 
  INSERT ON "DOC_REFERENCES" FOR EACH row BEGIN IF :NEW."ID" IS NULL THEN 
  SELECT "DOC_REFERENCES_SEQ".nextval INTO :NEW."ID" FROM sys.dual; 
END IF; 
:new.curr         := utl_swift.extract_currency(:new.text_data); 
:new.time_stamp   := utl_swift.extract_datetime(:new.text_data); 
:new.message_type := utl_swift.extract_message_type(:new.text_data); 
:new.io_mode      := utl_swift.extract_io_mode(:new.text_data); 
:new.tdate := nvl( to_date(:new.time_stamp,'YYMMDDHH24MI'),sysdate); 
END; 

/
ALTER TRIGGER "BI_DOC_REFERENCES" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_MESSAGE_TYPE" 
  before insert on "MESSAGE_TYPE"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "MESSAGE_TYPE_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_MESSAGE_TYPE" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_ROLES" 
  before insert on "ROLES"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "ROLES_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_ROLES" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_SERVICES" 
  before insert on "SERVICES"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SERVICES_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_SERVICES" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_SWIFT_DOCUMENT" 
  before insert on "SWIFT_DOCUMENT"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SWIFT_DOCUMENT_SEQ".nextval into :NEW."ID" from sys.dual;  
      end if; 
end; 
 
 
 
 

/
ALTER TRIGGER "BI_SWIFT_DOCUMENT" ENABLE;
  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SWIFT_DOCUMENT_AI" 
AFTER 
insert on "SWIFT_DOCUMENT" 
for each row  
declare 
p_tokens apex_t_varchar2; 
p_text clob; 
p_doc_id number; 
p_ref varchar2(500); 
begin 
 p_tokens := apex_string.split(:new.source_file,'$'); 
 for i in 1..p_tokens.count loop 
 p_text := p_tokens(i); 
 -- dbms_output.put_line(p_text); 
 p_ref := utl_swift.extract_reference(p_text); 
 --  thi sis the issue , we need to get the reference into the doc_refernces table 
 insert into doc_references(doc_id,refno,text_data) values (:new.id,p_ref,p_text); 
 end loop; 
 exception  
 when others then null; 
end; 
 
 
 

/
ALTER TRIGGER "SWIFT_DOCUMENT_AI" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_SWIFT_FIELD" 
  before insert on "SWIFT_FIELD"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "SWIFT_FIELD_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_SWIFT_FIELD" ENABLE;

  CREATE OR REPLACE EDITIONABLE TRIGGER "BI_USERS" 
  before insert on "USERS"                   
  for each row      
begin       
  if :NEW."ID" is null then     
    select "USERS_SEQ".nextval into :NEW."ID" from sys.dual;     
  end if;     
end;     
    
   
  
 

/
ALTER TRIGGER "BI_USERS" ENABLE;




















create or replace PACKAGE BODY  "API" AS  
  
FUNCTION validate_user (   
    p_username   IN VARCHAR2,   
    p_password   IN VARCHAR2   
) RETURN VARCHAR2   
    AS   
BEGIN   
    IF   
        auth.login(p_username,p_password)   
    THEN   
        RETURN 'Valid';        END IF;   
    RETURN 'Invalid';    
END validate_user;   

function get_export_url(p_base_url in varchar2,p_from in varchar2,p_to varchar2,
 p_msg_type in varchar2, p_curr in varchar2,p_io_mode in varchar2) return varchar2 as 
 begin 
 return p_base_url||'?msg_type='
    ||p_msg_type||'&curr='||p_curr||'&io_mode='||p_io_mode||'&from='
    ||to_char(to_date(p_from,'DD-MON-YYYY'),'yyyy-mm-dd')
    ||'&to='||to_char(to_date(p_to,'DD-MON-YYYY'),'yyyy-mm-dd');
 end;
  
END api;
/
create or replace PACKAGE BODY  "AUTH" IS      
  
 procedure reset_password_with_token(p_token in varchar2,  
                                    p_password in varchar2) as   
   p_user users%rowtype;  
   begin  
   update users set passwd=helpers.hash(p_password), password_reset_token = null  
   where password_reset_token = p_token;  
     
   end;  
      
   FUNCTION has_role (    
        p_user   IN VARCHAR2,    
        p_role   IN VARCHAR2    
    ) RETURN BOOLEAN AS    
    
        p_user_roles   users.roles%TYPE;    
        role_id        varchar2(100);    
        arr1           apex_application_global.vc_arr2;    
        p_cnt          NUMBER := 0;    
        l_list         parse.items_tt;    
        found          BOOLEAN := false;    
    BEGIN    
        SELECT    
            name    
        INTO    
            role_id    
        FROM    
            roles    
        WHERE    
            lower(name) = lower(p_role);    
    
        SELECT    
            roles    
        INTO    
            p_user_roles    
        FROM    
            users    
        WHERE    
            lower(username) = lower(p_user);    
    
        l_list := parse.string_to_list(p_user_roles,':');    
        FOR indx IN 1..l_list.count LOOP    
        -- DBMS_OUTPUT.put_line ('> ' || indx || ' = ' || l_list (indx));    
            IF    
                l_list(indx) = TO_CHAR(role_id)    
            THEN    
                return true;    
            END IF;    
        END LOOP;    
        /*    
        return(regexp_like(p_user_roles,role_id    
        || ':') OR regexp_like(':'    
        || p_user_roles,role_id) OR trim(p_user_roles) = role_id);    
        */    
    
        RETURN false;    
    EXCEPTION    
        WHEN OTHERS THEN    
            RETURN false;    
    END has_role;    
    PROCEDURE change_password (      
        p_username      IN VARCHAR2,      
        p_password   IN VARCHAR2      
    )      
        AS      
    BEGIN      
        UPDATE users     
            SET      
                passwd = helpers.hash(p_password)      
        WHERE      
            lower(username) = lower(p_username);      
    END change_password;      
      
    FUNCTION mobile_exists (      
        p_mobile IN VARCHAR2      
    ) RETURN BOOLEAN AS      
        cnt   NUMBER := 0;      
    BEGIN      
        SELECT      
            1      
        INTO      
            cnt      
        FROM      
            users     
        WHERE      
            mobile = p_mobile;      
      
       return cnt >= 1;    
    EXCEPTION      
        WHEN no_data_found THEN      
            RETURN false;      
    END;      
      
    FUNCTION username_exists (      
        p_username IN VARCHAR2      
    ) RETURN BOOLEAN AS      
        cnt   NUMBER := 0;      
    BEGIN      
        SELECT      
            1      
        INTO      
            cnt      
        FROM      
            users     
        WHERE      
            lower(username) = lower(TRIM(p_username) );      
      
        return cnt = 1;    
    EXCEPTION      
        WHEN no_data_found THEN      
            RETURN false;      
    END;      
      
    FUNCTION user_currency (      
        p_username IN VARCHAR2      
    ) RETURN VARCHAR2 AS      
        retval   VARCHAR2(3);      
    BEGIN     
    /*    
        SELECT      
            curr_symbol      
        INTO      
            retval      
        FROM      
            users     
        WHERE      
            lower(username) = lower(p_username);      
  */    
        RETURN retval;      
    END;      
      
    FUNCTION user_id (      
        p_username IN VARCHAR2      
    ) RETURN NUMBER      
        AS      
    BEGIN      
    --RETURN app.get_id('users','username',p_username);      
    return null;      
    END;      
      
    FUNCTION get_admin_id RETURN NUMBER      
        AS      
    BEGIN      
        RETURN 1;      
    END;      
      
    PROCEDURE reset_password (      
        p_username   IN VARCHAR2,      
        p_passwd     IN VARCHAR2 DEFAULT NULL      
    ) AS      
        l_body   CLOB;      
        p_user   users%rowtype;      
        json_string     CLOB;      
        p_result        VARCHAR2(4000);      
        result_values   apex_json.t_values;      
    BEGIN      
        UPDATE users     
            SET      
                passwd = helpers.hash(p_passwd)      
        WHERE      
            lower(username) = lower(p_username);      
      
        -- COMMIT;      
        /*    
        SELECT      
            *      
        INTO      
            p_user      
        FROM      
            users     
        WHERE      
            lower(username) = lower(p_username);      
            apex_json.initialize_clob_output;      
            apex_json.open_object;      
            apex_json.write('to',lower(p_username) );      
            apex_json.write('pwd',p_passwd);              
            apex_json.close_object;      
            json_string := apex_json.get_clob_output;      
            apex_json.free_output;     
            apex_web_service.g_request_headers (1).name := 'Content-Type';     
            apex_web_service.g_request_headers(1).value := 'application/json';         
            p_result   := apex_web_service.make_rest_request(     
            p_url           => 'http://notification.novajii.com/web/smsgw/bulk/reset-password',     
            p_http_method   => 'POST',     
            p_body          => json_string);     
            --helpers.http_raw_post('http://notification.novajii.com/web/smsgw/bulk/reset-password',json_string,p_result);      
            apex_json.parse(p_values => result_values,p_source => p_result);      
          */    
    END;      
      
    FUNCTION verify_user (      
        p_username               IN VARCHAR2 DEFAULT NULL,      
        p_verification_code   IN VARCHAR2      
    ) RETURN BOOLEAN AS      
        l_cnt   NUMBER;      
    BEGIN      
    /*    
        SELECT      
            COUNT(*)      
        INTO      
            l_cnt      
        FROM      
            users     
        WHERE      
            upper(username) = upper(p_username)      
            AND   verification_code = p_verification_code;      
      
        IF      
            l_cnt >= 1      
        THEN      
            RETURN true;      
        ELSE      
            RETURN false;      
        END IF;     
        */    
        null;    
    EXCEPTION      
        WHEN no_data_found THEN      
            RETURN false;      
    END;      
      
    PROCEDURE create_user (      
        p_username       IN VARCHAR2 DEFAULT NULL,      
        p_mobile      IN VARCHAR2 DEFAULT NULL,      
        p_fname       IN VARCHAR2 DEFAULT NULL,      
        p_lname       IN VARCHAR2 DEFAULT NULL,      
        p_passwd      IN VARCHAR2 DEFAULT NULL,      
        p_loc_id      IN NUMBER DEFAULT NULL,      
        p_parent_id   IN NUMBER DEFAULT 1      
    ) AS      
      
        --v_loc                 app_loc%rowtype;      
        -- v_role_id             NUMBER := app.get_id('roles','name','user');      
        v_verification_code   NUMBER := helpers.random_number;      
        l_body                CLOB;      
   -- v_owner number := auth.get_admin_id ;      
    BEGIN      
             
      
        INSERT INTO users(      
            username,      
            passwd,      
            mobile,      
            fname,      
            lname,    
            created_by,  
            password_reset_token  
        ) VALUES (      
            p_username,      
            helpers.hash(p_passwd),      
            p_mobile,      
            p_fname,      
            p_lname,    
            p_parent_id,  
            helpers.generate_alphanum||'$'||helpers.unix_time  
        );      
           
   -- send a username with access details   
     
   -- send verification code by sms      
    END;      
      
    FUNCTION login (      
        p_username   IN VARCHAR2,      
        p_password   IN VARCHAR2      
    ) RETURN BOOLEAN AS      
        l_cnt   NUMBER;      
    BEGIN      
        SELECT      
            COUNT(*)      
        INTO      
            l_cnt      
        FROM      
            users     
        WHERE      
            upper(username) = upper(p_username)      
            AND   passwd = helpers.hash(p_password);     
        return l_cnt >= 1;    
        /*    
        IF      
            l_cnt >= 1      
        THEN      
            RETURN true;      
        ELSE      
            RETURN false;      
        END IF;      
        */    
    EXCEPTION      
        WHEN no_data_found THEN      
            RETURN false;      
    END;      
      
    FUNCTION get_role (      
        p_id IN NUMBER      
    ) RETURN VARCHAR2 AS      
        retval   VARCHAR2(20) := 'user';      
    BEGIN      
        SELECT      
            name      
        INTO      
            retval      
        FROM      
            roles      
        WHERE      
            id = p_id;      
      
        RETURN lower(retval);      
    EXCEPTION      
        WHEN no_data_found THEN      
            RETURN retval;      
    END;      
      
    FUNCTION user_role (      
        p_username IN VARCHAR2      
    ) RETURN VARCHAR2 AS      
        retval   VARCHAR2(20);      
    BEGIN      
        /*    
        SELECT      
            lower(name)      
        INTO      
            retval      
        FROM      
            roles      
        WHERE      
            id = (      
                SELECT      
                    role_id      
                FROM      
                    users     
                WHERE      
                    lower(username) = lower(p_username)      
            );      
        */    
        RETURN retval;      
    EXCEPTION      
        WHEN no_data_found THEN      
            RETURN retval;      
    END;      
      
    FUNCTION validate_username (      
        p_username IN VARCHAR2      
    ) RETURN VARCHAR2      
        AS      
    BEGIN      
        IF      
            p_username IS NULL      
        THEN      
            RETURN 'Username cannot be empty';      
        ELSIF NOT username_exists(p_username) THEN      
            RETURN 'Username not found';      
        ELSE      
            return NULL;      
        END IF;      
      
        RETURN NULL;      
    END validate_username;      
      
  function validate_password(p_username in varchar2,p_password in varchar2) return varchar2 as      
  begin      
    IF      
            p_password IS NULL      
        THEN      
            RETURN 'Password cannot be empty';      
        ELSIF NOT login(p_username,p_password) THEN      
            RETURN 'Wrong password';      
        ELSE      
            return NULL;      
        END IF;      
    return null;      
  end validate_password;      
      
END "AUTH";
/
create or replace package body "EMAIL_CONFIG" as 
 
procedure Mail_config( 
    p_message varchar2 default null, 
    p_to varchar2 default null 
) 
 
AS  
p_payload  VARCHAR2(4000); 
jo  json_object_t; 
p_body  varchar2(4000); 
 
BEGIN 
    SELECT 
        JSON_OBJECT ('message' VALUE p_message,'to' VALUE p_to 
        ) INTO p_body FROM dual; 
        apex_web_service.g_request_headers(1).name := 'Content-Type'; 
        apex_web_service.g_request_headers(1).value := 'application/json'; 
        p_payload := apex_web_service.make_rest_request(p_url => p_mail_api, p_http_method => 'POST', p_body => p_body); 
        dbms_output.put_line(p_payload); 
        --jo := json_object_t.parse(p_payload); 
    END; 
 
END EMAIL_CONFIG;
/
create or replace PACKAGE BODY  "HELPERS" IS      
 


function http_get(
    l_url varchar2
) 
return clob
as 
	l_clob 	CLOB;
BEGIN
	--apex_web_service.g_request_headers(1).name := 'x-rapidapi-key';
	--apex_web_service.g_request_headers(1).value := ''; 
	l_clob := apex_web_service.make_rest_request(
		p_url => l_url,
		p_http_method => 'GET');
  return l_clob;
 end;

 function http_get_json(
    l_url varchar2
) 
return json as
mle module http_request
signature 'httpGet(string)';

function CLOB_TO_BLOB (p_clob CLOB) return BLOB 
as 
 l_blob          blob; 
 l_dest_offset   integer := 1; 
 l_source_offset integer := 1; 
 l_lang_context  integer := DBMS_LOB.DEFAULT_LANG_CTX; 
 l_warning       integer := DBMS_LOB.WARN_INCONVERTIBLE_CHAR; 
BEGIN 
 
  DBMS_LOB.CREATETEMPORARY(l_blob, TRUE); 
  DBMS_LOB.CONVERTTOBLOB 
  ( 
   dest_lob    =>l_blob, 
   src_clob    =>p_clob, 
   amount      =>DBMS_LOB.LOBMAXSIZE, 
   dest_offset =>l_dest_offset, 
   src_offset  =>l_source_offset, 
   blob_csid   =>DBMS_LOB.DEFAULT_CSID, 
   lang_context=>l_lang_context, 
   warning     =>l_warning 
  ); 
  return l_blob; 
END; 
  
function is_number (p_string IN VARCHAR2)  
  RETURN int  
IS  
  v_num NUMBER;  
BEGIN  
  v_num := TO_NUMBER(p_string);  
  RETURN 1;  
EXCEPTION  
WHEN VALUE_ERROR THEN  
  RETURN 0;  
END is_number;  
    
function string_between(p_str in CLOB,p_start in varchar,p_end in varchar)     
return varchar2 as     
ret varchar2(4000);    
pos1 number;    
pos2 number;    
len number;    
begin     
pos1 := instr(p_str,p_start);    
pos2 := instr(p_str,p_end,pos1);    
len := (pos2 - (pos1 +length(p_start)));    
return substr(p_str,pos1+length(p_start),len);    
    
return ret;    
end;    
     
        
    PROCEDURE flash (     
        p_message   IN VARCHAR2,     
        p_type      IN VARCHAR2 DEFAULT 'Success'     
    )     
        AS     
    BEGIN     
        IF     
            upper(p_type) = 'SUCCESS'     
        THEN     
            apex_util.set_session_state('G_SUCCESS_MESSAGE',p_message);     
        ELSE     
            apex_util.set_session_state('G_LOGIN_MESSAGE',p_message);     
        END IF;     
    END;     
     
    PROCEDURE http_raw_post (     
        p_endpoint   IN VARCHAR2,     
        p_body       IN VARCHAR2,     
        p_result IN OUT VARCHAR2,     
        p_type       IN VARCHAR2 DEFAULT 'text/plain'     
    ) AS     
        req        utl_http.req;     
        res        utl_http.resp;     
        p_buffer   VARCHAR2(32000);     
    BEGIN     
        -- dbms_output.put_line(p_body);     
        req := utl_http.begin_request(p_endpoint,'POST','HTTP/1.1');     
        /*     
        dbms_output.put_line('URL: '     
        || p_endpoint);     
        dbms_output.put_line('Request body: '     
        || p_body);     
        */     
      -- utl_http.set_header(req, 'user-agent', 'mozilla/4.0');     
        IF     
            p_body IS NOT NULL     
        THEN     
            utl_http.set_header(req,'content-type',p_type);     
            utl_http.set_header(req,'Content-Length',length(p_body) );     
            utl_http.write_text(req,p_body);     
        END IF;     
     
        res := utl_http.get_response(req);     
      -- process the response from the HTTP call     
        BEGIN     
            LOOP     
                utl_http.read_line(res,p_buffer);     
                p_result := p_buffer;     
                /*dbms_output.put_line('Response: '     
                || p_buffer);     
                */     
            END LOOP;     
     
                 
            utl_http.end_response(res);     
        EXCEPTION     
            WHEN utl_http.end_of_body THEN     
                utl_http.end_response(res);     
        END;     
     
    END http_raw_post;     
     
    FUNCTION urldecode (     
        p_string IN VARCHAR2     
    ) RETURN VARCHAR2     
        IS     
    BEGIN     
        RETURN replace(utl_url.unescape(p_string),'+',' ');     
    END;     
     
    FUNCTION md5 (     
        str IN VARCHAR2     
    ) RETURN VARCHAR2 IS     
        v_checksum   VARCHAR2(32);     
    BEGIN     
        -- v_checksum := lower(rawtohex(utl_raw.cast_to_raw(sys.dbms_obfuscation_toolkit.md5(input_string => str) ) ) );     
        select standard_hash(str,'MD5') into v_checksum from dual;
        RETURN v_checksum;     
    EXCEPTION     
        WHEN no_data_found THEN     
            NULL;     
        WHEN OTHERS THEN     
			-- Consider logging the error and then re-raise     
            RAISE;     
    END md5;     
     
    FUNCTION blob_to_clob (     
        blob_in IN BLOB     
    ) RETURN CLOB AS     
     
        v_clob      CLOB;     
        v_varchar   VARCHAR2(32767);     
        v_start     PLS_INTEGER := 1;     
        v_buffer    PLS_INTEGER := 32767;     
    BEGIN     
        dbms_lob.createtemporary(v_clob,true);     
        FOR i IN 1..ceil(dbms_lob.getlength(blob_in) / v_buffer) LOOP     
            v_varchar := utl_raw.cast_to_varchar2(dbms_lob.substr(blob_in,v_buffer,v_start) );     
     
            dbms_lob.writeappend(v_clob,length(v_varchar),v_varchar);     
            v_start := v_start + v_buffer;     
        END LOOP;     
     
        RETURN v_clob;     
    END blob_to_clob;     
     
    FUNCTION str_replace (     
        p_in       IN CLOB,     
        p_search   IN VARCHAR2 DEFAULT ':',     
        p_with     IN VARCHAR2 DEFAULT ','     
    ) RETURN CLOB     
        IS     
    BEGIN     
        RETURN replace(p_in,p_search,p_with);     
    END;     
     
    FUNCTION unix_time RETURN VARCHAR2 AS     
        retval   VARCHAR(100);     
    BEGIN     
        SELECT     
            ( SYSDATE - TO_DATE('01-01-1970 00:00:00','DD-MM-YYYY HH24:MI:SS') ) * 24 * 60 * 60     
        INTO     
            retval     
        FROM     
            dual;     
     
        RETURN trunc(retval);     
    END;     
     
    FUNCTION hash (     
        str IN VARCHAR2     
    ) RETURN VARCHAR2 AS     
        l_hash   VARCHAR2(4000);     
        l_salt   VARCHAR2(4000) := 'LWFPTNDZEY32425#_9204FK6QW0AJRJHQFLYP123443531@HHJJG';     
    BEGIN     
       /* l_hash := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => substr(l_salt,9,13)     
        || str     
        || substr(l_salt,5,10) ) );   
        */
        select standard_hash(str,'MD5') into l_hash from dual;  
     
        RETURN l_hash;     
    END;     
     
    FUNCTION url_encode (     
        p_data                    IN VARCHAR2,     
        p_escape_reserved_chars   IN BOOLEAN DEFAULT true     
    ) RETURN VARCHAR2     
        AS     
    BEGIN     
        RETURN utl_url.escape(p_data,p_escape_reserved_chars);     
  -- note use of TRUE, for proper delivery set to true to handle reserved chars like & ^     
    END;     
     
    FUNCTION random_string (     
        len IN NUMBER DEFAULT 5     
    ) RETURN VARCHAR2     
        AS     
    BEGIN     
        RETURN lower(dbms_random.string('b',2) )     
        || upper(dbms_random.string('b',len - 2) );     
    END random_string;     
     
    FUNCTION random_number (     
        p_start   IN NUMBER DEFAULT 100000,     
        p_end     IN NUMBER DEFAULT 999999     
    ) RETURN VARCHAR2     
        AS     
    BEGIN     
        RETURN trunc(dbms_random.value(p_start,p_end) );     
    END;     
     
    FUNCTION generate_alphanum RETURN VARCHAR2     
        AS     
    BEGIN     
        RETURN random_string     
        || random_number;     
    END;     
     
    FUNCTION call_url (     
        url IN VARCHAR2     
    ) RETURN CLOB AS     
     
        req         utl_http.req;     
        resp        utl_http.resp;     
        name        VARCHAR2(4000);     
        val         VARCHAR2(32767);     
  --value clob;     
        data        VARCHAR2(4000);     
        retval      VARCHAR2(32676);     
        my_scheme   VARCHAR2(4000);     
        my_realm    VARCHAR2(4000);     
        my_proxy    BOOLEAN;     
        v_text      CLOB;     
    BEGIN     
  -- When going through a firewall, pass requests through this host.     
  -- Specify sites inside the firewall that don't need the proxy host.     
  --utl_http.set_proxy('proxy.my-company.com', 'corp.my-company.com');     
  -- Ask UTL_HTTP not to raise an exception for 4xx and 5xx status codes,     
  -- rather than just returning the text of the error page.     
        utl_http.set_response_error_check(false);     
  -- Begin retrieving this Web page.     
        req := utl_http.begin_request(url);     
  -- Identify ourselves. Some sites serve special pages for particular browsers.     
  --utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');     
        BEGIN     
    -- Start receiving the HTML text.     
            resp := utl_http.get_response(req);     
    -- Show the status codes and reason phrase of the response.     
    --dbms_output.put_line('HTTP response status code: ' || resp.status_code);     
    --dbms_output.put_line('HTTP response reason phrase: ' || resp.reason_phrase);     
    -- Look for client-side error and report it.     
            IF     
                ( resp.status_code >= 400 ) AND ( resp.status_code <= 499 )     
            THEN     
     
      --dbms_output.put_line('Check the URL.');     
                utl_http.end_response(resp);     
                RETURN v_text;     
      -- Look for server-side error and report it.     
            ELSIF ( resp.status_code >= 500 ) AND ( resp.status_code <= 599 ) THEN     
      --dbms_output.put_line('Check if the Web site is up.');     
                utl_http.end_response(resp);     
                RETURN v_text;     
            END IF;     
    -- Keep reading lines until no more are left and an exception is raised.     
     
            LOOP     
                utl_http.read_line(resp,val);     
                v_text := v_text     
                || val;     
      --dbms_output.put_line(value);     
            END LOOP;     
     
        EXCEPTION     
            WHEN utl_http.end_of_body THEN     
                utl_http.end_response(resp);     
                RETURN v_text;     
        END;     
     
        RETURN v_text;     
    END;     
     
END "HELPERS";
/
create or replace PACKAGE BODY  "PARSE"   
IS     
  /* count all the ocurrences of special characters and lets knw what size we shld split text into */     
FUNCTION get_split_for_special_chars(     
    p_text    IN VARCHAR2,     
    p_pattern IN VARCHAR2)     
  RETURN NUMBER     
AS     
  retval NUMBER := 0;     
  l_list parse.items_tt;     
BEGIN     
  l_list   := parse.string_to_list(trim(p_pattern),',');     
  FOR indx IN 1 .. l_list.COUNT     
  LOOP     
  retval := retval + regexp_count(trim(p_text), l_list (indx));     
  END LOOP;     
  RETURN retval;     
END;     
FUNCTION convert_to_date(     
    p_str IN VARCHAR2)     
  RETURN DATE     
AS     
BEGIN     
  RETURN to_date(p_str);     
END;     
FUNCTION handle_quotes(     
    p_string IN VARCHAR2)     
  RETURN VARCHAR2     
AS     
BEGIN     
  RETURN q'{p_string}';     
END;     
FUNCTION slice_string(     
    pText IN VARCHAR2,     
    p_max IN NUMBER)     
  RETURN typStringTab     
IS     
  -- iMaxLength INTEGER := 160;     
  iMaxLength NUMBER;     
  tStringTab typStringTab;     
  iLength INTEGER;     
  vText   VARCHAR2(160);     
  iIndex  INTEGER;     
  iPos    INTEGER;     
BEGIN     
  iMaxLength  := p_max;     
  iLength     := LENGTH(pText);     
  IF (iLength <= iMaxLength) THEN     
    -- The string can be returned as-is     
    tStringTab(1) := pText;     
  ELSE     
    -- The string needs to be sliced into chunks of lengths of iMaxLength     
    -- Each chunk will be inserted as a row in a PL/SQL Collection     
    iPos   := 1;     
    iIndex := 0;     
    -- Loop until we have chunked the whole string     
    WHILE iPos <= iLength     
    LOOP     
      iIndex             := iIndex + 1;     
      vText              := SUBSTR(pText, iPos, iMaxLength);     
      tStringTab(iIndex) := vText;     
      /* Insert into collection */     
      iPos := iPos + iMaxLength;     
    END LOOP;     
  END IF;     
  RETURN tStringTab;     
END slice_string;     
FUNCTION string_to_list(     
    string_in IN VARCHAR2,     
    delim_in  IN VARCHAR2)     
  RETURN items_tt     
IS     
  c_end_of_list CONSTANT PLS_INTEGER := -99;     
  l_item maxvarchar2_t;     
  l_startloc PLS_INTEGER := 1;     
  items_out items_tt;     
PROCEDURE add_item(     
    item_in IN VARCHAR2)     
IS     
BEGIN     
  IF item_in = delim_in THEN     
    /* We dont put delimiters into the collection. */     
    NULL;     
  ELSE     
    items_out (items_out.COUNT + 1) := item_in;     
  END IF;     
END;     
PROCEDURE get_next_item(     
    string_in         IN VARCHAR2 ,     
    start_location_io IN OUT PLS_INTEGER ,     
    item_out OUT VARCHAR2 )     
IS     
  l_loc PLS_INTEGER;     
BEGIN     
  l_loc   := INSTR (string_in, delim_in, start_location_io);     
  IF l_loc = start_location_io THEN     
    /* A null item (two consecutive delimiters) */     
    item_out := NULL;     
  ELSIF l_loc = 0 THEN     
    /* We are at the last item in the list. */     
    item_out := SUBSTR (string_in, start_location_io);     
  ELSE     
    /* Extract the element between the two positions. */     
    item_out := SUBSTR (string_in , start_location_io , l_loc - start_location_io );     
  END IF;     
  IF l_loc = 0 THEN     
    /* If the delimiter was not found, send back indication     
    that we are at the end of the list. */     
    start_location_io := c_end_of_list;     
  ELSE     
    /* Move the starting point for the INSTR search forward. */     
    start_location_io := l_loc + 1;     
  END IF;     
END get_next_item;     
BEGIN     
  IF string_in IS NULL OR delim_in IS NULL THEN     
    /* Nothing to do except pass back the empty collection. */     
    NULL;     
  ELSE     
    LOOP     
      get_next_item (string_in, l_startloc, l_item);     
      add_item (l_item);     
      EXIT     
    WHEN l_startloc = c_end_of_list;     
    END LOOP;     
  END IF;     
  RETURN items_out;     
END string_to_list;     
FUNCTION string_to_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 )     
  RETURN nested_items_tt     
IS     
  l_elements items_tt;     
  l_return nested_items_tt;     
BEGIN     
  /* Separate out the different lists. */     
  l_elements := string_to_list (string_in, outer_delim_in);     
  /* For each list, parse out the separate items     
  and add them to the end of the list of items     
  for that list. */     
  FOR indx IN 1 .. l_elements.COUNT     
  LOOP     
    l_return (l_return.COUNT + 1) := string_to_list (l_elements (indx), inner_delim_in);     
  END LOOP;     
  RETURN l_return;     
END string_to_list;     
FUNCTION string_to_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    name_delim_in  IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 )     
  RETURN named_nested_items_tt     
IS     
  c_name_position  constant pls_integer := 1;     
  c_items_position constant pls_integer := 2;     
  l_elements items_tt;     
  l_name_and_values items_tt;     
  l_return named_nested_items_tt;     
BEGIN     
  /* Separate out the different lists. */     
  l_elements := string_to_list (string_in, outer_delim_in);     
  FOR indx   IN 1 .. l_elements.COUNT     
  LOOP     
    /* Extract the name and the list of items that go with     
    the name. This collection always has just two elements:     
    index 1 - the name     
    index 2 - the list of values     
    */     
    l_name_and_values := string_to_list (l_elements (indx), name_delim_in);     
    /*     
    Use the name as the index value for this list.     
    */     
    l_return (l_name_and_values (c_name_position)) := string_to_list (l_name_and_values (c_items_position), inner_delim_in);     
  END LOOP;     
  RETURN l_return;     
END string_to_list;     
PROCEDURE display_list(     
    string_in IN VARCHAR2 ,     
    delim_in  IN VARCHAR2:= ',' )     
IS     
  l_items items_tt;     
BEGIN     
  DBMS_OUTPUT.put_line ( 'Parse "' || string_in || '" using "' || delim_in || '"' );     
  l_items  := string_to_list (string_in, delim_in);     
  FOR indx IN 1 .. l_items.COUNT     
  LOOP     
    DBMS_OUTPUT.put_line ('> ' || indx || ' = ' || l_items (indx));     
  END LOOP;     
END display_list;     
PROCEDURE display_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 )     
IS     
  l_items nested_items_tt;     
BEGIN     
  DBMS_OUTPUT.put_line( 'Parse "' || string_in || '" using "' || outer_delim_in || '-' || inner_delim_in || '"');     
  l_items         := string_to_list (string_in, outer_delim_in, inner_delim_in);     
  FOR outer_index IN 1 .. l_items.COUNT     
  LOOP     
    DBMS_OUTPUT.put_line( 'List ' || outer_index || ' contains ' || l_items (outer_index).COUNT || ' elements');     
    FOR inner_index IN 1 .. l_items (outer_index).COUNT     
    LOOP     
      DBMS_OUTPUT.put_line( '> Value ' || inner_index || ' = ' || l_items (outer_index) (inner_index));     
    END LOOP;     
  END LOOP;     
END display_list;     
PROCEDURE display_list(     
    string_in      IN VARCHAR2 ,     
    outer_delim_in IN VARCHAR2 ,     
    name_delim_in  IN VARCHAR2 ,     
    inner_delim_in IN VARCHAR2 )     
IS     
  l_items named_nested_items_tt;     
  l_index maxvarchar2_t;     
BEGIN     
  DBMS_OUTPUT.put_line( 'Parse "' || string_in || '" using "' || outer_delim_in || '-' || name_delim_in || '-' || inner_delim_in || '"');     
  l_items        := string_to_list (string_in , outer_delim_in , name_delim_in , inner_delim_in );     
  l_index        := l_items.FIRST;     
  WHILE (l_index IS NOT NULL)     
  LOOP     
    DBMS_OUTPUT.put_line( 'List "' || l_index || '" contains ' || l_items (l_index).COUNT || ' elements');     
    FOR inner_index IN 1 .. l_items (l_index).COUNT     
    LOOP     
      DBMS_OUTPUT.put_line( '> Value ' || inner_index || ' = ' || l_items (l_index) (inner_index));     
    END LOOP;     
    l_index := l_items.NEXT (l_index);     
  END LOOP;     
END display_list;     
PROCEDURE show_variations     
IS     
PROCEDURE show_header(     
    title_in IN VARCHAR2)     
IS     
BEGIN     
  DBMS_OUTPUT.put_line (RPAD ('=', 60, '='));     
  DBMS_OUTPUT.put_line (title_in);     
  DBMS_OUTPUT.put_line (RPAD ('=', 60, '='));     
END show_header;     
BEGIN     
  show_header ('Single Delimiter Lists');     
  display_list ('a,b,c');     
  display_list ('a;b;c', ';');     
  display_list ('a,,b,c');     
  display_list (',,b,c,,');     
  show_header ('Nested Lists');     
  display_list ('a,b,c,d|1,2,3|x,y,z', '|', ',');     
  show_header ('Named, Nested Lists');     
  display_list ('letters:a,b,c,d|numbers:1,2,3|names:steven,george' , '|' , ':' , ',' );     
END;     
FUNCTION nested_eq(     
    list1_in    IN items_tt ,     
    list2_in    IN items_tt ,     
    nulls_eq_in IN BOOLEAN )     
  RETURN BOOLEAN     
IS     
  l_return BOOLEAN    := list1_in.COUNT = list2_in.COUNT;     
  l_index PLS_INTEGER := 1;     
BEGIN     
  WHILE (l_return AND l_index IS NOT NULL)     
  LOOP     
    l_return := list1_in (l_index) = list2_in (l_index);     
    l_index  := list1_in.NEXT (l_index);     
  END LOOP;     
  RETURN l_return;     
EXCEPTION     
WHEN NO_DATA_FOUND THEN     
  RETURN FALSE;     
END nested_eq;     
END;
/
create or replace PACKAGE BODY  "UTL_JSON" is    
  NS_XPATH_FN          constant varchar2(100) := 'http://www.w3.org/2005/xpath-functions';    
  ERR_INVALID_XML_ELT  constant varchar2(100) := 'Invalid element ''%s'' in namespace ''%s''';    
  ERR_DUPLICATE_KEY    constant varchar2(100) := 'Duplicate key ''%s''';    
      
  validation_error  exception;    
  pragma exception_init(validation_error, -20101);    
  type json_item is record (    
    content      json_element_t    
  , key          varchar2(4000)    
  , ordinal      pls_integer    
  , string_val   varchar2(32767)    
  , number_val   number    
  , boolean_val  boolean    
  , type_val     number(2)    
  , parent_item  json_element_t    
  );    
  procedure error (    
    err_num      in number    
  , err_message  in varchar2    
  , arg1         in varchar2 default null    
  , arg2         in varchar2 default null    
  , arg3         in varchar2 default null    
  )    
  is    
  begin    
    raise_application_error(err_num, utl_lms.format_message(err_message, arg1, arg2, arg3));    
  end;    
  function get_child_xml (    
    doc   in dbms_xmldom.DOMDocument    
  , item  in json_item    
  )    
  return dbms_xmldom.DOMNode    
  is    
    node_name   varchar2(4000);    
    node_value  varchar2(32767);    
    node_text   dbms_xmldom.DOMText;    
    node        dbms_xmldom.DOMNode;    
    child_node  dbms_xmldom.DOMNode;    
    element     dbms_xmldom.DOMElement;    
    child_item  json_item;    
    obj         json_object_t;    
    arr         json_array_t;       
    keys        json_key_list;    
        
  begin    
        
    case     
    when item.content.is_Object then    
      element := dbms_xmldom.createElement(doc, 'map', NS_XPATH_FN);    
      if item.key is not null then    
        dbms_xmldom.setAttribute(element, 'key', item.key);    
      end if;    
      node := dbms_xmldom.makeNode(element);    
      obj := treat(item.content as json_object_t);    
      keys := obj.get_keys();    
      for i in 1 .. keys.count loop    
        child_item.content := obj.get(keys(i));    
        child_item.key := keys(i);    
        child_item.parent_item := item.content;    
        child_node := dbms_xmldom.appendChild(node, get_child_xml(doc, child_item));    
      end loop;    
          
    when item.content.is_Array then    
      element := dbms_xmldom.createElement(doc, 'array', NS_XPATH_FN);    
      if item.key is not null then    
        dbms_xmldom.setAttribute(element, 'key', item.key);    
      end if;    
      node := dbms_xmldom.makeNode(element);    
      arr := treat(item.content as json_array_t);    
      for i in 0 .. arr.get_size - 1 loop    
        child_item.content := arr.get(i);    
        child_item.parent_item := item.content;    
        child_node := dbms_xmldom.appendChild(node, get_child_xml(doc, child_item));    
      end loop;    
          
    when item.content.is_Scalar then          
      case     
      when item.parent_item.is_object then    
        obj := treat(item.parent_item as json_object_t);    
        case     
        when item.content.is_string then    
          node_value := obj.get_string(item.key);    
          node_name := 'string';    
        when item.content.is_number then    
          node_value := to_char(obj.get_Number(item.key),'TM9','nls_numeric_characters=.,');    
          node_name := 'number';    
        when item.content.is_boolean then    
          node_value := case when obj.get_boolean(item.key) then 'true' else 'false' end;    
          node_name := 'boolean';    
        else    
          node_name := 'null';    
        end case;    
          
      when item.parent_item.is_array then    
        arr := treat(item.parent_item as json_array_t);    
        case     
        when item.content.is_string then    
          node_value := arr.get_string(item.ordinal);    
          node_name := 'string';    
        when item.content.is_number then    
          node_value := to_char(arr.get_Number(item.ordinal),'TM9','nls_numeric_characters=.,');    
          node_name := 'number';    
        when item.content.is_boolean then    
          node_value := case when arr.get_boolean(item.ordinal) then 'true' else 'false' end;    
          node_name := 'boolean';    
        else    
          node_name := 'null';    
        end case;    
          
      end case;      
          
      element := dbms_xmldom.createElement(doc, node_name, NS_XPATH_FN);    
      if item.key is not null then    
        dbms_xmldom.setAttribute(element, 'key', item.key);    
      end if;    
      node := dbms_xmldom.makeNode(element);    
      if not item.content.is_null then    
        node_text := dbms_xmldom.createTextNode(doc, node_value);    
        child_node := dbms_xmldom.appendChild(node, dbms_xmldom.makeNode(node_text));    
      end if;    
        
    end case;    
        
        
    return node;    
      
  end;    
  function get_child_json (    
    node  in dbms_xmldom.DOMNode    
  )    
  return json_item    
  is    
    node_type  varchar2(30);    
    node_ns    varchar2(2000);    
    node_name  varchar2(4000);    
    attr_list  dbms_xmldom.DOMNamedNodeMap;    
    node_list  dbms_xmldom.DOMNodeList;    
    item       json_item;    
    obj        json_object_t;    
    arr        json_array_t;    
    output     json_item;       
        
  begin    
            
    node_type := dbms_xmldom.getNodeType(node);    
        
    case node_type    
    when dbms_xmldom.ELEMENT_NODE then    
      dbms_xmldom.getLocalName(node, node_name);    
      dbms_xmldom.getNamespace(node, node_ns);    
          
      if node_ns = NS_XPATH_FN then    
          
        attr_list := dbms_xmldom.getAttributes(node);    
        output.key := dbms_xmldom.getNodeValue(dbms_xmldom.getNamedItem(attr_list, 'key'));    
        case node_name    
        when 'map' then    
          node_list := dbms_xmldom.getChildNodes(node);    
          output.content := new json_object_t();    
              
          if not dbms_xmldom.isNull(node_list) then    
            obj := treat(output.content as json_object_t);        
            for i in 0 .. dbms_xmldom.getLength(node_list) - 1 loop              
              item := get_child_json(dbms_xmldom.item(node_list, i));    
              if obj.has(item.key) then    
                error(-20101, ERR_DUPLICATE_KEY, item.key);    
              end if;    
              if item.content is not null then    
                obj.put(item.key, item.content);    
              else    
                case item.type_val    
                when DBMS_JSON.TYPE_STRING then    
                  obj.put(item.key, item.string_val);    
                when DBMS_JSON.TYPE_NUMBER then    
                  obj.put(item.key, item.number_val);    
                when DBMS_JSON.TYPE_BOOLEAN then    
                  obj.put(item.key, item.boolean_val);    
                else    
                  obj.put_null(item.key);    
                end case;    
              end if;           
            end loop;    
            dbms_xmldom.freeNodeList(node_list);    
          end if;    
              
        when 'array' then    
              
          node_list := dbms_xmldom.getChildNodes(node);    
          output.content := new json_array_t();    
              
          if not dbms_xmldom.isNull(node_list) then    
            arr := treat(output.content as json_array_t);    
            for i in 0 .. dbms_xmldom.getLength(node_list) - 1 loop              
              item := get_child_json(dbms_xmldom.item(node_list, i));    
              if item.content is not null then    
                arr.append(item.content);    
              else    
                case item.type_val    
                when DBMS_JSON.TYPE_STRING then    
                  arr.append(item.string_val);    
                when DBMS_JSON.TYPE_NUMBER then    
                  arr.append(item.number_val);    
                when DBMS_JSON.TYPE_BOOLEAN then    
                  arr.append(item.boolean_val);    
                else    
                  arr.append_null();    
                end case;    
              end if;            
            end loop;    
            dbms_xmldom.freeNodeList(node_list);    
          end if;    
              
        when 'string' then    
              
          output.type_val := DBMS_JSON.TYPE_STRING;    
          output.string_val := dbms_xmldom.getNodeValue(dbms_xmldom.getFirstChild(node));    
              
        when 'number' then    
              
          output.type_val := DBMS_JSON.TYPE_NUMBER;    
          output.number_val := to_number(dbms_xmldom.getNodeValue(dbms_xmldom.getFirstChild(node)));    
              
        when 'boolean' then    
              
          output.type_val := DBMS_JSON.TYPE_BOOLEAN;    
          output.boolean_val := ( dbms_xmldom.getNodeValue(dbms_xmldom.getFirstChild(node)) = 'true' );    
              
        when 'null' then    
              
          output.type_val := DBMS_JSON.TYPE_NULL;    
            
        else    
          error(-20101, ERR_INVALID_XML_ELT, node_name, node_ns);    
        end case;    
          
      else    
        error(-20101, ERR_INVALID_XML_ELT, node_name, node_ns);    
      end if;    
          
    else    
      null;    
    end case;    
        
    dbms_xmldom.freeNode(node);    
        
    return output;    
      
  end;    
  function json_to_xml (input in clob)    
  return xmltype    
  is    
    doc     dbms_xmldom.DOMDocument;    
    docnode dbms_xmldom.DOMNode;    
    node    dbms_xmldom.DOMNode;    
    item    json_item;    
    output  xmltype;    
  begin    
    doc := dbms_xmldom.newDOMDocument();    
    docnode := dbms_xmldom.makeNode(doc);    
    item.content := json_element_t.parse(input);    
    node := dbms_xmldom.appendChild(docnode, get_child_xml(doc, item));    
    -- set default namespace declaration on the root element    
    dbms_xmldom.setAttribute(dbms_xmldom.makeElement(node), 'xmlns', NS_XPATH_FN);    
    output := dbms_xmldom.getxmltype(doc);    
    dbms_xmldom.freeDocument(doc);    
    return output;    
  end;    
  function xml_to_json (input in xmltype)    
  return clob    
  is    
    doc     dbms_xmldom.DOMDocument;    
    root    dbms_xmldom.DOMElement;    
    output  json_item;    
  begin    
    doc := dbms_xmldom.newDOMDocument(input);    
    root := dbms_xmldom.getDocumentElement(doc);    
    output := get_child_json(dbms_xmldom.makeNode(root));    
    dbms_xmldom.freeDocument(doc);    
    return output.content.to_clob();    
  exception    
    when validation_error then    
      error(-20100, 'FOJS0006: Invalid XML representation of JSON' || chr(10) || dbms_utility.format_error_stack);    
  end;    
end utl_json;    
/
create or replace PACKAGE BODY "UTL_SWIFT" IS   
-- since Oracle 12edi+ we have to use editions when compiling, so use create or replace editionable package... 
    FUNCTION extract_message_type ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(20); 
    BEGIN    
-- tag 32A :32A:200603NGN20000000,00  sometimes has date, but we need to add HHMI   
        ret := substr(helpers.string_between(p_text, '{2:', '}'), 2, 3); 
 
        RETURN ret; 
        IF ( 
            length(ret) = 10 
            AND helpers.is_number(ret) = 1 
        ) THEN 
            RETURN trim(ret || '0000'); 
        END IF; 
 
        RETURN NULL; 
    EXCEPTION 
        WHEN OTHERS THEN 
            RETURN NULL; 
    END; 
 
    FUNCTION extract_io_mode ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(20); 
    BEGIN    
-- tag 32A :32A:200603NGN20000000,00  sometimes has date, but we need to add HHMI   
        ret := substr(helpers.string_between(p_text, '{2:', '}'), 1, 1); 
 
        RETURN ret; 
        IF ( 
            length(ret) = 10 
            AND helpers.is_number(ret) = 1 
        ) THEN 
            RETURN trim(ret || '0000'); 
        END IF; 
 
        RETURN NULL; 
    EXCEPTION 
        WHEN OTHERS THEN 
            RETURN NULL; 
    END; 
 
    FUNCTION remove_space_from_numbers ( 
        p_clob CLOB 
    ) RETURN CLOB AS 
    BEGIN 
/*return replace 
       ( 
          regexp_replace 
          ( 
             regexp_replace 
             ( 
                 replace(REPLACE(p_clob,chr(10),' '),chr(13),' ') 
                , ' ([[:alpha:]])' 
                , '#\1' 
             ) 
             , '([[:digit:]|\.|\-])[[:space:]]*' 
             , '\1' 
          ) 
          , '#' 
          , ' ' 
       ); 
  */ 
        RETURN replace(replace(p_clob, chr(10), '|'), chr(13), '|'); 
    END; 
 
    FUNCTION extract_text2 ( 
        p_reference IN VARCHAR2, 
        p_source    IN CLOB 
    ) RETURN VARCHAR2 AS 
        p_data VARCHAR2(4000); 
    BEGIN  
  /*return p_reference ||' '|| helpers.string_between(p_source, 
p_reference,'-}')||'-}'; 
*/ 
        SELECT 
            text_data 
        INTO p_data 
        FROM 
            doc_references 
        WHERE 
            refno = p_reference; 
 
        RETURN p_data; 
    EXCEPTION 
        WHEN OTHERS THEN 
            RETURN p_reference 
                   || ' ' 
                   || helpers.string_between(p_source, p_reference, '-}') 
                   || '-}'; 
    END; 
 
    FUNCTION extract_customer_account ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
 
        ret      VARCHAR2(4000) := NULL; 
        p_tokens apex_t_varchar2; 
        p_end    VARCHAR2(20) := ':7'; 
        patterns VARCHAR2(1000) := '59:,59A:,59F:'; 
        p_starts apex_t_varchar2; 
        p_item   VARCHAR2(100); 
        p_result VARCHAR2(200); 
    BEGIN    
-- get tag 50H,L,A or K   
        FOR t IN ( 
            SELECT 
                upper(tag) tag 
            FROM 
                swift_field 
            WHERE 
                upper(tag) IN ( '50A', '50H', '50K', '50L' ) 
            ORDER BY 
                tag 
        ) LOOP 
            ret := utl_swift.get_tag_value(remove_space_from_numbers(p_text), t.tag); 
            IF ( 
                ret IS NOT NULL 
                AND length(ret) >= 1 
            ) THEN 
                p_tokens := apex_string.split(ret, '|'); 
                -- RETURN trim(ret);  
                --return replace(p_tokens(1),'/'); 
                --p_tokens := apex_string.split(p_data,' '); 
                p_result := replace(p_tokens(1), '/'); 
                RETURN p_result; 
               -- return regexp_replace(p_result,'[^0-9]+',''); 
            END IF; 
 
        END LOOP;   
-- should be 10 digits and numeric   
 
        RETURN ret; 
    END; 
 
    FUNCTION extract_customer ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(4000) := NULL; 
    BEGIN    
-- get tag 50H,L,A or K   
        FOR t IN ( 
            SELECT 
                upper(tag) tag 
            FROM 
                swift_field 
            WHERE 
                upper(tag) IN ( '50A', '50H', '50K', '50L' ) 
            ORDER BY 
                tag 
        ) LOOP 
            ret := utl_swift.get_tag_value(p_text, t.tag); 
            IF ( 
                ret IS NOT NULL 
                AND length(ret) >= 1 
            ) THEN 
                RETURN trim(replace(ret, '/')); 
            END IF; 
 
        END LOOP;   
-- should be 10 digits and numeric   
 
        RETURN ret; 
    END; 
 
    FUNCTION get_sender_country ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(4000) := NULL; 
    BEGIN    
-- get tag 50H,L,A or K   
        FOR t IN ( 
            SELECT 
                upper(tag) tag 
            FROM 
                swift_field 
            WHERE 
                upper(tag) IN ( '50A', '50H', '50K', '50L' ) 
            ORDER BY 
                tag 
        ) LOOP 
            ret := utl_swift.get_tag_value(p_text, t.tag); 
            IF ( 
                ret IS NOT NULL 
                AND length(ret) >= 1 
            ) THEN 
                RETURN trim(replace(last_words(ret), '/', ' ')); 
            END IF; 
 
        END LOOP;   
-- should be 10 digits and numeric   
 
        RETURN last_words(ret); 
    END; 
 
    FUNCTION extract_transaction_amount ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(4000) := NULL; 
    BEGIN    
-- get tag 177    
        ret := utl_swift.get_tag_value(p_text, '32B');    
-- should be 10 digits and numeric    
        IF ( length(ret) > 1 ) THEN 
            RETURN trim(ret); 
        END IF; 
 
        ret := substr(utl_swift.get_tag_value(p_text, '32A'), 7); 
        IF ( length(ret) > 1 ) THEN 
            RETURN trim(ret); 
        END IF; 
 
        RETURN ret; 
    END; 
 
    FUNCTION extract_account_institution ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(4000) := NULL; 
    BEGIN 
        ret := utl_swift.get_tag_value(p_text, '57D');    
-- should be 10 digits and numeric    
        IF ( length(ret) > 0 ) THEN 
            RETURN trim(ret); 
        END IF; 
 
        ret := utl_swift.get_tag_value(p_text, '57A');    
-- should be 10 digits and numeric    
        IF ( length(ret) > 0 ) THEN 
            RETURN trim(ret); 
        END IF; 
 
        RETURN ret; 
    END; 
 
    FUNCTION extract_remittance_information ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(4000) := NULL; 
    BEGIN 
        RETURN replace(helpers.string_between(p_text, '70:', ':7'), '/'); 
     /* 
        ret := utl_swift.get_tag_value(p_text, '70'); 
        -- should be 10 digits and numeric    
        IF ( length(ret) > 0 ) THEN  
            RETURN trim(ret);  
        END IF;  
        ret := utl_swift.get_tag_value(p_text, '71');  
        --should be 10 digits and numeric    
        IF ( length(ret) > 0 ) THEN  
            RETURN trim(ret);  
        END IF; 
 
        ret := utl_swift.get_tag_value(p_text, '72A');  
        --should be 10 digits and numeric    
        IF ( length(ret) > 0 ) THEN  
            RETURN trim(ret);  
        END IF;   
  
        RETURN ret;  
        */ 
    END; 
 
    FUNCTION extract_beneficiary ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(4000) := NULL; 
    BEGIN    
-- get tag 177   
        --ret := utl_swift.get_tag_value(p_text, '59');   
        ret := trim(helpers.string_between(p_text, '59:', ':7')); 
-- should be 10 digits and numeric   
        IF ( length(ret) > 1 ) THEN 
            RETURN replace(trim(ret), '/'); 
        END IF; 
 
        ret := trim(helpers.string_between(p_text, '59A:', ':7')); 
        -- ret := utl_swift.get_tag_value(p_text, '59A');   
-- should be 10 digits and numeric   
        IF ( length(ret) > 1 ) THEN 
            RETURN replace(trim(ret), '/'); 
        END IF; 
 
        ret := trim(helpers.string_between(p_text, '59F:', ':7')); 
        IF ( length(ret) > 1 ) THEN 
            RETURN replace(trim(ret), '/'); 
        END IF; 
 
        RETURN replace(ret, '/'); 
    END; 
 
    FUNCTION extract_country ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret      VARCHAR2(4000) := NULL; 
        p_result VARCHAR2(4000); 
    BEGIN    
-- get tag 177   
        --ret := utl_swift.get_tag_value(p_text, '59');   
        ret := trim(helpers.string_between(p_text, '59:', ':7')); 
-- should be 10 digits and numeric   
        IF ( length(ret) > 1 ) THEN 
            p_result := replace(trim(ret), '/', ' ');  
            -- return p_result; 
            RETURN last_words(p_result); 
        END IF; 
 
        ret := trim(helpers.string_between(p_text, '59A:', ':7')); 
        -- ret := utl_swift.get_tag_value(p_text, '59A');   
-- should be 10 digits and numeric   
        IF ( length(ret) > 1 ) THEN 
            p_result := replace(trim(ret), '/', ' '); 
            RETURN last_words(p_result); 
        END IF; 
 
        ret := trim(helpers.string_between(p_text, '59F:', ':7')); 
        IF ( length(ret) > 1 ) THEN 
            p_result := replace(trim(ret), '/', ' '); 
            RETURN last_words(p_result); 
        END IF; 
 
        p_result := replace(ret, '/', ' '); 
        RETURN last_words(p_result); 
    END; 
 
    FUNCTION extract_datetime ( 
        p_text IN CLOB 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(20); 
    BEGIN    
-- get tag 177   
        ret := trim(helpers.string_between(p_text, '177:', '}'));   
-- should be 10 digits and numeric   
        IF ( 
            length(ret) = 10 
            AND helpers.is_number(ret) = 1 
        ) THEN 
            RETURN trim(ret); 
        END IF;   
-- if we don't get tag 177 try tag 2, but tag 177 should always be there   
 
        ret := substr(helpers.string_between(p_text, '{2:', '}'), -11, 10); 
 
        IF ( 
            length(ret) = 10 
            AND helpers.is_number(ret) = 1 
        ) THEN 
            RETURN trim(ret); 
        END IF;   
-- tag 32A :32A:200603NGN20000000,00  sometimes has date, but we need to add HHMI   
 
        ret := substr(helpers.string_between(p_text, '32A:', ','), 0, 6); 
 
        IF ( 
            length(ret) = 6 
            AND helpers.is_number(ret) = 1 
        ) THEN 
            RETURN trim(ret || '0000'); 
        END IF;   
-- return null when no valid values    
 
        RETURN NULL; 
    END; 
 
    FUNCTION extract_beneficiary_account ( 
        p_text IN CLOB, 
        p_tag  IN VARCHAR2 DEFAULT '59' 
    ) RETURN VARCHAR2 AS 
 
        p_len      NUMBER := 3; 
        p_start    NUMBER; 
        p_ret      VARCHAR2(5); 
        p_needle   VARCHAR2(100); 
        p_currency currency%rowtype; 
        p_data     VARCHAR2(2000); 
        p_tokens   apex_t_varchar2; 
        p_end      VARCHAR2(20) := ':7'; 
        patterns   VARCHAR2(1000) := '59:,59A:,59F:'; 
        p_starts   apex_t_varchar2; 
        p_item     VARCHAR2(100); 
        p_result   VARCHAR2(200); 
    BEGIN  
        -- p_data := trim(helpers.string_between(p_text, p_tag || ':', chr(10))); 
        -- sometimes account number has spaces eg: 3011 0111 2312 7644  
        -- others have no spaces 854526372784 
        -- so we cant rely on spaces and we dont have  
        -- a predictable fixed length of account numbers 
        -- just return account number and name together for now 
        -- p_data := trim(helpers.string_between(p_text, p_tag || ':', p_end)); 
        p_starts := apex_string.split(patterns, ','); 
        FOR i IN 1..p_starts.count LOOP 
            p_item := p_starts(i); 
            p_data := helpers.string_between(p_text, p_item, p_end); 
            IF length(p_data) > 1 THEN 
            -- return replace(p_data,'/'); 
                p_tokens := apex_string.split(remove_space_from_numbers(p_data), '|'); 
                p_result := replace(p_tokens(1), '/'); 
                RETURN p_result; 
            -- return regexp_replace(p_result,'[^0-9]+',''); 
            END IF; 
 
        END LOOP; 
 
        RETURN NULL; 
    EXCEPTION 
        WHEN OTHERS THEN 
            RETURN NULL; 
    END; 
 
    FUNCTION extract_reference ( 
        p_text IN CLOB, 
        p_tag  IN VARCHAR2 DEFAULT '20' 
    ) RETURN VARCHAR2 AS 
 
        p_len      NUMBER := 3; 
        p_start    NUMBER;  
        -- p_ret        VARCHAR2(5);  
        p_needle   VARCHAR2(100); 
        p_currency currency%rowtype; 
        p_ret      VARCHAR2(100); 
    BEGIN      
 -- remove special chars \r\n == chr(13) and Chr(10) and whitespaces   
 --  we get text bewteen 20 and 23 but sometimes it doesnt work, let use : instead of :23B 
        p_ret := trim(replace(replace(helpers.string_between(p_text, ':' 
                                                                     || p_tag 
                                                                     || ':', ':21'), chr(10)), chr(13)));   
 -- return null;  
        IF p_ret IS NULL THEN 
            p_ret := trim(replace(replace(helpers.string_between(p_text, ':' 
                                                                         || p_tag 
                                                                         || ':', ':23B'), chr(10)), chr(13))); 
 
        END IF; 
 
        RETURN p_ret; 
    EXCEPTION 
        WHEN OTHERS THEN  
            -- RETURN NULL; 
            RETURN trim(replace(replace(helpers.string_between(p_text, p_tag || ':', chr(10)), chr(10)), chr(13))); 
    END; 
 
    FUNCTION extract_currency ( 
        p_text IN CLOB, 
        p_tag  IN VARCHAR2 DEFAULT '32' 
    ) RETURN VARCHAR2 AS 
 
        p_len      NUMBER := 3; 
        p_start    NUMBER; 
        p_ret      VARCHAR2(5); 
        p_needle   VARCHAR2(100); 
        p_currency currency%rowtype; 
    BEGIN 
        SELECT 
            * 
        INTO p_currency 
        FROM 
            currency 
        WHERE 
            instr(upper(p_text), 
                  name) > 1;     
/*if (instr(p_text,p_tag) > 1) then      
 p_needle := p_tag||':';     
 p_start := instr(p_text,p_needle) + length(p_needle);     
 p_ret := replace(replace(substr(p_text,p_start,p_len),':'),' ');     
 */ 
 
        RETURN p_currency.name; 
    EXCEPTION 
        WHEN OTHERS THEN 
            RETURN NULL; 
    END; 
 
    FUNCTION get_tag_value ( 
        p_str IN CLOB, 
        p_tag IN VARCHAR2 
    ) RETURN VARCHAR2 AS 
    BEGIN 
        RETURN replace(replace(regexp_substr(upper(p_str), upper(p_tag) 
                                                           || ':[^:]+:?', 1), upper(p_tag)), ':'); 
    END; 
 
    FUNCTION format_text_block ( 
        p_message_type IN VARCHAR2, 
        p_text         IN VARCHAR2 
    ) RETURN VARCHAR2 IS 
        ret VARCHAR2(4000); 
    BEGIN 
        RETURN replace(replace(p_text, chr(10), '}'), chr(10), ''); 
    END; 
 
    PROCEDURE get_json_file ( 
        p_id IN NUMBER 
    ) IS 
        l_blob_content BLOB; 
        l_mime_type    VARCHAR2(100) := 'text/plain'; 
        l_file_name    VARCHAR2(500); 
    BEGIN 
        SELECT 
            utl_raw.cast_to_raw(doc), 
            reference 
        INTO 
            l_blob_content, 
            l_file_name 
        FROM 
            swift_document 
        WHERE 
            id = p_id; 
 
        sys.htp.init; 
        sys.owa_util.mime_header('text/plain', FALSE); 
        sys.htp.p('Content-Description: File Transfer'); 
        sys.htp.p('Content-Type: application/octet-stream');     
  -- sys.htp.p('Content-Disposition: attachment; filename="'||l_file_name||'"');     
        sys.htp.p('Content-Length: ' || dbms_lob.getlength(l_blob_content)); 
        sys.htp.p('Content-Disposition: attachment; filename="' 
                  || l_file_name 
                  || '.json"'); 
        sys.owa_util.http_header_close; 
        sys.wpg_docload.download_file(l_blob_content); 
        apex_application.stop_apex_engine;     
/*EXCEPTION     
  WHEN OTHERS THEN     
    -- HTP.p('');     
    null;     
    */ 
    END; 
 
    PROCEDURE get_file ( 
        p_id IN VARCHAR2 
    ) IS 
 
        l_blob_content CLOB; 
        l_mime_type    VARCHAR2(100) := 'text/plain'; 
        l_file_name    VARCHAR2(4000); 
        p_doc_id       NUMBER; 
        l_offset       NUMBER := 1; 
        l_chunk        NUMBER := 3000;  
        -- %rowtype;  
    BEGIN 
        SELECT 
            id 
        INTO p_doc_id 
        FROM 
            messages 
        WHERE 
                reference = p_id 
            AND ROWNUM <= 1; 
 
        SELECT 
            source_file, 
            filename 
        INTO 
            l_blob_content, 
            l_file_name 
        FROM 
            swift_document 
        WHERE 
            id = p_doc_id; 
 
        sys.htp.init; 
        sys.owa_util.mime_header('text/plain', FALSE);  
        -- sys.htp.p('Content-Description: File Transfer');  
        -- sys.htp.p('Content-Type: application/octet-stream');     
  -- sys.htp.p('Content-Disposition: attachment; filename="'||l_file_name||'"');     
        sys.htp.p('Content-Length: ' || dbms_lob.getlength(l_blob_content)); 
        sys.htp.p('Content-Disposition: attachment; filename="' || l_file_name);  
        --sys.htp.p('Content-Disposition: filename="' || l_file_name);  
        sys.owa_util.http_header_close;  
        --sys.wpg_docload.download_file(l_blob_content);  
        LOOP 
            EXIT WHEN l_offset > length(l_blob_content); 
            htp.prn(substr(l_blob_content, l_offset, l_chunk)); 
            l_offset := l_offset + l_chunk; 
        END LOOP; 
 
        apex_application.stop_apex_engine;     
/*EXCEPTION     
  WHEN OTHERS THEN     
    -- HTP.p('');     
    null;     
    */ 
    END; 
 
    FUNCTION get_field_name ( 
        p_type_id IN NUMBER, 
        p_tag     IN VARCHAR2 
    ) RETURN VARCHAR2 AS 
        ret VARCHAR2(500) DEFAULT NULL; 
    BEGIN 
        FOR r IN ( 
            SELECT 
                * 
            FROM 
                swift_field 
            WHERE 
                    upper(tag) = upper(p_tag) 
                AND type_id = p_type_id 
        ) LOOP 
            ret := r.name; 
            RETURN ret; 
        END LOOP; 
 
        RETURN nvl(ret, ''); 
    EXCEPTION 
        WHEN no_data_found THEN 
            RETURN nvl(ret, ''); 
        WHEN OTHERS THEN 
            RETURN nvl(ret, ''); 
    END; 
 
    FUNCTION get_document ( 
        p_reference IN NUMBER 
    ) RETURN CLOB AS 
    BEGIN 
        NULL; /* insert function code */ 
    END get_document; 
 
    PROCEDURE create_document ( 
        p_json_doc    IN CLOB DEFAULT NULL, 
        p_filename    IN VARCHAR2 DEFAULT NULL, 
        p_source_file IN CLOB DEFAULT NULL 
    ) AS 
    BEGIN 
        INSERT INTO swift_document ( 
            doc, 
            source_file, 
            filename 
        ) VALUES ( 
            p_json_doc, 
            p_source_file, 
            p_filename 
        ); 
 
    EXCEPTION 
        WHEN dup_val_on_index THEN 
            NULL; 
        WHEN OTHERS THEN 
            NULL; 
    END create_document; 
 
    FUNCTION last_words ( 
        p_result CLOB, 
        p_cnt    NUMBER DEFAULT 3 
    ) RETURN CLOB AS 
 
        p_tokens apex_t_varchar2; 
        p_length NUMBER; 
        p_words  apex_t_varchar2; 
        p_start  NUMBER; 
        p_end    NUMBER; 
        p_return VARCHAR2(2000); 
        f_string VARCHAR2(4000); 
    BEGIN 
        f_string := replace(replace(p_result, chr(10), ' '), chr(13), ' '); 
 
        p_tokens := apex_string.split(trim(f_string), ' '); 
        p_length := p_tokens.count; 
        p_end := p_length; 
        IF p_length >= 3 THEN 
            p_start := p_end - 2; 
        ELSIF p_length = 2 THEN 
            p_start := p_end - 1; 
        END IF; 
 
        IF p_length >= 2 THEN 
            FOR e IN p_start..p_end LOOP 
                dbms_output.put_line(p_tokens(e)); 
                apex_string.push(p_words, p_tokens(e)); 
            END LOOP; 
 
            p_return := apex_string.join(p_words, ' '); 
        ELSE  
    -- only one word  
            p_return := p_result; 
        END IF; 
 
        dbms_output.put_line(p_return); 
        RETURN p_return; 
    END; 
 
END "UTL_SWIFT";
/
create or replace PACKAGE BODY "UTL_SYNC" 
AS 
PROCEDURE get_messages 
AS 
  l_clob CLOB; 
  l_result VARCHAR2(32767); 
  id       VARCHAR2(500); 
  p_tokens apex_t_varchar2; 
  p_clob CLOB; 
  p_text CLOB; 
  p_doc_id NUMBER; 
  p_ref    VARCHAR2(4000); 
BEGIN 
  l_clob := apex_web_service.make_rest_request ( p_url => 'http://localhost:8080/ftp-engine/runner.php', p_http_method => 'GET'); 
  dbms_output.put_line('l_clob=' || l_clob); 
  --- update doc_references table 
  FOR d  IN 
  (SELECT * 
  FROM swift_document 
  WHERE id NOT IN 
    (SELECT doc_id FROM doc_references 
    ) 
  ) 
  LOOP 
    p_tokens := apex_string.split(d.source_file,'$'); 
    FOR i IN 1..p_tokens.count 
    LOOP 
      p_text := p_tokens(i); 
      -- dbms_output.put_line(p_text); 
      p_ref := utl_swift.extract_reference(p_text); 
      dbms_output.put_line('Reference : '||p_ref); 
      -- dbms_output.put_line('Beneficiary Account : '||utl_swift.extract_beneficiary_account(p_text)); 
      --dbms_output.put_line('Beneficiary : '||utl_swift.extract_beneficiary(p_text)); 
      --dbms_output.put_line('======'); 
        INSERT 
        INTO doc_references 
          ( 
            doc_id, 
            refno, 
            text_data 
          ) 
          VALUES 
          ( 
            d.id, 
            p_ref, 
            p_text 
          ); 
    END LOOP; 
  END LOOP; 
  COMMIT; 
END get_messages; 
END utl_sync;
/































