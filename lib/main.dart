import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../modele/Redacteur.dart';
import '../modele/DatabaseManager.dart';

void main() {
  runApp(MonApplication());
}

class MonApplication extends StatelessWidget {

  final DatabaseManager dbManager = DatabaseManager();

  MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'MyCustomFont',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }

}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Magazine Infos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            tooltip: 'Recherche',
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logoheader.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Les Rédacteurs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedacteurInterface()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurple),
              title: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/bestnews.jpg',
              width: 800,
              fit: BoxFit.cover,
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Info'),
                content: Text('Tu as cliqué dessus'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('VALIDER'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('ANNULER'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Text('CLICK', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue au Magazine Infos ",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(
            "Votre magazine numérique, votre source d'inspiration",
            style: TextStyle(
              fontSize: 14,
              color: Colors.deepPurple,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Magazine Infos est bien plus qu'un simple magazine d'informations. "
            "C'est votre passerelle vers le monde, une source inestimable de "
            "connaissances et d'actualités soigneusement sélectionnées pour vous éclairer sur "
            "les enjeux mondiaux, la culture, la science, et voir même le divertissement (les jeux).",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class PartieIcone extends StatelessWidget {

  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            icon: Icons.phone,
            label: "TEL",
            onTap: () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: '+242069510362');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                print('Impossible d\'ouvrir le téléphone');
              }
            },
          ),
          _buildIconButton(
            icon: Icons.mail,
            label: "MAIL",
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'paridel.makouala@gmail.com',
                queryParameters: {'subject': 'Contact depuis l\'application'},
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
            },
          ),
          _buildIconButton(
            icon: Icons.share,
            label: "PARTAGE",
            onTap: () {
              Share.share(
                'Découvrez la formation en développement mobile de DCLIC https://dclic.francophonie.org/',
                subject: 'Partage depuis l\'app Magazine Infos',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.pink.withOpacity(0.0),
      highlightColor: Colors.pink.withOpacity(0.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.0),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.deepPurple, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/journal_one.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/journal_two.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/benzema.webp',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/mariage.jpg',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<String> data = [
    'L\'Observatoire',
    'L\'Express',
    'Argus Euros',
    'Les Routiers',
    'Le Monde du Camping-Car',
    'Europe Échecs',
    'Le Monde',
    'Télérama',
    'Technikart',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement how to display search results here
    final List<String> results =
        data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(results[index]));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement how to display search suggestions here
    final List<String> suggestions =
        data
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}


class RedacteurInterface extends StatefulWidget {

  final DatabaseManager dbManager = DatabaseManager();

  RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => RedacteurInterfaceState();

}

class RedacteurInterfaceState extends State<RedacteurInterface> {

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<Redacteur> redacteurList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    chargerRedacteurs();
  }

  Future<void> chargerRedacteurs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final redacteurs = await widget.dbManager.getAllRedacteurs();

      setState(() {
        redacteurList = redacteurs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur lors du chargement des rédacteurs: $e';
      });
      print(errorMessage);
    }
  }

  Future<void> ajouterRedacteur() async {

    if (nomController.text.isEmpty || prenomController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    try {
      final nouveauRedacteur = Redacteur.sansId(
        nom: nomController.text,
        prenom: prenomController.text,
        email: emailController.text,
      );

      final id = await widget.dbManager.insertRedacteur(nouveauRedacteur);

      if (id != -1) {
        nomController.clear();
        prenomController.clear();
        emailController.clear();

        await chargerRedacteurs();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rédacteur ajouté avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ajout du rédacteur')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> modifierRedacteur(Redacteur redacteur) async {

    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le rédacteur'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: prenomController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final redacteurModifie = Redacteur(
                    id: redacteur.id,
                    nom: nomController.text,
                    prenom: prenomController.text,
                    email: emailController.text,
                  );

                  final result = await widget.dbManager.updateRedacteur(
                    redacteurModifie,
                  );

                  if (result > 0) {
                    await chargerRedacteurs();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rédacteur modifié avec succès'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de la modification'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                }

                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

  }

  Future<void> supprimerRedacteur(Redacteur redacteur) async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ${redacteur.prenom} ${redacteur.nom} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final result = await widget.dbManager.deleteRedacteur(
                    redacteur.id!,
                  );

                  if (result > 0) {
                    await chargerRedacteurs();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rédacteur supprimé avec succès'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erreur lors de la suppression'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                }

                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Gestion des rédacteurs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: chargerRedacteurs,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                hintText: 'Entrez votre nom',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                hintText: 'Entrez votre prénom',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_circle_outlined),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Entrez votre email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: ajouterRedacteur,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Ajouter un Rédacteur',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            const Text(
              'Liste des rédacteurs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : redacteurList.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Aucun rédacteur enregistré',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: redacteurList.length,
                        itemBuilder: (context, index) {
                          final redacteur = redacteurList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(
                                '${redacteur.prenom} ${redacteur.nom}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(redacteur.email),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    onPressed:
                                        () => modifierRedacteur(redacteur),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => supprimerRedacteur(redacteur),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
