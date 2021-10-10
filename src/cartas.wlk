import wollok.game.*
import texto.*

class Carta{
	const nroCarta
	const property elemento
	const property poder = [1,2,3,4,5,6,7,8,9,10].anyOne()
	var property estaEnMazo = true
	const esDeJugador = true
	
	method decirPoder(){
		game.say(self, "Poder: " + poder.toString())
	}
	
	method position(){
		if (estaEnMazo) { return self.posicionEnMazo() }
		else return self.posicionEnJuego()
	}
	
	method posicionEnMazo(){
		var posBase = 2
		if(!esDeJugador) posBase *= 10
		return game.at(posBase + (nroCarta - 1) * 3, 1)
	}
	
	method posicionEnJuego(){
		if (esDeJugador) return game.at(12,12)
		else return game.at(16,12)
	}
	
	method alternarEstadoEnMazo() { self.estaEnMazo(self.estaEnMazo().negate()) }
	
	method image(){
		if(esDeJugador){
			return "carta_" + elemento + ".png"
		}
		else if(estaEnMazo){return "carta_reverso.png"}
		else return "carta_" + elemento + ".png"
	}
	
}