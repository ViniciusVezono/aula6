import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const JokenpoApp());
}

enum Opcao { pedra, papel, tesoura }

class JokenpoApp extends StatelessWidget {
  const JokenpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jokenpô'),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: const Jogo(),
      ),
    );
  }
}

class Jogo extends StatefulWidget {
  const Jogo({super.key});

  @override
  State<Jogo> createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  final player = AudioPlayer();

  final Map<Opcao, String> imagens = {
    Opcao.pedra: 'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    Opcao.papel: 'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    Opcao.tesoura: 'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg',
  };

  Opcao? _escolhaUsuario;
  Opcao? _escolhaApp;
  String _mensagemResultado = "Escolha uma opção abaixo";
  
  int _vitoriasUsuario = 0;
  int _vitoriasApp = 0;

  void _tocarSom(String nomeDoArquivo) {
    player.play(AssetSource('audio/$nomeDoArquivo'));
  }

  void _jogar(Opcao escolhaUsuario) {
    _tocarSom('select.mp3'); // ALTERADO: para o seu arquivo
    setState(() {
      _escolhaUsuario = escolhaUsuario;
      _escolhaApp = _gerarEscolhaApp();
      _verificarResultado(_escolhaUsuario!, _escolhaApp!);
    });
  }

  Opcao _gerarEscolhaApp() {
    int indiceAleatorio = Random().nextInt(Opcao.values.length);
    return Opcao.values[indiceAleatorio];
  }

  void _verificarResultado(Opcao usuario, Opcao app) {
    if (usuario == app) {
      _mensagemResultado = "Empate!";
      _tocarSom('select.mp3'); // ALTERADO: reutilizando o som de seleção para o empate
      return;
    }

    bool usuarioVenceu = (usuario == Opcao.pedra && app == Opcao.tesoura) ||
                           (usuario == Opcao.papel && app == Opcao.pedra) ||
                           (usuario == Opcao.tesoura && app == Opcao.papel);

    if (usuarioVenceu) {
      _mensagemResultado = "Você Ganhou! :)";
      _vitoriasUsuario++;
      _tocarSom('win.mp3'); // ALTERADO: para o seu arquivo
    } else {
      _mensagemResultado = "O App Ganhou! :(";
      _vitoriasApp++;
      _tocarSom('game-over.mp3'); // ALTERADO: para o seu arquivo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            _mensagemResultado,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildJogadaDisplay("Você", _escolhaUsuario),
              const Text("VS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              _buildJogadaDisplay("App", _escolhaApp),
            ],
          ),

          Text(
            "Faça sua jogada:",
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Opcao.values.map((opcao) {
              return InkWell(
                onTap: () => _jogar(opcao),
                child: Image.network(
                  imagens[opcao]!,
                  height: 100,
                  width: 100,
                ),
              );
            }).toList(),
          ),
          
          Text(
            "Placar: Você $_vitoriasUsuario X $_vitoriasApp App",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildJogadaDisplay(String label, Opcao? escolha) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: escolha != null
              ? Image.network(imagens[escolha]!)
              : const Center(child: Text("?")),
        ),
      ],
    );
  }
}
