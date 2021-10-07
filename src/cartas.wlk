import wollok.game.*
import texto.*

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

class JugadorNuevo {
	var cartas = []
	const poder = 100
	
	method image() = "perroChiquito.png"
	
	method position() = game.at(2,11)
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method poder(){
		return poder* 45
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
	const poder = 150
	
	method image() = "perroGrande.png"
	
	method position() = game.at(19,11)
	
	method poder(){
		return poder* 78978
	}
	
	method agregarCarta(carta){
		cartas.add(carta)
	}
	
	method vaciar(){
		cartas = []
	}
	
	method cartas() = cartas
	
}


object partida{
	const textoGanador = new Texto (texto = "Gana el Jugador",color = "verde")
	const textoPerdedor = new Texto (texto = "Gana la maquina", color = "rojo")
	const textoEmpate = new Texto ()
	
	const maquina = new JugadorExperimentado()
	const jugador = new JugadorNuevo()
	
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
		
		if(elemJ == "fuego" && elemM == "hielo"){
			game.addVisual(textoGanador)
		}
		else if(elemJ == "hielo" && elemM == "agua"){
			game.addVisual(textoGanador)
		}
		else if(elemJ == "agua" && elemM == "fuego"){
			game.addVisual(textoGanador)
		}
		else if(elemJ == elemM){
			game.addVisual(textoEmpate)
		}
		else {
			game.addVisual(textoPerdedor)
			}
		}
}

	

