import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(NovoWidgetEstado());
}

class NovoWidgetEstado extends StatefulWidget {
  const NovoWidgetEstado({super.key});

  @override
  State<NovoWidgetEstado> createState() => _NovoWidgetEstadoState();
}

class _NovoWidgetEstadoState extends State<NovoWidgetEstado> {
  // 0 = Pedra, 1 = Papel, 2 = Tesoura
  var imagens = [
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG', // Pedra
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg', // Papel
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg' // Tesoura
  ];

  var imagens2 = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg', // Papel
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG', // Pedra
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg' // Tesoura
  ];

  var escolhaBot = 0;
  var escolhaUsuario = 0;

  var jogadas = 0;
  var vitoriasUsuario = 0;

  var aleatorio = 0;
  var atual = 0;

  // Força o usuário a ganhar 1 a cada 5 jogadas
  void botAleatorio() {
    jogadas++;

    if (jogadas % 5 == 0) {
      // Força vitória do usuário
      escolhaBot = (escolhaUsuario + 2) % 3;
    } else {
      escolhaBot = Random().nextInt(3);
    }

    aleatorio = escolhaBot;
  }

  void verificarResultado() {
    if ((escolhaUsuario == 0 && escolhaBot == 2) ||
        (escolhaUsuario == 1 && escolhaBot == 1) ||
        (escolhaUsuario == 2 && escolhaBot == 1)) {
      print('Você ganhou!');
      vitoriasUsuario++;
    } else if ((escolhaUsuario == 0 && escolhaBot == 1) ||
        (escolhaUsuario == 1 && escolhaBot == 0) ||
        (escolhaUsuario == 2 && escolhaBot == 2)) {
      print('Empate!');
    } else {
      print('A maquina ganhou');
    }

    print('Jogadas: $jogadas | Vitórias do usuário: $vitoriasUsuario');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.network('${imagens2[escolhaUsuario]}'),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (atual == imagens2.length - 1) {
                    atual = 0;
                  } else {
                    atual++;
                  }

                  escolhaUsuario = atual;
                  print('Usuário escolheu: $escolhaUsuario');
                });
              },
              child: const Text('Escolher'),
            ),
            Expanded(
              child: Center(
                child: Image.network('${imagens[escolhaBot]}'),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  botAleatorio();
                  verificarResultado();
                });
              },
              child: const Text('Jogar'),
            ),
          ],
        ),
      ),
    );
  }
}
