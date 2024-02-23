     h dftactgrp(*no) actgrp(*NEW) alloc(*teraspace)
     h* bnddir('MDRUSERBND')
     h* bnddir('LXRGLOBAL':'BNDZIP')
      // disclaimer modified because pub400 does not support Rest4i
      // matches code in tutorial as close as possible.
      //  ===================================== warning =======================================
      * Â©=2019 Midrange Dynamics=============================================
      * MDRest4i OVERRIDE - uncomment to allow comma, decimal seperator
      * Â©=2019 Midrange Dynamics=============================================
      * h decedit(',')
      * Â©=2019=Midrange Dynamics=============================================
      * Â©=2019=Midrange Dynamics==========================================
      * Create Date :
      * Created By : Midrange Dynamics
      * Description : This is the MDRest4i RESTfull Webservice
      * Service Type: RESTfull Webservice
      * Input : GET Request - URL PARMS
      * Output : Error/warning - JSON Component
      * Â©=2019=Midrange Dynamics==========================================

      // Standard MDRest4i Copybooks for REST Service
      //copy qrpglesrc,mdrusercpy

      // Variable Definitions
     d w_string        s          20480
     d w_str2          s          20480
      // Define Work Variables for SQL building
     d                 ds
     d   s_statement               1024    varying
     d   s_statement1              1024    overlay(s_statement:+3)
     d   s_firstRec                    n
     d w_stmtcnt       s            200
      // Custom Variables for response schema
     d d_S             ds                  qualified
     d lx_clid                        9B 0
     d lx_clidno                     15A
     d lx_clname                     30A
     d lx_clsurname...
     d                               30A
     d lx_cltitle                    10A
     d lx_clphone                    15A
     d lx_clemail                   100A
     d lx_claddr1                    30A
     d lx_claddr2                    30A
     d lx_claddr3                    30A
     d lx_clpcode                    15A
     d lx_cllang                      1A

     d w_Count         s             10i 0

      // Write query parameter definitions
     d p_id            s              9B 0
     d n_id            s               n

      // Indicate subroutine overrides defined locally
      /define LXR_CustomInit

      /define LXR_CheckParms
      /define LXR_SetMethod
      /define LXR_SetParms
      /define LXR_ProcGET

      /copy qrpglesrc,mdrestdfn
      /copy qrpglesrc,lxrrestc

      /undefine LXR_CustomInit

      /undefine LXR_CheckParms
      /undefine LXR_SetMethod
      /undefine LXR_SetParms
      /undefine LXR_ProcGET

      /Free
      // =====================================================================
      // Customized initialization
      // =====================================================================
       Begsr Z_CustomInit;

       // If the response (GET/POST/PUT/PATCH) is greater than 5Mb,
       // set w_maxrsplen to the expected maximum response length
       // uncomment the statement below and set the value as required
       // w_maxrsplen =15542880;

       // If the requestBody (POST/PUT/PATCH) is greater than 5Mb,
       // set w_maxreqlen to the expected maximum request body length
       // w_maxreqlen =15542880;

       // If request or response value is greater than 16MB,
       // declare the keyword "alloc(*teraspace)" in control spec of this pro

       // In order to determine the actual request/response size, set the
       // indicators "n_getreqsize"/"n_getrspsize" (as applicable) to *On.
       // The REST API will then only return the request/response size.
       // The indicator "n_getrspsize" will allocate 500MB memory from heap
       // to process the reqeust and return the response size.
       // If the expected response size is much lesser, set the max expected
       // size in "w_debug_max_rsp_size" e.g. 10485760 (10MB)

       // Use this IFS switch to log the API data in an IFS Folder
       // If you set n_saveIFSSwitch to *on; Then set the log filepath e.g:
       // w_saveIFSPath='/MDREST4i/myfolder/mycustomlogs/LogFileddmmyyyy.txt'
       n_saveIFSSwitch = *off;

       // Add HTTP header x-mdrsrvjob: MYRESTPGM-MYPGMLIB-MYSERVERJOB-nnnnnn
       // where nnnnnn is the CGI job number, and MYSERVERJOB is HTTP Instanc
       ng_mdrJobHdr = *off;

       // Extracts request query parameters to d_Qparm data structure
       n_extractQryPrms = *off;

       Endsr;

      // =====================================================================
      // Check and Populate Parms - Empty Declaration
      // =====================================================================
       Begsr z_checkParms;

       if %trim(d_parm(1).s_value) <> '*notFound';
         p_id = %dec(%trim(d_parm(1).s_value):9:0);
         n_id = *On;
       endif;

       Endsr;
       // ====================================================================
       // Populate Required Parameters List
       // =====================================================================
       Begsr z_setParms;
       // Populate the List of Expected Parms:
        d_parm(1).s_Name= 'id';
        d_parm(1).s_Required= *off ;
       Endsr;
       // =====================================================================
       // Populate Parms Required RETURN (HTTP TYPE - OPTION)
       // =====================================================================
       begsr z_setMethod;
       // Required and Optional Parameters:
        beginObject(' ');
        addChar('Get':'Optional Parms: id');
        endObject();
        n_ParmError = *on;
       Endsr;
       // =====================================================================
       // Override Get Method
       // =====================================================================
       Begsr z_ProcGET;

       // Logic from custom copybook

       Exsr z_PrcResponse;

       Endsr;
      // =====================================================================
      // Process Response
      // =====================================================================
       Begsr z_PrcResponse;

       n_BgnKey = *Off;
       clear d_S;
         // Main SQL statement for cursors
       s_statement =
       'select ID, CLIDNO, CLNAME, CLSURNAME, CLTITLE, CLPHONE, CLEMAIL,'+
       ' CLADDR1, CLADDR2, CLADDR3, CLPCODE, CLLANG from LXCLIENT';

       w_stmtcnt = 'select count(*) from LXCLIENT';

         // Below is an optional parameter in query string
       if n_id = *On;
        s_statement = %trim(s_statement) + ' where ID = '+ %char(p_id);

        w_stmtcnt = %trim(w_stmtcnt) + ' where ID = '+ %char(p_id);
       endif;

         // Start preparing cursors
        exec sql prepare w_stmtcnt from :w_stmtcnt;

        exec sql prepare s_statement1 from :s_statement1;                    0166.00

        if sqlstt <> c_SqlSuccess;
          ErrorJSON('No data to return');
          leavesr;
        endif;

          // Process SQL data
          exec sql declare c2_curser cursor for w_stmtcnt;
          exec sql open c2_curser;
          // Load the count of records
          exec sql fetch c2_curser into :w_count;
          exec sql declare c1_curser cursor for s_statement1;
          exec sql open c1_curser;
          // Prepare an array for multiple record selection
          exec sql fetch c1_curser into :d_S;
          if sqlstt = c_SqlSuccess or sqlstt < c_SqlEOF;
          // Build Response Container
          if w_count > 1;
            beginObject(' ');
            beginArray('LXCLIENT');
          endif;
        else;
         ErrorJSON('No data to return');
         leavesr;
        endif;

        dow sqlstt < c_SqlEOF;
          Exsr Z_ProcessSend;
          exec sql fetch c1_curser into :d_S;
        enddo;
        if w_count > 1;
          endArray();
          endObject();
        endif;

        // Close the cursors
        exec sql close c1_curser;
        exec sql close c2_curser;

       Endsr;
      // =====================================================================
      // Process the DB file
      // =====================================================================
       Begsr Z_ProcessSend;

        beginObject(' ');

       // Execute any data manipulations here

       // Add a JSON object for each field from IO/SQL
       addintr('clid':d_s.lx_clid);
       addchar('clidno': %trim(d_s.lx_clidno));
       addchar('clname': %trim(d_s.lx_clname));
       addchar('clsurname': %trim(d_s.lx_clsurname));
       addchar('cltitle': %trim(d_s.lx_cltitle));
       addchar('clphone': %trim(d_s.lx_clphone));
       addchar('clemail': %trim(d_s.lx_clemail));
       addchar('claddr1': %trim(d_s.lx_claddr1));
       addchar('claddr2': %trim(d_s.lx_claddr2));
       addchar('claddr3': %trim(d_s.lx_claddr3));
       addchar('clpcode': %trim(d_s.lx_clpcode));
       addchar('cllang': %trim(d_s.lx_cllang));
       endObject();
       Endsr;
       /End-Free
      // =====================================================================
      // LXR Generic Procedures
      // =====================================================================
      /copy qrpglesrc,lxrrestp