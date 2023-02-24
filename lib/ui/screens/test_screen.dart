import 'package:contacta_pharmacy/apis/apisNew.dart';
import 'package:contacta_pharmacy/ui/custom_widgets/no_user.dart';
import 'package:flutter/material.dart';

extension ListFromMap<Key, Element> on Map<Key, Element> {
  List<T> toList<T>(T Function(MapEntry<Key, Element> entry) getElement) =>
      entries.map(getElement).toList();
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);
  static const routeName = '/test-screen';

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  void convertJson() {}

  @override
  void initState() {
    super.initState();
    final myJson = {
      "1": {
        "id": "1",
        "title": "Alimentazione e dietetica",
        "subcategories": {
          "10": {"id_subcategory": "10", "title": "EDULCORANTI"},
          "11": {"id_subcategory": "11", "title": "ALIMENTI (ALTRI)"},
          "114": {"id_subcategory": "114", "title": "DIETETICI"},
          "118": {"id_subcategory": "118", "title": "PASTA (ALTRE)"},
          "137": {"id_subcategory": "137", "title": "ALIMENTI NATURALI"},
          "231": {
            "id_subcategory": "231",
            "title": "MIELE/MARMELLATE/PROPOLI/PAPPA REALE"
          },
          "238": {
            "id_subcategory": "238",
            "title": "ALIMENTI PER LA PRIMA INFANZIA"
          },
          "275": {"id_subcategory": "275", "title": "BISCOTTI/MERENDINE"},
          "321": {"id_subcategory": "321", "title": "CARAMELLE"},
          "347": {"id_subcategory": "347", "title": "EDULCORANTI NATURALI"},
          "348": {"id_subcategory": "348", "title": "EDULCORANTI SINTETICI"}
        }
      },
      "2": {
        "id": "2",
        "title": "Igiene e cosmesi",
        "subcategories": {
          "12": {"id_subcategory": "12", "title": "CAPELLI"},
          "13": {
            "id_subcategory": "13",
            "title": "IGIENE E COSMESI (ALTRI ACCESSORI PER)"
          },
          "14": {"id_subcategory": "14", "title": "BOCCA E DENTI"},
          "15": {"id_subcategory": "15", "title": "CORPO"},
          "16": {
            "id_subcategory": "16",
            "title": "IGIENE E COSMESI (CONFEZIONI REGALO)"
          },
          "17": {"id_subcategory": "17", "title": "MANI E PIEDI"},
          "18": {"id_subcategory": "18", "title": "VISO"},
          "107": {
            "id_subcategory": "107",
            "title": "SOLARI/DOPOSOLE PER IL CORPO"
          },
          "111": {"id_subcategory": "111", "title": "SHAMPOO"},
          "112": {
            "id_subcategory": "112",
            "title": "DEODORANTI CORPO/ANTITRASPIRANTI"
          },
          "113": {"id_subcategory": "113", "title": "PELLE DEL VISO"},
          "115": {"id_subcategory": "115", "title": "DENTIFRICI/SBIANCANTI"},
          "121": {"id_subcategory": "121", "title": "CORPO (TRATTAMENTI PER)"},
          "124": {
            "id_subcategory": "124",
            "title": "MANI E PIEDI (ACCESSORI PER L'IGIENE E LA COSMESI)"
          },
          "128": {
            "id_subcategory": "128",
            "title": "PROTESI DENTARIA (PRODOTTI E ACCESSORI PER)"
          },
          "130": {"id_subcategory": "130", "title": "COLLUTORI/GENGIVARI"},
          "135": {
            "id_subcategory": "135",
            "title": "PROFUMI/ACQUE DI COLONIA PER IL CORPO"
          },
          "138": {"id_subcategory": "138", "title": "PIEDI (TRATTAMENTI PER)"},
          "144": {
            "id_subcategory": "144",
            "title": "CORPO (ALTRI PRODOTTI PER)"
          },
          "149": {"id_subcategory": "149", "title": "BAGNO-DOCCIA"},
          "154": {"id_subcategory": "154", "title": "MANI (TRATTAMENTI PER)"},
          "168": {"id_subcategory": "168", "title": "SMALTI/SOLVENTI"},
          "189": {
            "id_subcategory": "189",
            "title": "CAPELLI (TRATTAMENTI PER)"
          },
          "205": {"id_subcategory": "205", "title": "IGIENE INTIMA"},
          "206": {"id_subcategory": "206", "title": "UNGHIE (TRATTAMENTI PER)"},
          "221": {"id_subcategory": "221", "title": "NASO"},
          "252": {
            "id_subcategory": "252",
            "title": "APPARECCHI ORTODONTICI (PRODOTTI E ACCESSORI PER)"
          },
          "256": {
            "id_subcategory": "256",
            "title": "BOCCA E DENTI (ALTRI PRODOTTI PER)"
          },
          "279": {"id_subcategory": "279", "title": "ORECCHIE"},
          "282": {"id_subcategory": "282", "title": "TALCHI"},
          "295": {
            "id_subcategory": "295",
            "title": "BOCCA E DENTI (ACCESSORI PER L'IGIENE)"
          },
          "322": {
            "id_subcategory": "322",
            "title": "AUTOABBRONZANTI PER IL CORPO"
          },
          "344": {"id_subcategory": "344", "title": "DEODORANTI ALITO"},
          "368": {
            "id_subcategory": "368",
            "title": "CAPELLI (ACCESSORI PER IGIENE E COSMESI)"
          }
        }
      },
      "3": {
        "id": "3",
        "title": "Articoli sanitari e dispositivi medici",
        "subcategories": {
          "19": {"id_subcategory": "19", "title": "DIAGNOSTICI"},
          "20": {
            "id_subcategory": "20",
            "title": "ARTICOLI SANITARI PER CASA E AMBIENTE"
          },
          "21": {
            "id_subcategory": "21",
            "title": "DISPOSITIVI PER SOMMINISTRAZIONE DI SOSTANZE TERAPEUTICHE"
          },
          "22": {
            "id_subcategory": "22",
            "title": "STRUMENTI PER AUTODIFESA NON IDONEI AD ARRECARE OFFESA"
          },
          "23": {
            "id_subcategory": "23",
            "title": "STRUMENTI E ACCESSORI IGIENICO-SANITARI"
          },
          "24": {
            "id_subcategory": "24",
            "title": "MEDICAZIONE (STRUMENTI E MATERIALE PER)"
          },
          "25": {"id_subcategory": "25", "title": "APPARECCHIATURE"},
          "26": {"id_subcategory": "26", "title": "CASA E AMBIENTE"},
          "27": {"id_subcategory": "27", "title": "PUERICULTURA ED INFANZIA"},
          "28": {
            "id_subcategory": "28",
            "title": "ORTOPEDIA E COMFORT PER LA PERSONA"
          },
          "29": {
            "id_subcategory": "29",
            "title": "CONTRACCEZIONE E PROFILASSI"
          },
          "30": {"id_subcategory": "30", "title": "OCCHIALI/LENTI E ACCESSORI"},
          "31": {
            "id_subcategory": "31",
            "title": "PRODOTTI PER LA PROTEZIONE DEGLI APPARATI"
          },
          "32": {"id_subcategory": "32", "title": "STRUMENTI SANITARI (ALTRI)"},
          "33": {"id_subcategory": "33", "title": "AUSILI PER L'UDITO"},
          "34": {
            "id_subcategory": "34",
            "title": "SERVIZI DI ASSISTENZA DOMICILIARE"
          },
          "35": {"id_subcategory": "35", "title": "SERVIZI PRESSO L'ESERCIZIO"},
          "36": {"id_subcategory": "36", "title": "PRODOTTI ANTIFUMO"},
          "37": {"id_subcategory": "37", "title": "DISPOSITIVI DI PROTEZIONE"},
          "38": {
            "id_subcategory": "38",
            "title": "BIOCIDI/PRESIDI MEDICO-CHIRURGICI"
          },
          "116": {
            "id_subcategory": "116",
            "title": "MEDICAZIONE (MATERIALE PER)"
          },
          "123": {
            "id_subcategory": "123",
            "title": "PRODOTTI PER BOCCA E LABBRA"
          },
          "126": {"id_subcategory": "126", "title": "IGIENE BAMBINO"},
          "129": {"id_subcategory": "129", "title": "INCONTINENZA"},
          "131": {
            "id_subcategory": "131",
            "title": "DPI DISPOSITIVI DI PROTEZIONE INDIVIDUALE"
          },
          "134": {
            "id_subcategory": "134",
            "title": "APPARECCHIATURE AUTODIAGNOSTICHE"
          },
          "139": {
            "id_subcategory": "139",
            "title": "PRODOTTI PER OTORINOLARINGOIATRIA"
          },
          "140": {"id_subcategory": "140", "title": "STOMIA"},
          "142": {"id_subcategory": "142", "title": "ABBIGLIAMENTO"},
          "143": {"id_subcategory": "143", "title": "GIOCHI/ARTICOLI REGALO"},
          "146": {
            "id_subcategory": "146",
            "title": "APPARECCHI ACUSTICI O AUSILI PER L'UDITO (ALTRI)"
          },
          "147": {
            "id_subcategory": "147",
            "title": "PRODOTTI PER APPARATO GENITALE"
          },
          "159": {
            "id_subcategory": "159",
            "title": "ANTIALLERGICI (MATERIALI)"
          },
          "161": {
            "id_subcategory": "161",
            "title": "TEST DIAGNOSTICI: SOLUZIONI DI CONTROLLO"
          },
          "162": {
            "id_subcategory": "162",
            "title": "MEDICAZIONE (STRUMENTI PER)"
          },
          "163": {
            "id_subcategory": "163",
            "title": "DISPOSITIVI DI SOMMINISTRAZIONE PER VIA PARENTERALE"
          },
          "171": {
            "id_subcategory": "171",
            "title": "PRODOTTI PER APPARATO GASTROINTESTINALE"
          },
          "179": {
            "id_subcategory": "179",
            "title": "PRODOTTI PER OFTALMOLOGIA"
          },
          "185": {
            "id_subcategory": "185",
            "title": "PRODOTTI PER APPARATO TEGUMENTARIO"
          },
          "196": {"id_subcategory": "196", "title": "I.U.D."},
          "198": {
            "id_subcategory": "198",
            "title": "APPARECCHI ACUSTICI ESTERNI"
          },
          "199": {
            "id_subcategory": "199",
            "title": "APPARECCHI ACUSTICI ESTERNI (ACCESSORI PER)"
          },
          "218": {
            "id_subcategory": "218",
            "title": "DETERGENTI PER CASA E AMBIENTE"
          },
          "219": {"id_subcategory": "219", "title": "PER AMBIENTE"},
          "220": {"id_subcategory": "220", "title": "DISPOSITIVI MEDICALI"},
          "229": {
            "id_subcategory": "229",
            "title": "DISPOSITIVI DI SOMMINISTRAZIONE PER VIE AEREE"
          },
          "245": {
            "id_subcategory": "245",
            "title": "ARTICOLI SANITARI PER CASA E AMBIENTE (ALTRI)"
          },
          "248": {
            "id_subcategory": "248",
            "title": "ALIMENTAZIONE DEL BAMBINO (ACCESSORI PER)"
          },
          "261": {"id_subcategory": "261", "title": "EDITORIA"},
          "269": {"id_subcategory": "269", "title": "CALZATURE PER BAMBINI"},
          "273": {
            "id_subcategory": "273",
            "title": "PUERICULTURA (APPARECCHIATURE E ACCESSORI PER)"
          },
          "288": {
            "id_subcategory": "288",
            "title": "APPARECCHIATURE SANITARIE (ALTRE)"
          },
          "291": {
            "id_subcategory": "291",
            "title": "COMFORT DELLA PERSONA (ALTRI PRODOTTI PER)"
          },
          "292": {
            "id_subcategory": "292",
            "title": "ARTICOLI SANITARI E DISPOSITIVI MEDICI"
          },
          "293": {"id_subcategory": "293", "title": "ANTIDECUBITO"},
          "297": {"id_subcategory": "297", "title": "PRODOTTI PER ORTOPEDIA"},
          "299": {
            "id_subcategory": "299",
            "title": "ATTREZZATURE E MATERIALI PER LABORATORIO"
          },
          "305": {
            "id_subcategory": "305",
            "title": "DISPOSITIVI DI SOMMINISTRAZIONE PER VIA RETTALE"
          },
          "307": {
            "id_subcategory": "307",
            "title": "CONTRACCEZIONE E PROFILASSI (ALTRI PRODOTTI PER)"
          },
          "309": {"id_subcategory": "309", "title": "ARREDAMENTI PER FARMACIA"},
          "312": {
            "id_subcategory": "312",
            "title": "CONTENITORI PER TEST CLINICI"
          },
          "319": {
            "id_subcategory": "319",
            "title": "DEODORANTI/BALSAMICI PER CASA E AMBIENTE"
          },
          "320": {
            "id_subcategory": "320",
            "title": "AMBIENTE (APPARECCHIATURE PER)"
          },
          "324": {"id_subcategory": "324", "title": "LENTI A CONTATTO"},
          "335": {
            "id_subcategory": "335",
            "title": "DISPOSITIVI DI SOMMINISTRAZIONE PER VIA VAGINALE"
          },
          "349": {
            "id_subcategory": "349",
            "title": "SICUREZZA/PASSEGGIO/ARREDAMENTO"
          },
          "356": {
            "id_subcategory": "356",
            "title": "FISIOTERAPIA/MASSOTERAPIA"
          },
          "357": {
            "id_subcategory": "357",
            "title": "TERAPIA TERMICA/A RAGGI U.V.A./I.R."
          }
        }
      },
      "4": {
        "id": "4",
        "title": "Veterinaria",
        "subcategories": {
          "39": {"id_subcategory": "39", "title": "MEDICINALI VETERINARI"},
          "40": {"id_subcategory": "40", "title": "OMEOPATICI VETERINARI"},
          "41": {
            "id_subcategory": "41",
            "title": "ALIMENTAZIONE E DIETETICA VETERINARIA"
          },
          "42": {"id_subcategory": "42", "title": "TOELETTATURA"},
          "43": {"id_subcategory": "43", "title": "ANTIPARASSITARI VETERINARI"},
          "44": {
            "id_subcategory": "44",
            "title": "DIAGNOSTICI USO VETERINARIO"
          },
          "45": {
            "id_subcategory": "45",
            "title": "MEDICAZIONE USO VETERINARIO (STRUMENTI E MATERIALE PER)"
          },
          "46": {"id_subcategory": "46", "title": "ANIMALI (ACCESSORI PER)"},
          "47": {
            "id_subcategory": "47",
            "title": "DISINFETTANTI E PRODOTTI PER L'AMBIENTE USO VETERINARIO"
          },
          "48": {
            "id_subcategory": "48",
            "title": "ANIMALI (ALTRI PRODOTTI PER)"
          },
          "49": {
            "id_subcategory": "49",
            "title": "DPI DISPOSITIVO DI PROTEZIONE INDIVIDUALE USO VETERINARIO"
          },
          "141": {
            "id_subcategory": "141",
            "title": "ALIMENTI DIETETICI PER ANIMALI"
          },
          "192": {
            "id_subcategory": "192",
            "title": "TOELETTATURA (PRODOTTI PER)"
          },
          "290": {
            "id_subcategory": "290",
            "title": "MEDICAZIONE USO VETERINARIO (MATERIALE PER)"
          },
          "328": {
            "id_subcategory": "328",
            "title": "REPELLENTI AMBIENTE USO VETERINARIO"
          },
          "342": {
            "id_subcategory": "342",
            "title": "MEDICAZIONE USO VETERINARIO (STRUMENTI PER)"
          },
          "353": {
            "id_subcategory": "353",
            "title": "ALIMENTI VETERINARI (ALTRI)"
          }
        }
      },
      "5": {
        "id": "5",
        "title": "Erboristeria e fitoterapia",
        "subcategories": {
          "50": {
            "id_subcategory": "50",
            "title": "FORMULAZIONI FITOTERAPICHE PRONTE"
          },
          "51": {"id_subcategory": "51", "title": "PRODOTTI NATURALI"},
          "52": {"id_subcategory": "52", "title": "PRODOTTI BIOLOGICI"},
          "53": {"id_subcategory": "53", "title": "DROGHE VEGETALI"},
          "54": {"id_subcategory": "54", "title": "ESTRATTI VEGETALI"},
          "108": {
            "id_subcategory": "108",
            "title": "ESTRATTI VEGETALI FLUIDI/MOLLI/PASTOSI/SECCHI"
          },
          "120": {"id_subcategory": "120", "title": "TINTURE MADRI"},
          "148": {
            "id_subcategory": "148",
            "title": "OLII ESSENZIALI/ETEREI/AROMATICI/MEDICAMENTOSI/ESSENZE"
          },
          "167": {"id_subcategory": "167", "title": "MACERATI GLICERICI"},
          "172": {
            "id_subcategory": "172",
            "title": "ESTRATTI VEGETALI (ALTRI)"
          },
          "188": {
            "id_subcategory": "188",
            "title": "IDROLATI/ACQUE AROMATICHE"
          },
          "243": {
            "id_subcategory": "243",
            "title": "FORMULAZIONI FITOTERAPICHE PRONTE LIQUIDE PER OS"
          },
          "259": {
            "id_subcategory": "259",
            "title": "FORMULAZIONI FITOTERAPICHE PRONTE SOLIDE PER OS"
          },
          "276": {"id_subcategory": "276", "title": "DROGHE VEGETALI INTERE"},
          "285": {
            "id_subcategory": "285",
            "title": "FORMULAZIONI FITOTERAPICHE PRONTE PER USO LOCALE"
          },
          "286": {
            "id_subcategory": "286",
            "title": "FORMULAZIONI FITOTERAPICHE PRONTE (ALTRE)"
          },
          "287": {
            "id_subcategory": "287",
            "title": "COSMESI NATURALE E BIOCOSMESI"
          },
          "329": {
            "id_subcategory": "329",
            "title": "DROGHE VEGETALI PARCELLIZZATE"
          },
          "336": {
            "id_subcategory": "336",
            "title": "VINI MEDICAMENTOSI/LIQUORI/AMARI"
          },
          "343": {"id_subcategory": "343", "title": "SUCCHI/POLPE VEGETALI"}
        }
      },
      "6": {
        "id": "6",
        "title": "Omeopatia e medicina naturale",
        "subcategories": {
          "55": {"id_subcategory": "55", "title": "UNITARI OMEOPATICI"},
          "56": {"id_subcategory": "56", "title": "ORGANOTERAPIA"},
          "57": {"id_subcategory": "57", "title": "COMPLESSI OMEOBIOTERAPICI"},
          "58": {"id_subcategory": "58", "title": "NOSODOTERAPIA"},
          "59": {"id_subcategory": "59", "title": "OLIGOTERAPIA"},
          "60": {"id_subcategory": "60", "title": "SALI DI SCHUESSLER"},
          "61": {"id_subcategory": "61", "title": "FLORITERAPIA"},
          "62": {"id_subcategory": "62", "title": "OMEOBIOTERAPICI"},
          "63": {"id_subcategory": "63", "title": "LITOTERAPIA"},
          "109": {"id_subcategory": "109", "title": "DILUIZIONI KORSAKOVIANE"},
          "110": {"id_subcategory": "110", "title": "DILUIZIONI HAHNEMANNIANE"},
          "145": {"id_subcategory": "145", "title": "FLORITERAPIA (ALTRE)"},
          "184": {
            "id_subcategory": "184",
            "title": "DILUIZIONI 50-MILLESIMALI"
          },
          "203": {"id_subcategory": "203", "title": "FIORI DI BACH"},
          "224": {"id_subcategory": "224", "title": "CURE (OMEOPATIA)"}
        }
      },
      "7": {
        "id": "7",
        "title": "Alimenti senza glutine",
        "subcategories": {
          "64": {"id_subcategory": "64", "title": "PANE SENZA GLUTINE"},
          "65": {"id_subcategory": "65", "title": "PASTA SENZA GLUTINE"},
          "66": {"id_subcategory": "66", "title": "FARINE SENZA GLUTINE"},
          "67": {"id_subcategory": "67", "title": "BISCOTTI SENZA GLUTINE"},
          "68": {
            "id_subcategory": "68",
            "title": "ALIMENTI SENZA GLUTINE E APROTEICI"
          },
          "69": {"id_subcategory": "69", "title": "CRACKERS SENZA GLUTINE"},
          "70": {
            "id_subcategory": "70",
            "title": "FETTE BISCOTTATE SENZA GLUTINE"
          },
          "71": {"id_subcategory": "71", "title": "GRISSINI SENZA GLUTINE"},
          "72": {"id_subcategory": "72", "title": "MERENDINE SENZA GLUTINE"},
          "73": {"id_subcategory": "73", "title": "SALATINI SENZA GLUTINE"},
          "74": {
            "id_subcategory": "74",
            "title": "BEVANDE SENZA GLUTINE E APROTEICHE"
          },
          "75": {
            "id_subcategory": "75",
            "title": "BISCOTTI SENZA GLUTINE E APROTEICI"
          },
          "76": {
            "id_subcategory": "76",
            "title": "CRACKERS SENZA GLUTINE E APROTEICI"
          },
          "77": {
            "id_subcategory": "77",
            "title": "DOLCI SENZA GLUTINE E APROTEICI"
          },
          "78": {
            "id_subcategory": "78",
            "title": "FARINE SENZA GLUTINE E APROTEICHE"
          },
          "79": {
            "id_subcategory": "79",
            "title": "FETTE BISCOTTATE SENZA GLUTINE E APROTEICHE"
          },
          "80": {
            "id_subcategory": "80",
            "title": "GRISSINI SENZA GLUTINE E APROTEICI"
          },
          "81": {
            "id_subcategory": "81",
            "title": "MERENDINE SENZA GLUTINE E APROTEICHE"
          },
          "82": {
            "id_subcategory": "82",
            "title": "PANE SENZA GLUTINE E APROTEICO"
          },
          "83": {
            "id_subcategory": "83",
            "title": "PASTA SENZA GLUTINE E APROTEICA"
          },
          "84": {
            "id_subcategory": "84",
            "title": "SALATINI SENZA GLUTINE E APROTEICI"
          },
          "85": {
            "id_subcategory": "85",
            "title": "SOSTITUTI DEL PANE SENZA GLUTINE E APROTEICI"
          },
          "86": {
            "id_subcategory": "86",
            "title": "ALIMENTI SENZA GLUTINE (ALTRI)"
          }
        }
      },
      "8": {
        "id": "8",
        "title": "Farmaci da banco",
        "subcategories": {
          "87": {
            "id_subcategory": "87",
            "title": "APPARATO GASTROINTESTINALE E METABOLISMO"
          },
          "88": {
            "id_subcategory": "88",
            "title": "SANGUE ED ORGANI EMOPOIETICI"
          },
          "89": {
            "id_subcategory": "89",
            "title":
                "PREPARATI ORMONALI SISTEMICI,ESCL.ORMONI SESSUALI E INSULINE"
          },
          "90": {"id_subcategory": "90", "title": "SISTEMA CARDIOVASCOLARE"},
          "91": {"id_subcategory": "91", "title": "DERMATOLOGICI"},
          "92": {
            "id_subcategory": "92",
            "title": "SISTEMA GENITO-URINARIO ED ORMONI SESSUALI"
          },
          "93": {"id_subcategory": "93", "title": "IMMUNOLOGICI"},
          "94": {
            "id_subcategory": "94",
            "title": "ANTIMICROBICI GENERALI PER USO SISTEMICO"
          },
          "95": {
            "id_subcategory": "95",
            "title": "SISTEMA MUSCOLO-SCHELETRICO"
          },
          "96": {
            "id_subcategory": "96",
            "title": "FARMACI ANTIPARASSITARI, INSETTICIDI E REPELLENTI"
          },
          "97": {
            "id_subcategory": "97",
            "title": "FARMACI ANTINEOPLASTICI ED IMMUNOMODULATORI"
          },
          "98": {"id_subcategory": "98", "title": "SISTEMA NERVOSO"},
          "99": {"id_subcategory": "99", "title": "ORGANI DI SENSO"},
          "100": {"id_subcategory": "100", "title": "SISTEMA RESPIRATORIO"}
        }
      }
    };
    final prova = myJson.toList((e) => e.value['subcategories']);
    print(prova[0]);
  }

  final ApisNew _apisNew = ApisNew();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}
