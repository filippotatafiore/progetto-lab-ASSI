// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require flash
//= require jquery3

// settings
var settings_button = document.getElementById('settings-img-container');
var settings_window = document.getElementById('settings-window');

// font
var font_arial = document.getElementById('font-arial');
var font_georgia = document.getElementById('font-georgia');
var font_courier = document.getElementById('font-courier');
var font_cursive = document.getElementById('font-cursive');
var font_brush = document.getElementById('font-brush');
var selected_font = sessionStorage.getItem('font') || 'Arial';

//font color
var font_color_white = document.getElementById('font-color-white');
var font_color_orange = document.getElementById('font-color-orange');
var font_color_blue = document.getElementById('font-color-blue');
var selected_font_color = sessionStorage.getItem('font-color') || 'white';



settings_button.addEventListener('click', function() {
    settings_window.classList.toggle('window-visibility');
    console.log('finestra impostazioni');
});



// ----------------------------------------------------------------font

font_arial.addEventListener('click', function() {
    selected_font = 'Arial';
    aggiornaFont();
});
font_georgia.addEventListener('click', function() {
    selected_font = 'Georgia';
    aggiornaFont();
});
font_courier.addEventListener('click', function() {
    selected_font = 'Courier';
    aggiornaFont();
});
font_cursive.addEventListener('click', function() {
    selected_font = 'Cursive';
    aggiornaFont();
});
font_brush.addEventListener('click', function() {
    selected_font = 'Brush Script MT';
    aggiornaFont();
});


// ----------------------------------------------------------------font color
font_color_white.addEventListener('click', function() {
    selected_font_color = 'white';
    aggiornaFontColor();
});
font_color_orange.addEventListener('click', function() {
    selected_font_color = 'darkorange';
    aggiornaFontColor();
});
font_color_blue.addEventListener('click', function() {
    selected_font_color = 'lightblue';
    aggiornaFontColor();
});







function aggiornaFont(){
    document.body.style.fontFamily = selected_font;
    sessionStorage.setItem('font', selected_font); // Salva il font nel Session Storage
}

function aggiornaFontColor(){
    document.body.style.color = selected_font_color;
    sessionStorage.setItem('font-color', selected_font_color); // Salva il font color nel Session Storage
}

aggiornaFont();
aggiornaFontColor();