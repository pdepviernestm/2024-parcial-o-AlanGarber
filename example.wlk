/*
El objetivo es modelar algunos aspectos de las personas, sus emociones y los eventos que viven.


Averiguar si una persona es adolescente. Los expertos en las emociones informan que la etapa de adolescencia arranca con 12 años y termina cuando cumple 19.
Hacer que una persona tenga una nueva emoción.
Averiguar si está por explotar emocionalmente, lo que ocurre cuando todas las emociones de la persona pueden liberarse.
Representar que una persona viva un evento, con las consecuencias que ello puede implicar.
Permitir modificar el valor para considerar elevada la intensidad de las emociones
Hacer que todos los integrantes de un grupo de personas vivan un mismo evento. 


Los eventos 
Los eventos que una persona vive generan un impacto en la persona y pueden liberar todas sus emociones, pero depende de cómo sea cada una de ellas. Una emoción se libera según el evento, pero sólamente si dicha emoción puede ser liberada. 
Todas las emociones deben poder informar cuántos eventos experimentaron en su existencia, independientemente si en estos fueron liberadas o no.
Muchas veces pasa que al liberarse la emoción, algo se altera en ella que hace que no pueda volver a liberarse ante un próximo evento. 
El impacto de un evento se expresa con un número positivo. También se conoce la descripción de cada evento, que se representa como una cadena de caracteres.


Las emociones
Las emociones, si bien son propias de cada persona, tienen rasgos distintivos y ciertas características comunes entre diferentes personas. De esta manera, se identfifican, al menos inicialmente, ciertos estereotipos de emociones.
El valor para considerar elevada la intensidad de una emoción es el mismo para todas las personas y emociones, pero puede cambiarse en cualquier momento. 


Furia
La emoción de la furia consta de una serie de palabrotas que se van aprendiendo u olvidando con el tiempo. 
La furia de una persona puede liberarse si tiene una intensidad elevada y si conoce al menos una palabrota con más de 7 letras. La intensidad inicial es 100, pero puede variar.
Liberarse consiste en disminuir la intensidad tantas unidades como el impacto del evento. Además, olvida la primer palabrota aprendida. 


Alegría
No hay un valor inicial conocido para su intensidad, sino que depende de cada caso. Liberarse consiste en disminuir la intensidad tantas unidades como el impacto del evento. Nunca su intensidad puede ser negativa, sino que si por cualquier circunstancia se le quisiera dar un valor negativo, se le da el mismo valor, pero positivo. 
La alegría puede ser liberada cuando tiene una intensidad elevada y la cantidad de eventos vividos es par. 


Tristeza
La emoción de la tristeza de cualquier persona sabe que inicialmente su causa es la melancolía. Su intensidad puede variar sin limitaciones.
La tristeza puede ser liberada si su causa no sea precisamente la melancolía y su intensidad es elevada. 
Liberarse implica registrar como causa la descripción del evento vivido y disminuir la intensidad tantas unidades como el impacto del evento.


Desagrado y temor:
En ambos casos, pueden ser liberadas cuando tienen una intensidad elevada y la cantidad de eventos vividos es mayor que su propia intensidad. 
Liberarse implica disminuir la intensidad tantas unidades como el impacto del evento.

*/

class Persona {
  var property edad
  var property emociones = []

  method adolescente() {
    return edad >= 12 && edad <= 19
  }

  method agregarEmocion(emocion) {
        emociones.add(emocion)
    }
    
  method porExplotar() {
        return emociones.all({ emocion => emocion.puedeSerLiberada() })
    }
    
  method vivirEvento(evento) {
    emociones.forEach({ emocion => 
      if (emocion.puedeSerLiberada()) {
        emocion.liberarse(evento)
        }
      
      emocion.registrarEvento()
    })
  }

  method cantidadEventos() {
      return emociones.sum({ emocion => emocion.cantidadEventos() })
  }
}

class Evento {
  var property impacto
  var property descripcion
}

class Emocion {
    var property intensidad
    var eventosVividos = 0
    var property intensidadElevada = 50
    
    method registrarEvento() {
        eventosVividos = eventosVividos + 1
    }
    
    method cantidadEventos() = eventosVividos
    
    method disminuirIntensidad(valor) {
        intensidad = intensidad - valor
    }

    method puedeSerLiberada() {
        return intensidad > intensidadElevada 
    }

    method liberarse(evento) {
    if (self.puedeSerLiberada()) {
      intensidad = intensidad - evento.impacto()
    }
  }
}

class Furia inherits Emocion {
  const palabrotas = []
    
    override method initialize() {
        intensidad = 100
    }
    
    method agregarPalabrota(palabrota) {
        palabrotas.add(palabrota)
    }
    
    method olvidarPalabrota() {
        if (!palabrotas.isEmpty()) {
            palabrotas.remove(palabrotas.first())
        }
    }
    
  override method puedeSerLiberada() {
        return super() && palabrotas.any({ palabrota => palabrota.length() > 7 })
    }
    
  override method liberarse(evento) {
      super(evento)
      self.olvidarPalabrota()
    }

}

class Alegria inherits Emocion {
    override method puedeSerLiberada() {
        return super() && eventosVividos.even()
    }
    
    override method disminuirIntensidad(valor) {
        intensidad = (intensidad - valor)
         if (intensidad < 0) {
            intensidad = intensidad * -1
        }
    }

    override method liberarse(evento) {
      self.disminuirIntensidad(evento.impacto())
    }
}

class Tristeza inherits Emocion {
    var causa = "melancolia"
    
    override method puedeSerLiberada() {
        return super() && causa != "melancolia" 
    }
    
    override method liberarse(evento) {
        causa = evento.descripcion()
        super(evento)
    }
}

class Desagrado inherits Emocion {
    override method puedeSerLiberada() {
        return super() && eventosVividos > intensidad
    }
}

class Temor inherits Emocion {
    override method puedeSerLiberada() {
        return super() && eventosVividos > intensidad
    }
}

/* PARTE 2
  Aparece una nueva emoción que toda persona puede tener: ansiedad. 
  Inventar una implementación que tenga algo diferente a las otras emociones, utilizando el concepto de polimorfismo y herencia. 
  Explica para qué fueron útiles dichos conceptos. 
*/
class Ansiedad inherits Emocion {
    var nivelEstres = 0
    
    override method puedeSerLiberada() {
        return intensidad > intensidadElevada and 
               nivelEstres > 50
    }
    
    override method liberarse(evento) {
        self.disminuirIntensidad(evento.impacto())
        nivelEstres = nivelEstres - evento.impacto() * 0.75
    }
    
    method aumentarEstres(valor) {
        nivelEstres += valor
    }
}

/*
Los conceptos de polimorfismo y herencia sirvieron para:

Evitar duplicacion de codigo comun 
Permitir que cada emoción tenga su propio comportamiento sobre el puedeSerLiberada y otros metodos
Tener un sistema escalaba por si quiero sumar otras emociones
*/
