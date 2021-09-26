import wollok.game.*

class Carta{
	const nroCarta = 1
	const elemento = if (nroCarta == 1) {"fuego"}
					 else if(nroCarta == 2) {"agua"}
					 	else {"hielo"} 
	const poder = [1,2,3,4,5,6,7,8,9,10].anyOne()
	
	method elemento() = elemento
	
	method decirPoder(){
		game.say(self, "Poder: " + poder.toString())
	}
	
	method position(){
		if (nroCarta == 1) {return game.at(3,3)}
		else if(nroCarta == 2) {return game.at(8,3)}
		else {return game.at(13,3)}		
	}
	
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
		keyboard.p().onPressDo({mazoJugador.decirPoderes()})
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
	
	
}
