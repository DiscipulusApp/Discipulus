import 'package:discipulus/api/models/messages.dart';

class RandomAPI {
  static List<Bericht> messages() {
    return List.generate(
      10,
      (index) => Bericht(
        id: index,
        rawOnderwerp: "Bericht $index",
        mapId: 0,
        afzender: Afzender(naam: "Deurmat"),
        heeftPrioriteit: index.isEven,
        heeftBijlagen: (index * 3).isEven,
        isGelezen: index < 2,
        verzondenOp: DateTime.now().subtract(Duration(days: index)),
        inhoud: "<h1>Kijk voor de broncode op Github ;)</h1>",
        ontvangers: [
          Ontvanger(weergavenaam: "Harry", type: "Leerling"),
          Ontvanger(weergavenaam: "Loo", type: "Docent")
        ],
        links: ItemLinks(),
      ),
    );
  }
}
