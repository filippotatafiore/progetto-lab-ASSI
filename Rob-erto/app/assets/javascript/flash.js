document.addEventListener('DOMContentLoaded', function() {
    var flashMessage = document.querySelector('.flash');
    if (flashMessage) {
      swal({
        title: flashMessage.dataset.title,
        text: flashMessage.dataset.message,
        icon: flashMessage.dataset.type,
        button: "OK",
      });
    }
  });