import wollok.game.*
import cartas.*
import partida.*

class Jugador {
	var property cartas = []
	const poderBase
	const imagen
	const posicion
	method image() = imagen
	method position() = posicion
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method tieneCarta(carta) = cartas.contains(carta)
	
	method poderCartas(){
		return cartas.map({carta => carta.poder()}).sum()
	}
	
	method poderTotal(){
		return poderBase + self.poderCartas()
	}	
	
	method decirPoderTotal(){
		 game.say(self,"Mi poder total es: " + self.poderTotal().toString()) 
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

/*
class JugadorNuevo {
	var cartas = []
	const poderBase = 100
	
	method image() = "PerroChiquito.png"
	
	method position() = game.at(4,7)
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method cartaAgregada(carta) = cartas.contains(carta)	
	
	method decirPoderTotal(){
		 game.say(self,"Mi poder total es: " + self.poderTotal().toString()) 
	}
	
	method poderTotal(){
		return poderBase + self.poderCartas()
	}
	
	method poderCartas(){
		return cartas.map({carta => carta.poder()}).sum()
	}
	
	method vaciar(){
		cartas = []
	}
	
	method decirPoderes(){
		cartas.forEach( {unaCarta => unaCarta.decirPoder()} )
	}
	
	method jugarCarta(indice){
		partida.jugar(cartas.get(indice))
	}
	
}


class JugadorExperimentado {
	var cartas = []
	const poderBase = 75
	
	method image() = "PerroGrande.png"
	
	method position() = game.at(21,7)
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method cartaAgregada(carta) = cartas.contains(carta)	
	
	method decirPoderTotal(){
		 game.say(self,"El mio es: " + self.poderTotal().toString() + ", " + partida.resultado()) 
	}
	
	method poderTotal(){
		return poderBase * self.poderCartas()
	}
	
	method poderCartas(){
		return cartas.map({carta => carta.poder()}).sum()
	}
	
	method vaciar(){
		cartas = []
	}
	
	method cartas() = cartas
	
}

*/