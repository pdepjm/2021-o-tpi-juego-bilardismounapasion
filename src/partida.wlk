import wollok.game.*
import jugadores.*
import cartas.*
import texto.*

object partida {
	const textoGanador = new Texto(texto = "GANA EL JUGADOR", color = "verde")
	const textoPerdedor = new Texto(texto = "GANA LA MAQUINA", color = "rojo")
	const textoDesempate = new Texto(texto = "DESEMPATE", color = "azul")
	
	const textoReinicio = new Texto(texto = "PRESIONA R PARA VOLVER A JUGAR", color = "rojo")
	
	const maquina = new Jugador(imagen = "PerroGrande.png", posicion = game.at(21, 7), poderBase = 75)
	const jugador = new Jugador(imagen = "PerroChiquito.png", posicion = game.at(4, 7), poderBase = 100)
	const participantes = [ jugador, maquina ]

	method iniciar() {
		self.mostrarJugadores()
		self.generarMazo(true)
		self.generarMazo(false)
		self.configurarTeclas()
	}

	method generarMazo(perteneceAJugador) {
		const elementos = [ "hielo", "agua", "fuego" ]
		var participante
		if (perteneceAJugador) participante = jugador else participante = maquina
		
		[ 1, 2, 3 ].forEach({ nro =>
			const carta = new Carta(nroCarta = nro, elemento = elementos.get(nro - 1), esDeJugador = perteneceAJugador)
			 participante.agregarCarta(carta)
			 game.addVisual(carta)
		})
	}

	method configurarTeclas() {
		keyboard.p().onPressDo({ jugador.decirPoderDeCartas()})
		keyboard.a().onPressDo({ jugador.jugarCarta(0)})
		keyboard.s().onPressDo({ jugador.jugarCarta(1)})
		keyboard.d().onPressDo({ jugador.jugarCarta(2)})
		keyboard.r().onPressDo({ self.reiniciar()})
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
		
		if (self.leGana(elemJ, elemM)) {
			texto = textoGanador
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

	method leGana(cartaGanadora, cartaPerdedora) {
		return (cartaGanadora == "fuego" && cartaPerdedora == "hielo") || (cartaGanadora == "agua" && cartaPerdedora == "fuego") || (cartaGanadora == "hielo" && cartaPerdedora == "agua")
	}

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

