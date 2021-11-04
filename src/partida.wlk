import wollok.game.*
import jugadores.*
import cartas.*
import texto.*
import elementos.*
import soundProducer.*

object partida {
	const musica = soundProducer.sound("sonido.mp3")
	
	const agua = new Elemento(nombre="agua")
	const hielo = new Elemento(nombre="hielo")
	const fuego = new Elemento(nombre="fuego")
	
	const textoGanador = new Texto(texto = "GANA EL JUGADOR", color = "verde")
	const textoPerdedor = new Texto(texto = "GANA LA MAQUINA", color = "rojo")
	const textoDesempate = new Texto(texto = "DESEMPATE", color = "azul")
	
	const maquina = new JugadorMaquina(nombre= "perroGrande",posicion = game.at(21, 7), poderBase = 75)
	const jugador = new JugadorManual(posicion = game.at(4, 7), poderBase = 100)
	const participantes = [ jugador, maquina ]
	const rivales = ["perroGrande","Gaucho"]
	
	var victoriasJugador = 0


	method previa(){
		self.configurarElementos()
		self.configurarSonido()
		self.configurarTeclasSeleccionPJ()
		seleccionadorDePersonaje.mostrarSeleccion()
	}
	
	method configurarElementos(){
		agua.debilidad(hielo)
		fuego.debilidad(agua)
		hielo.debilidad(fuego)
	}
	
	method configurarSonido(){
		game.schedule(100, { musica.play() })
		musica.shouldLoop(true)
		musica.volume(0.5)
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
		participantes.forEach( {unParticipante => unParticipante.validarManosGanadas() })
		self.mostrarMarcador()
	}

	method mostrarMarcador(){
		const puntajeJ = new Texto(texto= jugador.cantManosGanadas().toString(),color = "verde",x=2,y=17)
		const puntajeJugador = new Texto(texto = "PUNTAJE JUGADOR: " ,color = "verde",x=2,y=18)
		const puntajeM = new Texto(texto= maquina.cantManosGanadas().toString(),color = "rojo",x=26,y=17)
		const puntajeMaquina = new Texto(texto = "PUNTAJE MAQUINA: " ,color = "rojo",x=26,y=18)
		
		game.addVisual(puntajeJugador)
		game.addVisual(puntajeJ)
		game.addVisual(puntajeMaquina)
		game.addVisual(puntajeM)
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
		keyboard.q().onPressDo({ jugador.upgradearCartaAlAzar()})
		keyboard.g().onPressDo({ jugador.ganoMano()})
		keyboard.k().onPressDo({ self.kiricocho()})
		keyboard.r().onPressDo({ self.reiniciar()})
	}
	
	method configurarTeclasSeleccionPJ(){
		keyboard.right().onPressDo({ seleccionadorDePersonaje.cambiaPJ(1)})
		keyboard.left().onPressDo({ seleccionadorDePersonaje.cambiaPJ(-1)})
		keyboard.enter().onPressDo({ seleccionadorDePersonaje.personajeElegido()})
	}
	
	
	method kiricocho(){
		game.say(jugador,"Kiricocho")
		self.victoriaJugador()
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
			maquina.ganoMano()
		}
		game.addVisual(texto)
		game.schedule(1000,{self.reiniciar()})
	}

	method desempatar() {
		participantes.forEach({ unParticipante => unParticipante.decirPoderTotal()})
	}

	method resultado() {
		if (jugador.poderTotal() > maquina.poderTotal()) {
			jugador.ganoMano()
			return "GANASTE"
		} else if (jugador.poderTotal() < maquina.poderTotal()) {
			maquina.ganoMano()
			return "PERDISTE"
		} else return "Somos igual de buenos"
	}
	
	method victoriaJugador(){		
		victoriasJugador += 1
		if(victoriasJugador < rivales.size()){
			victoria.contraMaquina()
			self.prepararSiguienteRonda()
		}
		else{
			victoria.definitiva()
			jugador.posicion(game.at(13,10))
			game.addVisual(jugador)
		}
		
	}
	
	method prepararSiguienteRonda(){
		maquina.nombre(rivales.get(victoriasJugador))
		maquina.cantManosGanadas(0)
		jugador.cantManosGanadas(0)
	}
	
	
	method victoriaMaquina(){
		victoria.maquina()
		maquina.posicion(game.at(12,7))
		game.addVisual(maquina)
		game.say(maquina,"BUEN INTENTO")
	
	}

}

object seleccionadorDePersonaje{
	const titulo = new Texto(texto = "PDEP-JITSU", color = "verde")
	const nombrePJ = new Texto(texto = "<-- perrito -->",color = "rojo",x = 14,y=8)
	const pjs = ["perrito","carpincho","Doctor"]
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
	
	method cambiaPJ(numero){
		contador = (contador + numero).max(0).min(2)
		pj = pjs.get(contador)		
		imagen = pj + "_base.png"
		nombrePJ.texto("<-- " + pj + " -->")
	}
	
	method personajeElegido(){
		game.clear()
		partida.establecerNombreJugador(pj)
	}
}

object victoria{
	const texto1 = new Texto(texto="GANASTE LA RONDA!!",color = "verde",x=14,y=16)
	const texto2 = new Texto(texto="SIGUIENTE RIVAL -->",color = "verde",x=14,y=15)
	const texto3 = new Texto(texto="FELICITACIONES! VENCISTE A TODOS LOS RIVALES",color = "verde")
	const texto4 = new Texto(texto="PERDISTE LA  PARTIDA ",color = "rojo",x=14,y=16)
	const textoReinicio = new Texto(texto = "PRESIONA LETRA   (R)   PARA SIGUIENTE RONDA", color = "azul",x=14,y=3)
	
	method contraMaquina(){
		game.addVisual(texto1)
		game.addVisual(texto2)
		game.addVisual(textoReinicio)
	}
	
	method definitiva(){
		game.clear()
		game.addVisual(texto3)
	}
	
	method maquina(){
		game.clear()
		game.addVisual(texto4)
	}
	
}
