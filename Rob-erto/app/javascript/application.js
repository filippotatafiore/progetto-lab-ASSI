// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require flash
//= require jquery3

// settings
var settings_button = document.getElementById('settings-img-container');
var settings_window = document.getElementById('settings-window');

// sfondo chat
var background_color_1 = document.getElementById('background-color-1');
var background_color_2 = document.getElementById('background-color-2');
var background_color_3 = document.getElementById('background-color-3');
var background_color_4 = document.getElementById('background-color-4');
var selected_background_color = sessionStorage.getItem('background-color') || 'gray';

// colore chatbox
var chatbox_color_1 = document.getElementById('chatbox-color-1');
var chatbox_color_2 = document.getElementById('chatbox-color-2');
var chatbox_color_3 = document.getElementById('chatbox-color-3');
var selected_incoming_color = sessionStorage.getItem('incoming-color') || 'darkslategrey';
var selected_outgoing_color = sessionStorage.getItem('outgoing-color') || 'goldenrod';
if (!chatbox_color_1 && !chatbox_color_2 && !chatbox_color_3) {
    selected_incoming_color = 'darkslategrey';
    selected_outgoing_color = 'goldenrod';
}

// font
var font_1 = document.getElementById('font-1');
var font_2 = document.getElementById('font-2');
var font_3 = document.getElementById('font-3');
var font_4 = document.getElementById('font-4');
var font_5 = document.getElementById('font-5');
var selected_font = sessionStorage.getItem('font') || 'Arial';
if (!font_1 && !font_2 && !font_3 && !font_4 && !font_5) {
    selected_font = 'Arial';
}

//font color
var font_color_1 = document.getElementById('font-color-1');
var font_color_2 = document.getElementById('font-color-2');
var font_color_3 = document.getElementById('font-color-3');
var selected_font_color = sessionStorage.getItem('font-color') || 'white';
if (!font_color_1 && !font_color_2 && !font_color_3) {
    selected_font_color = 'white';
}





// ----------------------------------------------------------------settings
settings_button.addEventListener('click', function() {
    settings_window.classList.toggle('window-visibility');
    console.log('finestra impostazioni');
});




// ----------------------------------------------------------------sfondo chat
background_color_1.addEventListener('click', function() {
    selected_background_color = '#fff5ea';
    aggiornaSfondoChat();
});
background_color_2.addEventListener('click', function() {
    selected_background_color = 'green';
    aggiornaSfondoChat();
});
background_color_3.addEventListener('click', function() {
    selected_background_color = 'gray';
    aggiornaSfondoChat();
});
background_color_4.addEventListener('click', function() {
    selected_background_color = 'rgb(20, 20, 20)';
    aggiornaSfondoChat();
});


// ----------------------------------------------------------------colore chatbox
if (chatbox_color_1 && chatbox_color_2 && chatbox_color_3){
    chatbox_color_1.addEventListener('click', function() {
        selected_incoming_color = 'darkslategrey';
        selected_outgoing_color = 'goldenrod';
        aggiornaChatboxColor();
    });
    chatbox_color_2.addEventListener('click', function() {
        selected_incoming_color = '#000066';
        selected_outgoing_color = '#006666';
        aggiornaChatboxColor();
    });
    chatbox_color_3.addEventListener('click', function() {
        selected_incoming_color = 'rgb(20, 20, 20)';
        selected_outgoing_color = 'greenyellow';
        aggiornaChatboxColor();
    });
}


// ----------------------------------------------------------------font
if (font_1 && font_2 && font_3 && font_4 && font_5){
    font_1.addEventListener('click', function() {
        selected_font = 'Arial';
        aggiornaFont();
    });
    font_2.addEventListener('click', function() {
        selected_font = 'Georgia';
        aggiornaFont();
    });
    font_3.addEventListener('click', function() {
        selected_font = 'Courier';
        aggiornaFont();
    });
    font_4.addEventListener('click', function() {
        selected_font = 'Cursive';
        aggiornaFont();
    });
    font_5.addEventListener('click', function() {
        selected_font = 'Brush Script MT';
        aggiornaFont();
    });
}


// ----------------------------------------------------------------colore font
if (font_color_1 && font_color_2 && font_color_3){
    font_color_1.addEventListener('click', function() {
        selected_font_color = 'white';
        aggiornaFontColor();
    });
    font_color_2.addEventListener('click', function() {
        selected_font_color = 'darkorange';
        aggiornaFontColor();
    });
    font_color_3.addEventListener('click', function() {
        selected_font_color = '#0099FF';
        aggiornaFontColor();
    });
}






// ----------------------------------------------------------------funzioni

function aggiornaSfondoChat(){
    document.getElementsByClassName('chatflow_container')[0].style.backgroundColor = selected_background_color;
    sessionStorage.setItem('background-color', selected_background_color); // Salva il colore dello sfondo chat nel Session Storage
}

function aggiornaChatboxColor(){
    var incomingElements = document.querySelectorAll('.incoming p');
    for(var i = 0; i < incomingElements.length; i++) {
        incomingElements[i].style.backgroundColor = selected_incoming_color;
    }
    var outgoingElements = document.querySelectorAll('.outgoing p');
    for(var i = 0; i < outgoingElements.length; i++) {
        outgoingElements[i].style.backgroundColor = selected_outgoing_color;
    }

    sessionStorage.setItem('incoming-color', selected_incoming_color); // Salva il colore dell'incoming chatbox nel Session Storage
    sessionStorage.setItem('outgoing-color', selected_outgoing_color); // Salva il colore dell'outgoing chatbox nel Session Storage
}

function aggiornaFont(){
    document.getElementsByClassName('chatflow_container')[0].style.fontFamily = selected_font;
    document.getElementsByClassName('user-input-container')[0].style.fontFamily = selected_font;
    sessionStorage.setItem('font', selected_font); // Salva il font nel Session Storage
}

function aggiornaFontColor(){
    document.getElementsByClassName('chatflow_container')[0].style.color = selected_font_color;
    sessionStorage.setItem('font-color', selected_font_color); // Salva il font color nel Session Storage
}

aggiornaSfondoChat();
aggiornaChatboxColor()
aggiornaFont();
aggiornaFontColor();