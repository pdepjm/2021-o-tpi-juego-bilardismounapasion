import wollok.game.*
import jugadores.*
import cartas.*
import texto.*
import elementos.*

object partida {
	const textoGanador = new Texto(texto = "GANA EL JUGADOR", color = "verde")
	const textoPerdedor = new Texto(texto = "GANA LA MAQUINA", color = "rojo")
	const textoDesempate = new Texto(texto = "DESEMPATE", color = "azul")
	
	const textoReinicio = new Texto(texto = "PRESIONA R PARA VOLVER A JUGAR", color = "rojo")
	
	const maquina = new JugadorMaquina(nombre= "perroGrande",posicion = game.at(21, 7), poderBase = 75)
	const jugador = new JugadorManual(posicion = game.at(4, 7), poderBase = 100)
	const participantes = [ jugador, maquina ]


	method previa(){
		self.configurarTeclasSeleccionPJ()
		seleccionadorDePersonaje.mostrarSeleccion()
	}
	
	method establecerNombreJugador(nombre){
		jugador.nombre(nombre)
		self.iniciar()
	}
	
	
	
	method iniciar() {
		self.mostrarJugadores()
		self.generarMazo(jugador)
		self.generarMazo(maquina)
		self.configurarTeclasJuego()
	}

	method generarMazo(participante) {
		const elementos = [ hielo, agua, fuego ]
		var perteneceAJugador
		if (participante == jugador) perteneceAJugador = true else perteneceAJugador = false
		
		[ 1, 2, 3 ].forEach({ nro =>
			const carta = new Carta(nroCarta = nro, elemento = elementos.get(nro - 1), esDeJugador = perteneceAJugador)
			 participante.agregarCarta(carta)
			 game.addVisual(carta)
		})
	}

	method configurarTeclasJuego() {
		keyboard.p().onPressDo({ jugador.decirPoderDeCartas()})
		keyboard.a().onPressDo({ jugador.jugarCarta(0)})
		keyboard.s().onPressDo({ jugador.jugarCarta(1)})
		keyboard.d().onPressDo({ jugador.jugarCarta(2)})
		keyboard.r().onPressDo({ self.reiniciar()})
		keyboard.q().onPressDo({ jugador.upgradearCartaAlAzar()})
		keyboard.g().onPressDo({ jugador.ganoMano()})
	}
	
	method configurarTeclasSeleccionPJ(){
		keyboard.right().onPressDo({ seleccionadorDePersonaje.cambiaPJ()})
		keyboard.left().onPressDo({ seleccionadorDePersonaje.cambiaPJ()})
		keyboard.enter().onPressDo({ seleccionadorDePersonaje.personajeElegido()})
	}

	method reiniciar() {
		game.clear()
		participantes.forEach({participante => participante.descartarse()})
		self.iniciar()
	}

	method mostrarJugadores() {
		game.addVisual(jugador)
		game.addVisual(maquina)
	}

	method jugar(cartaJugador) {
		cartaJugador.alternarEstadoEnMazo()
		
		const cartaMaquina = maquina.cartas().anyOne()
		cartaMaquina.alternarEstadoEnMazo()
		
		self.definirGanador(cartaJugador, cartaMaquina)
	}

	method definirGanador(cartaJugador, cartaMaquina) {
		const elemJ = cartaJugador.elemento()
		const elemM = cartaMaquina.elemento()
		var texto
		
		if (elemJ.leGana(elemM)) {
			texto = textoGanador
			jugador.ganoMano()
		} else if (elemJ == elemM) {
			texto = textoDesempate
			self.desempatar()
		} else {
			texto = textoPerdedor
		}
		game.addVisual(texto)
		game.schedule(1000, {=> game.removeVisual(texto)})
		game.schedule(2000, {=> game.addVisual(textoReinicio)})
	}

	/*method leGana(cartaGanadora, cartaPerdedora) {
		return (cartaGanadora == "fuego" && cartaPerdedora == "hielo") || (cartaGanadora == "agua" && cartaPerdedora == "fuego") || (cartaGanadora == "hielo" && cartaPerdedora == "agua")
	}*/

	method desempatar() {
		participantes.forEach({ unParticipante => unParticipante.decirPoderTotal()})
	}

	method resultado() {
		if (jugador.poderTotal() > maquina.poderTotal()) {
			return "GANASTE"
		} else if (jugador.poderTotal() < maquina.poderTotal()) {
			return "PERDISTE"
		} else return "somos igual de buenos"
	}

}

object seleccionadorDePersonaje{
	const titulo = new Texto(texto = "PDEP-JITSU", color = "verde")
	const nombrePJ = new Texto(texto = "<-- perrito -->",color = "rojo",x = 14,y=8)
	var pj = "perrito"
	var contador = 0
	var imagen = "perrito_base.png"
	
	method mostrarSeleccion(){
		game.addVisual(titulo)
		game.addVisual(self)
		game.addVisual(nombrePJ)
		
	}
	
	method image() = imagen
	
	method position() = game.at(13,10)
	
	method cambiaPJ(){
		contador += 1
		if(contador.even()){
			pj = "perrito"
		}
		else pj = "Carpincho"
		
		imagen = pj + "_base.png"
		nombrePJ.texto("<-- " + pj + " -->")
	}
	
	method personajeElegido(){
		game.clear()
		partida.establecerNombreJugador(pj)
	}
}
