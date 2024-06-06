// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require flash
//= require jquery3

var settings_button = document.getElementById('settings-img-container');
var settings_window = document.getElementById('settings-window');

settings_button.addEventListener('click', function() {
    settings_window.classList.toggle('window-visibility');
    console.log('finestra impostazioni');
});
