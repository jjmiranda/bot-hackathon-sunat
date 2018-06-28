const Bot = require('./lib/Bot')
const SOFA = require('sofa-js')
const Fiat = require('./lib/Fiat')
const unit = require('ethjs-unit')
const http = require('http')
const querystring = require('querystring')

let bot = new Bot()

// ROUTING
//Usar el RUC en donde estan estas facturas RUC: 10706008391

bot.onEvent = function(session, message) {
  switch (message.type) {
    case 'Init':
      initMe(session)
      break
    case 'Message':
      onMessage(session, message)
      break
    case 'Command':
      onCommand(session, message)
      break
    case 'Payment':
      onPayment(session, message)
      break
    case 'PaymentRequest':
      noooPaymentRequest(session)
      break
  }
}

function onMessage(session, message) {
  if (session.get('registrado') == 0){
    pedirID(session, message)
  }
  else {
    message = `En que te puedo ayudar ` + session.get('user_id')
    botonesPrincipales(session, message)
  }
}

function onCommand(session, command) {
  switch (command.content.value) {
    case 'si':
      siEstaBien(session)
      break
    case 'no':
      noEstaBien(session)
      break
    case 'pagar':
      let userID = session.get('user_id')
      jalarPendientesPago(session, String(userID) )
      break
    case 'nada':
      nada(session)
      break
    default:
      let dictionarioPago = JSON.parse(command.content.value)
      requestPago(session, dictionarioPago.monto, dictionarioPago.emisor, dictionarioPago.serie)
      break  
    }
}

function onPayment(session, message) {
  console.log(message)
  if (message.fromAddress == session.config.paymentAddress) {
    // handle payments sent by the bot
    if (message.status == 'confirmed') {
      // perform special action once the payment has been confirmed
      // on the network
      session.reply(`onPayment pago enviado por el BOT!`)
    } else if (message.status == 'error') {
      // oops, something went wrong with a payment we tried to send!
      session.reply(`error onPayment pago enviado por el BOT!`)
    }
  } else {
    // handle payments sent to the bot
    if (message.status == 'unconfirmed') {
      // payment has been sent to the ethereum network, but is not yet confirmed
      botonesPrincipales(session, `Gracias por el pago.`);
    } else if (message.status == 'confirmed') {
      // handle when the payment is actually confirmed!
      session.reply(`Pago confirmado!`)
    } else if (message.status == 'error') {
      botonesPrincipales(session, `There was an error with your payment!🚫`);
    }
  }
}

function noooPaymentRequest(session) {
  session.reply(`No te podemos enviar dinero que ya no es tuyo ;)`)
  message = `En que te puedo ayudar ` + session.get('user_id')
  botonesPrincipales(session, message)
}

function onPaymentRequest(session, message) {
  //fetch fiat conversion rates
  Fiat.fetch().then((toEth) => {
    let limit = toEth.USD(100)
    if (message.ethValue < limit) {
      session.sendEth(message.ethValue, (session, error, result) => {
        if (error) { session.reply('I tried but there was an error') }
        if (result) { session.reply('Here you go!') }
      })
    } else {
      session.reply('Sorry, I have a 100 USD limit.')
    }
  })
  .catch((error) => {
    session.reply('Sorry, something went wrong while I was looking up exchange rates')
  })
}

// STATES

function initMe(session) {
  //session.reply(SOFA.InitRequest({
  //  values: ['paymentAddress', 'language']
  //}));
  session.set('registrado', 0)
  session.reply(`Bienvenido a la aplicación digital de SUNAT`)
  session.reply(`Danos tu DNI o tu RUC para saber quien eres:`)
}

function pedirID(session,message) {
  session.set('user_id',message.content.body) //TODO: Validar que lo que se meta es un DNI o RUC valido.
    session.reply(SOFA.Message({
      body: `Es correcto: ` + message.content.body,
      controls: [
        {type: 'button', label: 'Si', value: 'si'},
        {type: 'button', label: 'No, corregir', value: 'no'}
      ],
      showKeyboard: false,
    }))
}

function siEstaBien(session) {
  session.set('registrado',1)
  session.reply(`Gracias por registrarte con nosotros ` + session.get('user_id'))
  let message = `En que te puedo ayudar ahora:`
  botonesPrincipales(session, message)
}

function noEstaBien(session) {
  session.set('registrado',0)
  let message = `Por favor vuelve a ingresar correctamente tu DNI o tu RUC`
  session.reply(SOFA.Message({
    body: message,
    controls: [],
    showKeyboard: true,
  }))
}

function jalarPendientesPago(session, idDoc) {
  console.log(idDoc)
  let post_data = JSON.stringify( JSON.parse('{"documento":"' + String(idDoc) + '"}') )
  console.log(post_data)
  let post_options = {
      host: '190.81.160.219',
      port: '8081',
      path: '/api/tienda/listar-ventas-pendientes',
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(post_data)
      }
  };
  let post_req = http.request(post_options, function(res) {
    var output = '';
    res.setEncoding('utf8');
    res.on('data', function (chunk) {
        output += chunk;
    });
    res.on('end', function () {
        let obj = JSON.parse(output.trim());
        console.log('resultado = ', obj);
        let docsPagar = []
        for (var i = 0, len = obj.resultado.length; i < len; i++) {
          let total = obj.resultado[i].total
          let serie = obj.resultado[i].serie
          let emisor = obj.resultado[i].emisor
          docsPagar.push({type: 'button', label: 'S/'+total+' '+emisor, value: '{monto:'+total+' ,emisor:'+emisor+', serie:'+serie+'}'})
        }
        let message = `Tus documentos por pagar son los siguientes:`
        session.reply(SOFA.Message({
          body: message,
          controls: docsPagar,
          showKeyboard: false,
        }))
    });
  });
  post_req.write(post_data);
  post_req.end();
}

function requestPago(session, monto, emisor, serie) {
  //session.reply(`Ejecutar las funciones para pagar S/` + monto)
  Fiat.fetch().then((toEth) => {
    // convert 20 US dollars to ETH.
    let amount = toEth.PEN(parseFloat(monto))
    session.requestEth(amount, serie)
  })
  let post_data = JSON.stringify( JSON.parse('{"serie":' + serie + '}') )
  //console.log(post_data)
  let post_options = {
      host: '190.81.160.219',
      port: '8081',
      path: '/api/tienda/actualizar-venta-receptor',
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
          'Content-Length': Buffer.byteLength(post_data)
      }
  };
  let post_req = http.request(post_options, function(res) {
    var output = '';
    res.setEncoding('utf8');
    res.on('data', function (chunk) {
        output += chunk;
    });
    res.on('end', function () {
        let obj = JSON.parse(output.trim());
        console.log('resultado = ', obj);
    });
  });
  post_req.write(post_data);
  post_req.end();
}

function nada(session) {
  let message = `Perfecto, te esperamos en tu próximo pago`
  botonesPrincipales(session, message)
}

// example of how to store state on each user
function count(session) {
  let count = (session.get('count') || 0) + 1
  session.set('count', count)
  sendMessage(session, `${count}`)
}

function donate(session) {
  // request $1 USD at current exchange rates
  Fiat.fetch().then((toEth) => {
    session.requestEth(toEth.USD(1))
  })
}

// HELPERS

function botonesPrincipales(session, message) {
  session.reply(SOFA.Message({
    body: message,
    controls: [
      {type: 'button', label: 'Pagar', value: 'pagar'},
      {type: 'button', label: 'Nada, gracias', value: 'nada'}
    ],
    showKeyboard: false,
  }))
}
