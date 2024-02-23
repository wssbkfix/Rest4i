      // mock procedures for rest4i
      //
      // =====================================================================
        dcl-proc  addchar;
      // =====================================================================
       dcl-pi *n;
           keyVal  char(20) value;
           value   char(20) value;
           option  char(05) value options(*NOPASS);
       END-PI;

        dcl-s wkOption char(05);

        if %parms() = 2;
          wkOption = *blanks;
        else;
          wkOption = option;
        ENDIF;

        num_count += 1;

        OutJSONLine(num_count) = '"' + %trim(keyVal) + '"'
                                 + ': '
                                  + '"' + %trim(value) + '"';

        if wkOption <> '*LAST';
          OutJSONLine(num_count)  =  %trim(OutJSONLine(num_count)) +    ',';
        ENDIF;
        return;

       end-proc;

      // =====================================================================
        dcl-proc  addintr;
      // =====================================================================
       dcl-pi *n ;
           keyVal  char(20) value;
           value   int(10)  value;
           option  char(05) value options(*NOPASS);
       END-PI;

        dcl-s wkOption char(05);

        if  %parms() = 2;
          wkOption = *blanks;
        else;
          wkOption = option;
        ENDIF;

        num_count += 1;

        OutJSONLine(num_count) = %trim(keyVal) +
                                 ' : ' +
                                 %trim(%char(value));

        if wkOption <> '*LAST';
          OutJSONLine(num_count)  =  %trim(OutJSONLine(num_count)) +    ',';
        ENDIF;
        return;

       end-proc;

      // =====================================================================
        dcl-proc  beginarray;
      // =====================================================================
       dcl-pi *n;
         wkValue   char(20) value;
       end-pi;

        // dummy no process

       return;

       end-proc;
      // =====================================================================
        dcl-proc  beginobject;
      // =====================================================================
       dcl-pi *n ;
          wkspaces  char(01) value;
       END-PI;

         IN *LOCK OUTJSON;
         num_count += 1;

        OutJSONLIne(num_count) = '{';

        return;

       end-proc;

      // =====================================================================
        dcl-proc  endarray;
      // =====================================================================
       dcl-pi *n;
       end-pi;

        // dummy no process

       return;

       end-proc;

      // =====================================================================
       dcl-proc  endobject;
      // =====================================================================

         num_count += 1;

         OutJSONLine(num_count) = '}';

        OUT OUTJSON;
       end-proc;

      // =====================================================================
       dcl-proc  ErrorJSON;
      // =====================================================================
         dcl-pi *n;
           message  char(50) value;
         END-PI;

         message =  message + ',';
         beginObject(' ');
         addchar('Error':message: '*last');
         endObject();

         return;
       end-proc;


