import wollok.game.*
import cartas.*
import partida.*

class Jugador {
	var property cartas = []
	var imagen
	const posicion
	const poderBase
	var modo = base
	
	method image() = modo.imagen(self)
	
	method imagen() = imagen
	
	method position() = posicion
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method tieneCarta(carta) = cartas.contains(carta)
	
	method poderCartas(){
		return cartas.sum({carta => carta.poderTotal()})
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
	
	method modo(_modo){modo = _modo}
}


class JugadorManual inherits Jugador {
	var cantManosGanadas = 0	
	
	method decirPoderTotal(){
		 game.say(self,"Mi poder total es: " + self.poderTotal().toString()) 
	}
	
	method poderTotal(){
		return poderBase + self.poderCartas()
	}
	
	method upgradearCartaAlAzar(){
		const rareza = [rara,legendaria].anyOne()
		cartas.anyOne().rareza(rareza)
	}
	
	method ganoMano(){
		cantManosGanadas += 1
		if (cantManosGanadas == 5){modo = motivado}
	}
	

}


class JugadorMaquina inherits Jugador{
	
	method decirPoderTotal(){
		 game.say(self,"El mio es: " + self.poderTotal().toString() + ", " + partida.resultado()) 
	}
	
	method poderTotal(){
		return poderBase * self.poderCartas()
	}

}

object base{
	
	method imagen(jugador) = jugador.imagen()
}

object motivado{
	
	method imagen(jugador) = "perrito_upgrade.png"
}