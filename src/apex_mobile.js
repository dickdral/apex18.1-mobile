/* 
 * Sets the page title from the breadcrumb to the top bar, 
 * replacing the Application name
 * For smooth rendering the logo should be hidden ( mobile_apex.css)
 */
function mob_set_page_title() {
    var title=$('.t-Breadcrumb-label').text();
    $('.t-Header-logo').text(title)
                       .css('text-align','center')
                       .show();
}
/* 
 * Hides the success message after a given timeout
 */

function set_success_message_fade(pTimeout)
{
    timeout = (pTimeout) ? pTimeout : 2000;
    setTimeout(function () {
        apex.message.hidePageSuccess();
        $('#APEX_SUCCESS_MESSAGE').css('height','0');
        },
        timeout);
}

mob_set_page_title();
set_success_message_fade();