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
	
	 const texto = "Empate"
	 var color = azul
	method position() = game.at(14,16)
	method text() = texto
	method textColor() = paleta.color(color)
	
	
}

object verde{
	const property verde = "00FF00FF"
}

object rojo{
	const property rojo = "FF0000FF"
}

object azul{
	const property azul = "0000FFFF"
}

object paleta {
	
method color(color){ 
		return
		if (color==azul){"0000FFFF"}
		else if(color==rojo){"FF0000FF"}
		else if(color==verde){ "00FF00FF"}

}
}
