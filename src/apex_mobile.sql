CREATE OR REPLACE package apex_mobile is
  procedure write_footer_from_list
          ( p_list_name   in  varchar2
          );
          
  function format_datetime
      ( p_date                 in  date
      )  return  varchar2;          
end;
/


CREATE OR REPLACE package body apex_mobile is

  AMP     char(1) := chr(38);

  procedure write_footer_from_list
          ( p_list_name   in  varchar2
          ) is
    l_template      varchar2(4000) := '<div class="app-footer-button"><a href="#LINK#">#TEXT#</a></div>';
    l_html          varchar2(4000);
    l_app_id        varchar2(100);
    l_session       varchar2(100);
    l_debug         varchar2(100);
  begin
    l_app_id  := v('APP_ID');
    l_session := v('SESSION');
    l_debug   := v('DEBUG');

    sys.htp.p('<div id="app-footer">');
    for r in ( select ale.entry_text    as  text
                    , ale.entry_target  as  link
               from   apex_application_lists          ali
                join  apex_application_list_entries   ale
                      on   ali.application_id = ale.application_id
                      and  ali.list_name      = ale.list_name 
               where  ali.application_id = v('APP_ID')
                 and  ali.list_name      = p_list_name
             ) 
    loop
      l_html := l_template;
      l_html := replace(l_html,'#LINK#'    , r.link);
      l_html := replace(l_html,'#TEXT#'    , r.text);
      l_html := replace(l_html,AMP||'APP_ID.'  , l_app_id);
      l_html := replace(l_html,AMP||'SESSION.' , l_session);
      l_html := replace(l_html,AMP||'DEBUG.' , l_debug);
sys.htp.comment(l_html||','||AMP||'APP_ID.'||','||AMP||'SESSION.');
      sys.htp.p(l_html);
    end loop;
    sys.htp.p('</div>');
  end;
  
  function format_datetime
      ( p_date                 in  date
      )  return  varchar2 is
    l_days_diff    number;
    l_weekday      number;
    l_year         boolean;
    l_return       varchar2(4000);
  begin
    l_days_diff := trunc(p_date) - trunc(sysdate);
    l_weekday   := trunc(sysdate) - trunc(p_date,'iw') + 1;
    l_year      := ( trunc(sysdate,'yyyy') = trunc(p_date,'yyyy') );

    l_return    := case when l_days_diff =  0          then to_char(p_date,'hh24:mi')
                        when l_days_diff = -1          then 'yesterday'
                        when l_days_diff =  1          then 'tomorrow'
                        when l_weekday between 1 and 7 then to_char(p_date,'day')
                        when l_year                    then ltrim(to_char(p_date,'dd month'),'0')
                        else ltrim(to_char(p_date,'dd'),'0')    || ' '
                              ||rtrim(to_char(p_date,'month'))  || ' '  
                              ||to_char(p_date,'yyyy')
                   end;

    return(l_return);               
  end format_datetime;
  
end;
/
