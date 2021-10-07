import wollok.game.*
import texto.*

class Carta{
	const nroCarta = 1
	const elemento = null
	const poder = [1,2,3,4,5,6,7,8,9,10].anyOne()
	var estaEnMazo = true
	var esDeJugador = true
	
	method elemento() = elemento
	
	method poder() = poder
	
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
		if (esDeJugador){return game.at(12,12)}
		else return game.at(16,12)
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

class JugadorNuevo {
	var cartas = []
	const poderBase = 100
	
	method image() = "PerroChiquito.png"
	
	method position() = game.at(4,7)
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
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


object partida{
	const textoGanador = new Texto (texto = "GANA EL JUGADOR",color = "verde")
	const textoPerdedor = new Texto (texto = "GANA LA MAQUINA", color = "rojo")
	const textoDesempate = new Texto ()
	
	const maquina = new JugadorExperimentado()
	const jugador = new JugadorNuevo()
	const participantes = [jugador,maquina]
	
	method iniciar(){
		self.mostrarJugadores()
		self.generarMazoJugador()
		self.generarMazoMaquina()
		self.configurarTeclas()
	}
	
	method generarMazoJugador(){
		const carta1 = new Carta(nroCarta = 1, elemento = "fuego")
		const carta2 = new Carta(nroCarta = 2, elemento = "agua")
		const carta3 = new Carta(nroCarta = 3, elemento = "hielo")
		jugador.agregarCarta(carta1)
		jugador.agregarCarta(carta2)
		jugador.agregarCarta(carta3)
		game.addVisual(carta1)
		game.addVisual(carta2)
		game.addVisual(carta3)
		
	}
	
	method generarMazoMaquina(){
		const carta1 = new Carta(nroCarta = 1, elemento = "fuego",esDeJugador = false)
		const carta2 = new Carta(nroCarta = 2, elemento = "agua",esDeJugador = false)
		const carta3 = new Carta(nroCarta = 3, elemento = "hielo",esDeJugador = false)
		maquina.agregarCarta(carta1)
		maquina.agregarCarta(carta2)
		maquina.agregarCarta(carta3)
		game.addVisual(carta1)
		game.addVisual(carta2)
		game.addVisual(carta3)
	}
	
	method configurarTeclas(){
		keyboard.p().onPressDo( {jugador.decirPoderes()} )
		keyboard.a().onPressDo( {jugador.jugarCarta(0)} )
		keyboard.s().onPressDo( {jugador.jugarCarta(1)} )
		keyboard.d().onPressDo( {jugador.jugarCarta(2)} )
		keyboard.r().onPressDo( {self.reiniciar()} )
	}
	
	method reiniciar(){
		game.clear()
		jugador.vaciar()
		maquina.vaciar()
		self.iniciar()
	}
	
	method mostrarJugadores(){
		game.addVisual(jugador)
		game.addVisual(maquina)
	}
	
	method jugar(cartaJugador) {
		const cartaMaquina = maquina.cartas().anyOne()
		cartaJugador.modificarEstadoEnMazo()
		cartaMaquina.modificarEstadoEnMazo()
		self.quienGana(cartaJugador,cartaMaquina)
	}
	
	method quienGana(cartaJugador,cartaMaquina){
		const elemJ = cartaJugador.elemento()
		const elemM = cartaMaquina.elemento()
		
		if(self.leGana(elemJ,elemM)){
			game.addVisual(textoGanador)
		}

		else if(elemJ == elemM){
			game.addVisual(textoDesempate)
			self.desempatar()
		}
		else {
			game.addVisual(textoPerdedor)
			}
	}
	
	
	method leGana(cartaGanadora,cartaPerdedora) {
		if (cartaGanadora == "fuego" && cartaPerdedora == "hielo"){return true}
		else if (cartaGanadora == "agua" && cartaPerdedora == "fuego"){return true}
		else if (cartaGanadora == "hielo" && cartaPerdedora == "agua"){return true}
		else {return false}
	}
	
	method desempatar(){
		participantes.forEach( {unParticipante => unParticipante.decirPoderTotal()} )
	}
	
	method resultado(){
		if(jugador.poderTotal() > maquina.poderTotal()) {return "GANASTE"}
		else if(jugador.poderTotal() < maquina.poderTotal()) {return "PERDISTE"}
		else return "somos igual de buenos"
	}
}

	

