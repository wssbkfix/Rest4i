          //misc d spec entries
      // variables added no copy books
      /Free
       dcl-s out_val   char(80)    dim(20);
       dcl-s num_count             int(10) inz(0);
       dcl-s ng_mdrJobHdr          ind;
       dcl-s n_extractQryPrms      ind;
       dcl-s n_BgnKey              ind;
       dcl-s n_ParmError           ind;
       dcl-s n_saveIFSSwitch       ind;
       dcl-s wk_Query              char(20);
       dcl-c c_sqlsuccess          const('00000');
       dcl-c c_SqlEOF              const('02000');


      // manually put in main procedure
      // mimick parameter string
        dcl-ds d_parm        qualified dim(2);
         s_value char(20)  inz(' ');
         s_name  char(20)  inz(' ');
         s_required ind    inz(*off);
        end-ds;


      /if defined(OMF_PgmCall)
          dcl-s wkSqlRetCode  int(10);
      /endif

       // data area and data structure for output
       dcl-ds OUTJSON dtaara len(2000) ;
           OutJSONLine   char(50) dim(20);
       END-DS;

      /End-free
