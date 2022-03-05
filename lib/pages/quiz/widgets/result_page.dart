import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    Key? key,
    required this.win,
  }) : super(key: key);
  final bool win;

  Widget icon() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(49.9),
        border: Border.all(width: 3, color: win ? Colors.green : Colors.red),
      ),
      child: win
          ? const Icon(
              Icons.check_rounded,
              size: 50,
              color: Colors.green,
            )
          : const Icon(
              Icons.close_rounded,
              size: 50,
              color: Colors.red,
            ),
    );
  }

  List<Widget> texts(BuildContext context) {
    return [
      Text(
        win ? "Acertou!" : "Não foi dessa vez :(",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          win
              ? "Não esqueça de continuar estudando e voltar amanhã"
              : "Parece que você não estudou 100%, estude mais e volte amanhã",
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: ElevatedButton(
          child: const Text("Voltar"),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 100,
            child: icon(),
          ),
          const SizedBox(
            height: 50,
          ),
          ...texts(context),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
