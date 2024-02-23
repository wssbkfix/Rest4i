     h dftactgrp(*no) actgrp(*NEW) alloc(*teraspace)
     h* bnddir('MDRUSERBND')
     h* bnddir('LXRGLOBAL':'BNDZIP')
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
      /copy qrpglesrc,mdrusercpy

     d clients         Pr                  ExtPgm('CLIENTS')
     d p_custid                       7A
     d p_custname                    30A


       // Write query parameter definitions
     d p_custid        s              7A
     d n_custid        s               n
     d p_custname      s             30A
     d n_custname      s               n

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
       p_custid = %trim(d_parm(1).s_value);
       n_custid = *On;
       endif;
       if %trim(d_parm(2).s_value) <> '*notFound';
       p_custname = %trim(d_parm(2).s_value);
       n_custname = *On;
       endif;

       Endsr;
      // =====================================================================
      // Populate Required Parameters List
      // =====================================================================
       Begsr z_setParms;
      // Populate the List of Expected Parms:
       d_parm(1).s_Name= 'custid';
       d_parm(1).s_Required= *on ;
       d_parm(2).s_Name= 'custname';
       d_parm(2).s_Required= *on ;
       Endsr;
      // =====================================================================
      // Populate Parms Required RETURN (HTTP TYPE - OPTION)
      // =====================================================================
       begsr z_setMethod;
       // Required and Optional Parameters:
       beginObject(' ');
         addChar('Get':'Mandatory Parms: custid,custname');
         endObject();
       n_ParmError = *on;
       Endsr;
      // =====================================================================
      // Override Get Method
      // =====================================================================
       Begsr z_ProcGET;

      // Logic from custom copybook

       clients(p_custid:p_custname);


       Exsr Z_PrcSndRsp;


       Endsr;
      // =====================================================================
      // // Process Send Response
      // =====================================================================
       Begsr Z_PrcSndRsp;

       Endsr;
      /End-Free
      // =====================================================================
      // LXR Generic Procedures
      // =====================================================================
      /copy qrpglesrc,lxrrestp