# SUNAT Hackathon TOSHI APP

La aplicación BOT en TOSHI para ejecutar los pagos online desde tu billetera privada de dinero digital.

Miembros del equipo:

* Juan José Miranda del Solar - Lider
* Alonso Rejas
* Manuel Hohagen Serpa
* Victor David Ramos Brast
* Roberto Principe - Documentador

## Diagrama de secuencia de los diferentes componentes de la aplicación

![secuencia](docs/images/diagramsecuence.png)

## Architecture

Deploying a SUNAT TOSSHI app requires a few processes to run:

* **toshi-headless-client**<br>
  This is a client we provide (similar to the iOS or Android client) that provides a wrapper around the Toshi backend services. It also handles end-to-end encrypting all messages using the Signal protocol. It is written in Java and runs in the background, proxying all the requests to and from your bot.
* **redis**<br>
  We use redis pub/sub to provide a connection between the toshi-headless-client and your bot.
* **bot.js**<br>
  This is where all your app logic lives.
* **postgres**<br>
  Postgres is used to store session data so you can persist state for each user who talks to your bot (similar to cookies in a web browser).

![diagram](docs/images/app-architecture.png)

