
var send_button = document.getElementById('send_button');
var form = document.getElementById('user_input_form');

send_button.addEventListener('click', function () {
    form.submit();
    //console.log("form submitted");
});

