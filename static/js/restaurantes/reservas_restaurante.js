
        window.onload = function() {
            // Seleccionamos todos los elementos con la clase 'alert'
            const flashMessages = document.querySelectorAll('.flash-messages .alert');
    
            // Para cada mensaje de flash, hacemos que desaparezca después de 1 segundo
            flashMessages.forEach(function(message) {
                setTimeout(function() {
                    // Cambiamos la opacidad a 0 para que se desvanezca
                    message.style.opacity = '0';
                    
                    // Después de 1 segundo, eliminamos el mensaje del DOM
                    setTimeout(function() {
                        message.remove();
                    }, 1000);  // 1000 ms (1 segundo)
                }, 1000);  // 1000 ms (1 segundo para esperar antes de hacer desaparecer el mensaje)
            });
        };
    