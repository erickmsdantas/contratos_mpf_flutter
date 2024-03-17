import 'package:contratos_mpf/contratados/screens/contratados_screen.dart';
import 'package:contratos_mpf/contratos/screens/contratos_screen.dart';
import 'package:contratos_mpf/notificacoes/screens/notificacoes_screen.dart';
import 'package:flutter/material.dart';

import 'favoritos/screens/favoritos_screen.dart';

class NavMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Contratos'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContratosScreen()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Contratados'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContratadosScreen()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Favoritos'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritosScreen()),
              )
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Notificações'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificacoesScreen()),
              )
            },
          ),
        ],
      ),
    );
  }
}
