/*class Elemento{
	const debilidad
	
	method leGana(contrincante) = contrincante.esDebilidad(self)
	
	method esDebilidad(contrincante) = contrincante == debilidad
}*/


object fuego {
	const debilidad = agua
	
	method leGana(contrincante) = contrincante.esDebilidad(self)
	
	method esDebilidad(contrincante) = contrincante == debilidad
}

object agua {
	const debilidad = hielo
	
	method leGana(contrincante) = contrincante.esDebilidad(self)
	
	method esDebilidad(contrincante) = contrincante == debilidad
}

object hielo {
	const debilidad = fuego
	
	method leGana(contrincante) = contrincante.esDebilidad(self)
	
	method esDebilidad(contrincante) = contrincante == debilidad
}