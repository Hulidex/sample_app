# Ruby on rails tutorial para 'NosoloSoftware'

Aplicación realizada tras realizar el tutorial [*Ruby on Rails Tutorial*](https://www.railstutorial.org/).

La aplicación creada, es una página web estilo "Twitter".

> El tutorial hace uso de *active record* para manejar los **modelos** de rails. En mi caso utilizo el "ODM"(Object-Document-Mapper) **mongoid** que es un framework de mongodb, por tanto, aunque la funcionalidad es la misma, el código producido varía ligeramente al del tutorial.


## Instalación

Para poder instalar y correr la aplicación es necesario realizarlos siguientes pasos:

**Importante**: Se presupone que Ruby, la gema bundler y la gema rails están preinstaladas en el sistema antes de prodecer con la instalación.

Lo primero es instalar **mongodb** para ello podéis seguir el siguiente enlace: [*Install MongoDB*](https://docs.mongodb.com/manual/installation/).

Una vez instalado es muy importante comprobar el estado de **mongodb**:

```
$ systemctl status mongodb.service
```

Miramos la salida de dicho comando, si aparece el texto **running** en principio todo estaría bien, en caso de aparecer las palabras **not running**, comenzamos su ejecución con el comando:

```
$ systemctl start mongodb.service
```

**Opcionalmente** si queremos que mongodb se inicia cuando el sistema arranca para no tener que estar lanzándolo manualmente todo el tiempo utilizamos el comando

```
$ systemctl enable mongodb.service
```

Ahora hay que clonar el repositorio en el directorio de tu preferencia (el directorio $HOME se utiliza para ilustrar el ejemplo):

```
$ cd $HOME
$ git clone git@github.com:Hulidex/sample_app.git
```
Una vez descargado, entramos dentro del directorio:

```
$ cd sample_app
```

Instalamos todas las gemas incluidas en el archivo **Gemfile** con el comando *bundle*:

```
$ bundle install --without production
```
**Importante** si el comando anterior retorna con errores, es probable que sea necesario realizar previamente el comando:

```
$ bundle update
```

Si queremos que la aplicación web tenga ciertos usuarios, con sus relaciones y post, podemos lanzar el comando:

```
$ rails db:seed
```

He creado un pequeño script para purgar todos los datos de la aplicación por si hemos empleado el comando anterior pero aún así queremos volver a tener la aplicación limpia. Para ello ejecutar los siguientes comandos:

```
$ spring stop
$ rails runner db/purge_data_base.rb
```

Por ultimo comenzamos a ejecutar la aplicación web con el comando:

```
$ rails server
```

Se iniciarará un servicio HTTP que se servirá normalmente en el puerto 3000 de nuestra máquina, rails muestra esta información.


> Cuando utilizamos la aplicación web, puesto que el entorno no es uno de producción, los correos eléctrónicos para la **activación** de usuarios o para el **reseteo** de las contraseñas **no se envían realmente a lo emails pertinentes, en su lugar los correos son mostrados como salidas de depuración del servidor** por tanto para poder activar a los usuarios o resetear sus contraseñas, es necesario tener acceso a estas salidas de depuración, por ello nunca se debe ejecutar el comando anterior **en segundo plano**, pues estos mensajes no serán percibidos.

