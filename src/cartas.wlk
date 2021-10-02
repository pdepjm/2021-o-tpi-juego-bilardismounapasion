import wollok.game.*

class Carta{
	const nroCarta = 1
	const elemento = null
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
		if(esDeJugador){
			if (nroCarta == 1) {return game.at(2,1)}
			else if(nroCarta == 2) {return game.at(5,1)}
			else {return game.at(8,1)}
		}
		else {
			if (nroCarta == 1) {return game.at(20,1)}
			else if(nroCarta == 2) {return game.at(23,1)}
			else {return game.at(26,1)}
		}
		
	}
	
	method posicionEnJuego(){
		if (esDeJugador){return game.at(12,10)}
		else return game.at(16,10)
	}
	
	method modificarEstadoEnMazo(){estaEnMazo = false}
	
	method modificarPropietario(){esDeJugador = false} 
	
	method image(){
		if(esDeJugador){
			return "carta_" + elemento + ".png"
		}
		else if(estaEnMazo){return "carta_reverso.png"}
		else return "carta_" + elemento + ".png"
	}
	
}



object partida{
	
	method iniciar(){
		self.generarMazoJugador()
		self.generarMazoMaquina()
		self.configurarTeclas()
		
	}
	
	method generarMazoJugador(){
		const carta1 = new Carta(nroCarta = 1, elemento = "fuego")
		const carta2 = new Carta(nroCarta = 2, elemento = "agua")
		const carta3 = new Carta(nroCarta = 3, elemento = "hielo")
		mazo.agregarCartaJugador(carta1)
		mazo.agregarCartaJugador(carta2)
		mazo.agregarCartaJugador(carta3)
		game.addVisual(carta1)
		game.addVisual(carta2)
		game.addVisual(carta3)
		
	}
	
	method generarMazoMaquina(){
		const carta1 = new Carta(nroCarta = 1, elemento = "fuego",esDeJugador = false)
		const carta2 = new Carta(nroCarta = 2, elemento = "agua",esDeJugador = false)
		const carta3 = new Carta(nroCarta = 3, elemento = "hielo",esDeJugador = false)
		mazo.agregarCartaMaquina(carta1)
		mazo.agregarCartaMaquina(carta2)
		mazo.agregarCartaMaquina(carta3)
		game.addVisual(carta1)
		game.addVisual(carta2)
		game.addVisual(carta3)
	}
	
	method configurarTeclas(){
		keyboard.p().onPressDo( {mazo.decirPoderes()} )
		keyboard.a().onPressDo( {mazo.jugarCarta(0)} )
		keyboard.s().onPressDo( {mazo.jugarCarta(1)} )
		keyboard.d().onPressDo( {mazo.jugarCarta(2)} )
		keyboard.r().onPressDo( {game.clear()
								 self.iniciar()
		} )
	}
}

object mazo{
	var cartasJugador=[]
	var cartasMaquina=[]
	
	method agregarCartaJugador(carta){
		cartasJugador.add(carta)
	}
	
	method agregarCartaMaquina(carta){
		cartasMaquina.add(carta)
	}
	
	method decirPoderes(){
		cartasJugador.forEach( {unaCarta => unaCarta.decirPoder()} )
	}
	
	method jugarCarta(indice){
		jugada.jugar(cartasJugador.get(indice),cartasMaquina.anyOne())
	}
	
}

object jugada{
	
	method jugar(cartaJugador,cartaMaquina) {
		cartaJugador.modificarEstadoEnMazo()
		cartaMaquina.modificarEstadoEnMazo()
		self.quienGana(cartaJugador,cartaMaquina)
	}
	
	method quienGana(cartaJugador,cartaMaquina){
		
	}
	
}
