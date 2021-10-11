import wollok.game.*
import cartas.*
import partida.*

class Jugador {
	var property cartas = []
	const imagen
	const posicion
	const poderBase
	
	method image() = imagen
	
	method position() = posicion
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method tieneCarta(carta) = cartas.contains(carta)
	
	method poderCartas(){
		return cartas.sum({carta => carta.poder()})
	}
	
	method decirPoderBase(){
		game.say(self,"Mi poder base es: " + poderBase.toString())
	}
	
	method descartarse(){
		cartas = []
	}
	
	method decirPoderDeCartas(){
		cartas.forEach( {unaCarta => unaCarta.decirPoder()} )
	}
	
	method jugarCarta(indice){
		partida.jugar(cartas.get(indice))
	}
}


class JugadorNuevo inherits Jugador {	
	
	method decirPoderTotal(){
		 game.say(self,"Mi poder total es: " + self.poderTotal().toString()) 
	}
	
	method poderTotal(){
		return poderBase + self.poderCartas()
	}
	
}


class JugadorExperimentado inherits Jugador{
	
	method decirPoderTotal(){
		 game.say(self,"El mio es: " + self.poderTotal().toString() + ", " + partida.resultado()) 
	}
	
	method poderTotal(){
		return poderBase * self.poderCartas()
	}

}