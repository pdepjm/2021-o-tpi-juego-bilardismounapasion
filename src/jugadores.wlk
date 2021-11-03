import wollok.game.*
import cartas.*
import partida.*

class Jugador {
	var property cartas = []
	var property posicion
	const poderBase
	var modo = base
	var property nombre = "perrito"
	var property cantManosGanadas = 0	
	
	method image() = modo.imagen(self)
	
	method position() = posicion
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method tieneCarta(carta) = cartas.contains(carta)
	
	method poderCartaJugada(){
		return self.cartaJugada().poderTotal()
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
		game.schedule(600,{partida.reiniciar()})
	}
	
	method modo(_modo){modo = _modo}
	
	method cartaJugada() = cartas.find( {unaCarta => not unaCarta.estaEnMazo() } )
	
	method ganoMano(){
		cantManosGanadas += 1
	}
}


class JugadorManual inherits Jugador {

	
	method decirPoderTotal(){
		 game.say(self,"Mi poder total es: " + self.poderTotal().toString()) 
	}
	
	method poderTotal(){
		return poderBase + self.poderCartaJugada()
	}
	
	method upgradearCartaAlAzar(){
		const rareza = [rara,legendaria].anyOne()
		cartas.anyOne().rareza(rareza)
	}
	
	
	method validarManosGanadas(){
		if (cantManosGanadas < 3){
			modo = base
		}
		if (cantManosGanadas >= 3){
			modo = motivado
		}
		if (cantManosGanadas >=2){
			self.upgradearCartaAlAzar()
		}
		if (cantManosGanadas == 3){
			partida.victoriaJugador()
		}
	}
	
}


class JugadorMaquina inherits Jugador{
	
	method decirPoderTotal(){
		 game.say(self,"El mio es: " + self.poderTotal().toString() + ", " + partida.resultado()) 
	}
	
	method poderTotal(){
		return poderBase * self.poderCartaJugada()
	}

	method validarManosGanadas(){
		
		if (cantManosGanadas == 3){
			partida.victoriaMaquina()
		}
	}

}

object base{
	
	method imagen(jugador) = jugador.nombre() + "_base.png"
}

object motivado{
	
	method imagen(jugador) = jugador.nombre() + "_upgrade.png"
}