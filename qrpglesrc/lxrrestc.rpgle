      // supplied main logic
      /free
         dcl-pi *n;
            p_entry1  char(20);
            p_entry2  char(20);
         END-PI;
         // main
         //
           // get input parms into data structure
          d_parm(1).s_value = p_entry1;
          d_parm(2).s_value = p_entry2;



          exsr Z_CustomInit;

          exsr z_checkParms;

          exsr z_setParms;

          exsr z_ProcGET;

          return;
