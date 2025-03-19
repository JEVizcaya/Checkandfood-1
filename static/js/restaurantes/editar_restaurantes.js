
// Espera que la página haya cargado completamente
document.addEventListener('DOMContentLoaded', function() {
    // Obtener todos los mensajes flash
    const flashMessages = document.querySelectorAll('.flash-messages .alert');

    flashMessages.forEach(function(flashMessage) {
        // Después de 1 segundo (1000 ms), ocultar el mensaje
        setTimeout(function() {
            flashMessage.style.transition = 'opacity 0.5s ease-out'; // Agrega una transición suave
            flashMessage.style.opacity = '0'; // Reduce la opacidad para hacer desaparecer el mensaje
            // Después de la transición, eliminar el mensaje
            setTimeout(function() {
                flashMessage.remove();
            }, 500); // Elimina el mensaje después de medio segundo
        }, 1000); // Retardo de 1 segundo antes de empezar la desaparición
    });
});
