import wollok.game.*
import texto.*
import elementos.*

class Carta{
	const nroCarta
	const property elemento
	const property poderBase = [1,2,3,4,5,6,7,8,9,10].anyOne()
	var property estaEnMazo = true
	const esDeJugador = true
	var rareza = comun
	
	method esDeJugador() = esDeJugador
	
	method decirPoder(){
		game.say(self, "Poder: " + self.poderTotal().toString())
	}
	
	method rareza(_rareza){rareza = _rareza}
	
	method poderTotal() = rareza.poderTotal(self)
	
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
	
	method image() = rareza.imagen(self)
	
}

object comun{
	
	method imagen(carta){
		if(not carta.esDeJugador() && carta.estaEnMazo()){return "carta_reverso.png"}
		else return "carta_" + carta.elemento().toString() + ".png"
	}
	
	method poderTotal(carta) = carta.poderBase()
}

object rara{
	
	method imagen(carta) = "cartaRara_" + carta.elemento().toString() + ".png"
	
	method poderTotal(carta) = 2 * carta.poderBase() + 100
}

object legendaria{
	
	method imagen(carta) = "cartaLegendaria_" + carta.elemento().toString() + ".png"
	
	method poderTotal(carta) = carta.poderBase() * 10000000
}