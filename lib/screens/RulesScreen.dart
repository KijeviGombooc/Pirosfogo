import 'package:flutter/material.dart';
import 'package:path/path.dart';

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rules"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Card(
                  child: const Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text("1: Színre színt kötelező rakni"),
              )),
            ),
            const Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Card(
                  child: const Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    "2. Ha nincs olyan színed amit hívtak, akkor bármelyik színt rakhatod"),
              )),
            ),
            const Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Card(
                  child: const Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    "3. Pirosat csak akkor szabad hívni, ha már csak pirosad van és nincs más színed"),
              )),
            ),
            const Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Card(
                  child: const Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text("4. Nem kötelező felülütni (überelni)"),
              )),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                        "Pontozás szabályai:\n- Mindenki annyi pontot kap, ahány piros lapot visz.\n- Független a lap értékétől, minden piros lap egy ponttal növeli a pontszámot.\n-24 pont elérésekor (akár játszma közben is) veszít a játékos."),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                        "Osztás:\n-Iránya az óramutató járásával ellentétes.\n-Az osztótól balra lévő játékos emel, jobbra lévő kezdi a kört.\n-Ha emelnek, az osztó úgy oszt ahogy akar, ha koppintanak, akkor 8-asával kell osztani."),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                        "Egyéb:\n-Ha valaki hibázik (renonce), abban a körben mind a 8 pirosat ő viszi. Hibázásnak számít az elszámolt osztás (amennyiben már valaki felvette és megnézte a lapjait), nem kijátszott lap megmutatása, vagy valamely szabály be nem tartása."),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
