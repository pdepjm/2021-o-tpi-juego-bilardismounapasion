import wollok.game.*

// ¡Los visuales también pueden ser texto!
// Hay que definir la posición en la que debe aparecer
// Y el texto que se debe mostrar. Para eso debe implementar el método text()
// el cual debe devolver un string
// Por defecto el color es azul, pero se puede modificar
// Para ello debe entender el mensaje textColor()
// El método debe devolver un string que represente el color
// Debe ser en un formato particular: tiene que ser un valor RGBA en hexa "rrggbbaa"
// Les dejamos algunos ejemplos
// ¡También se puede combinar con las imágenes!

class Texto {
	
	const texto;
	const color;
	
	method position() = game.at(14,16)
	method text() = texto
	method textColor() = paleta.color(color)
}


object paleta {
	
	method color(color){ 
		if (color=="azul"){return "0000FFFF"}
		else if(color=="rojo"){return "FF0000FF"}
		else if(color=="verde"){return "00FF00FF"}
		else throw new DomainException(message = "Ese color no esta definido")
	}
}
