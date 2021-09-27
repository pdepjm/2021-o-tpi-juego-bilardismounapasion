import wollok.game.*

class Carta{
	const nroCarta = 1
	const elemento = if (nroCarta == 1) {"fuego"}
					 else if(nroCarta == 2) {"agua"}
					 	else {"hielo"} 
	const poder = [1,2,3,4,5,6,7,8,9,10].anyOne()
	var estaEnMazo = true
	var esDeJugador = true
	
	method elemento() = elemento
	
	method decirPoder(){
		game.say(self, "Poder: " + poder.toString())
	}
	
	method position(){
		if (estaEnMazo) { return self.posicionEnMazo() }
		else return self.posicionEnJuego()
				
	}
	
	method posicionEnMazo(){
		if (nroCarta == 1) {return game.at(3,3)}
		else if(nroCarta == 2) {return game.at(8,3)}
		else {return game.at(13,3)}
	}
	
	method posicionEnJuego(){
		if (esDeJugador){return game.at(13,15)}
		else return game.at(18,15)
	}
	
	method modificarEstadoEnMazo(){estaEnMazo = false}
	
	method modificarPropietario(){esDeJugador = false} 
	
	method image(){
		return "carta_" + elemento + ".png"
	}
	
}



object partida{
	
	method iniciar(){
		self.generarMazoJugador()
		self.configurarTeclas()
		
	}
	
	method generarMazoJugador(){
		const carta1 = new Carta(nroCarta = 1)
		const carta2 = new Carta(nroCarta = 2)
		const carta3 = new Carta(nroCarta = 3)
		mazoJugador.agregarCarta(carta1)
		mazoJugador.agregarCarta(carta2)
		mazoJugador.agregarCarta(carta3)
		game.addVisual(carta1)
		game.addVisual(carta2)
		game.addVisual(carta3)
		
	}
	
	method configurarTeclas(){
		keyboard.p().onPressDo( {mazoJugador.decirPoderes()} )
		keyboard.a().onPressDo( {mazoJugador.jugarCarta(0)} )
		keyboard.s().onPressDo( {mazoJugador.jugarCarta(1)} )
		keyboard.d().onPressDo( {mazoJugador.jugarCarta(2)} )
	}
}

object mazoJugador{
	var cartas=[]
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method decirPoderes(){
		cartas.forEach( {unaCarta => unaCarta.decirPoder()} )
	}
	
	method jugarCarta(indice){
		jugada.jugar(cartas.get(indice))
	}
	
}

object jugada{
	
	method jugar(cartaJugada) {
		const cartaMaquina = new Carta(nroCarta = [1,2,3].anyOne(),estaEnMazo = false,esDeJugador = false)
		cartaJugada.modificarEstadoEnMazo()
		self.quienGana(cartaJugada,cartaMaquina)
	}
	
	method quienGana(cartaJugador,cartaMaquina){
		
	}
	
}
