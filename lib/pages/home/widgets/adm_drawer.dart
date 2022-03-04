import 'package:flutter/material.dart';

class AdmDrawer extends StatelessWidget {
  const AdmDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
              child: Column(
                children: [
                  const DrawerHeader(
                    child: Text(
                      "Bem Vindo a área de administração\nAqui você pode adicionar perguntas, remover ou edita-las",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  ListTile(
                    title: const Text("Adicionar Perguntas"),
                    subtitle: const Text("Em Construção"),
                    trailing: const Icon(Icons.add),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text("Remover Pergunta"),
                    subtitle: const Text("Em Construção"),
                    trailing: const Icon(Icons.remove),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text("Editar Pergunta"),
                    subtitle: const Text("Em Construção"),
                    trailing: const Icon(Icons.edit),
                    onTap: () {},
                  ),
                ],
              ),
    );
  }
}