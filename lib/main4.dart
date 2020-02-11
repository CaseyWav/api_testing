//to do: figure out how to edit header information

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Josh> josh;
  String firstName;
  String lastName;

  @override
  void initState() {
    super.initState();
    josh = fetchPost();
  }

  Future<Josh> fetchPost() async {
    final response = await http.get(
        'https://pennstate.pure.elsevier.com/ws/api/516/persons?size=1&apiKey=e1d6aaae-8a61-4e9e-9e1b-e94d11528b61',
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('code is 200');
      var parsedJson = json.decode(response.body);
      print(parsedJson);
      return Josh.fromJson(parsedJson);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bread acquisition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.green[200],
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<Josh>(
                  future: josh,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.getAll());
                      //print(snapshot.data.Item.ItemName.firstName);
                      print(snapshot.data.items[0].name.firstName);
                      firstName = snapshot.data.items[0].name.firstName;
                      lastName = snapshot.data.items[0].name.lastName;
                      return Column(
                        children: <Widget>[
                          Text('count is ' + snapshot.data.count.toString()),
                          Text(
                              'This person\'s name is ${firstName} ${lastName}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    josh = fetchPost();
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 200,
                      color: Colors.lightBlueAccent[700],
                      width: double.infinity,
                      child: Center(child: Text('Click me for a new josh')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Josh {
  int count;
  PageInformation pageInformation;
  List<Item> items;
  List<Link> navigationLinks;

  String getAll() {
    return count.toString() + pageInformation.toString();
  }

  Josh({
    this.count,
    this.pageInformation,
    this.items,
    this.navigationLinks,
  });

  factory Josh.fromJson(Map<String, dynamic> json) => Josh(
        count: json["count"],
        pageInformation: PageInformation.fromJson(json["pageInformation"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        navigationLinks: List<Link>.from(
            json["navigationLinks"].map((x) => Link.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "pageInformation": pageInformation.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "navigationLinks":
            List<dynamic>.from(navigationLinks.map((x) => x.toJson())),
      };
}

class Item {
  int pureId;
  String externalId;
  String externalIdSource;
  bool externallyManaged;
  String uuid;
  ItemName name;
  bool profiled;
  int scopusHIndex;
  double fte;
  //YOU HAVE TO CHANGE FT TO TYPE DOUBLE
  Info info;
  Visibility visibility;
  List<Id> ids;
  List<StaffOrganisationAssociation> staffOrganisationAssociations;

  Item({
    this.pureId,
    this.externalId,
    this.externalIdSource,
    this.externallyManaged,
    this.uuid,
    this.name,
    this.profiled,
    this.scopusHIndex,
    this.fte,
    this.info,
    this.visibility,
    this.ids,
    this.staffOrganisationAssociations,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        pureId: json["pureId"],
        externalId: json["externalId"],
        externalIdSource: json["externalIdSource"],
        externallyManaged: json["externallyManaged"],
        uuid: json["uuid"],
        name: ItemName.fromJson(json["name"]),
        profiled: json["profiled"],
        scopusHIndex: json["scopusHIndex"],
        fte: json["fte"],
        info: Info.fromJson(json["info"]),
        visibility: Visibility.fromJson(json["visibility"]),
        ids: List<Id>.from(json["ids"].map((x) => Id.fromJson(x))),
        staffOrganisationAssociations: List<StaffOrganisationAssociation>.from(
            json["staffOrganisationAssociations"]
                .map((x) => StaffOrganisationAssociation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pureId": pureId,
        "externalId": externalId,
        "externalIdSource": externalIdSource,
        "externallyManaged": externallyManaged,
        "uuid": uuid,
        "name": name.toJson(),
        "profiled": profiled,
        "scopusHIndex": scopusHIndex,
        "fte": fte,
        "info": info.toJson(),
        "visibility": visibility.toJson(),
        "ids": List<dynamic>.from(ids.map((x) => x.toJson())),
        "staffOrganisationAssociations": List<dynamic>.from(
            staffOrganisationAssociations.map((x) => x.toJson())),
      };
}

class Id {
  int pureId;
  String externalId;
  String externalIdSource;
  bool externallyManaged;
  IdValue value;
  Type type;

  Id({
    this.pureId,
    this.externalId,
    this.externalIdSource,
    this.externallyManaged,
    this.value,
    this.type,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        pureId: json["pureId"],
        externalId: json["externalId"] == null ? null : json["externalId"],
        externalIdSource:
            json["externalIdSource"] == null ? null : json["externalIdSource"],
        externallyManaged: json["externallyManaged"] == null
            ? null
            : json["externallyManaged"],
        value: IdValue.fromJson(json["value"]),
        type: Type.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "pureId": pureId,
        "externalId": externalId == null ? null : externalId,
        "externalIdSource": externalIdSource == null ? null : externalIdSource,
        "externallyManaged":
            externallyManaged == null ? null : externallyManaged,
        "value": value.toJson(),
        "type": type.toJson(),
      };
}

class Type {
  int pureId;
  String uri;
  JobDescriptionClass term;

  Type({
    this.pureId,
    this.uri,
    this.term,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        pureId: json["pureId"],
        uri: json["uri"],
        term: JobDescriptionClass.fromJson(json["term"]),
      );

  Map<String, dynamic> toJson() => {
        "pureId": pureId,
        "uri": uri,
        "term": term.toJson(),
      };
}

class JobDescriptionClass {
  bool formatted;
  List<ValueText> text;

  JobDescriptionClass({
    this.formatted,
    this.text,
  });

  factory JobDescriptionClass.fromJson(Map<String, dynamic> json) =>
      JobDescriptionClass(
        formatted: json["formatted"],
        text: List<ValueText>.from(
            json["text"].map((x) => ValueText.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "formatted": formatted,
        "text": List<dynamic>.from(text.map((x) => x.toJson())),
      };
}

class ValueText {
  String locale;
  String value;

  ValueText({
    this.locale,
    this.value,
  });

  factory ValueText.fromJson(Map<String, dynamic> json) => ValueText(
        locale: json["locale"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "locale": locale,
        "value": value,
      };
}

class IdValue {
  bool formatted;
  String value;

  IdValue({
    this.formatted,
    this.value,
  });

  factory IdValue.fromJson(Map<String, dynamic> json) => IdValue(
        formatted: json["formatted"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "formatted": formatted,
        "value": value,
      };
}

class Info {
  String createdBy;
  String createdDate;
  String modifiedBy;
  String modifiedDate;
  String portalUrl;
  List<String> prettyUrlIdentifiers;

  Info({
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.portalUrl,
    this.prettyUrlIdentifiers,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        createdBy: json["createdBy"],
        createdDate: json["createdDate"],
        modifiedBy: json["modifiedBy"],
        modifiedDate: json["modifiedDate"],
        portalUrl: json["portalUrl"],
        prettyUrlIdentifiers:
            List<String>.from(json["prettyURLIdentifiers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "createdDate": createdDate,
        "modifiedBy": modifiedBy,
        "modifiedDate": modifiedDate,
        "portalUrl": portalUrl,
        "prettyURLIdentifiers":
            List<dynamic>.from(prettyUrlIdentifiers.map((x) => x)),
      };
}

class ItemName {
  String firstName;
  String lastName;

  ItemName({
    this.firstName,
    this.lastName,
  });

  factory ItemName.fromJson(Map<String, dynamic> json) => ItemName(
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}

class StaffOrganisationAssociation {
  int pureId;
  String externalId;
  String externalIdSource;
  bool externallyManaged;
  Person person;
  Period period;
  bool isPrimaryAssociation;
  Type employmentType;
  OrganisationalUnit organisationalUnit;
  Type staffType;
  JobDescriptionClass jobDescription;
  List<Id> emails;

  StaffOrganisationAssociation({
    this.pureId,
    this.externalId,
    this.externalIdSource,
    this.externallyManaged,
    this.person,
    this.period,
    this.isPrimaryAssociation,
    this.employmentType,
    this.organisationalUnit,
    this.staffType,
    this.jobDescription,
    this.emails,
  });

  factory StaffOrganisationAssociation.fromJson(Map<String, dynamic> json) =>
      StaffOrganisationAssociation(
        pureId: json["pureId"],
        externalId: json["externalId"],
        externalIdSource: json["externalIdSource"],
        externallyManaged: json["externallyManaged"],
        person: Person.fromJson(json["person"]),
        period: Period.fromJson(json["period"]),
        isPrimaryAssociation: json["isPrimaryAssociation"],
        employmentType: Type.fromJson(json["employmentType"]),
        organisationalUnit:
            OrganisationalUnit.fromJson(json["organisationalUnit"]),
        staffType: Type.fromJson(json["staffType"]),
        jobDescription: JobDescriptionClass.fromJson(json["jobDescription"]),
        emails: List<Id>.from(json["emails"].map((x) => Id.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pureId": pureId,
        "externalId": externalId,
        "externalIdSource": externalIdSource,
        "externallyManaged": externallyManaged,
        "person": person.toJson(),
        "period": period.toJson(),
        "isPrimaryAssociation": isPrimaryAssociation,
        "employmentType": employmentType.toJson(),
        "organisationalUnit": organisationalUnit.toJson(),
        "staffType": staffType.toJson(),
        "jobDescription": jobDescription.toJson(),
        "emails": List<dynamic>.from(emails.map((x) => x.toJson())),
      };
}

class OrganisationalUnit {
  String uuid;
  Link link;
  String externalId;
  String externalIdSource;
  bool externallyManaged;
  JobDescriptionClass name;
  Type type;

  OrganisationalUnit({
    this.uuid,
    this.link,
    this.externalId,
    this.externalIdSource,
    this.externallyManaged,
    this.name,
    this.type,
  });

  factory OrganisationalUnit.fromJson(Map<String, dynamic> json) =>
      OrganisationalUnit(
        uuid: json["uuid"],
        link: Link.fromJson(json["link"]),
        externalId: json["externalId"],
        externalIdSource: json["externalIdSource"],
        externallyManaged: json["externallyManaged"],
        name: JobDescriptionClass.fromJson(json["name"]),
        type: Type.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "link": link.toJson(),
        "externalId": externalId,
        "externalIdSource": externalIdSource,
        "externallyManaged": externallyManaged,
        "name": name.toJson(),
        "type": type.toJson(),
      };
}

class Link {
  String ref;
  String href;

  Link({
    this.ref,
    this.href,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        ref: json["ref"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "ref": ref,
        "href": href,
      };
}

class Period {
  String startDate;

  Period({
    this.startDate,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
        startDate: json["startDate"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate,
      };
}

class Person {
  String uuid;
  Link link;
  String externalId;
  String externalIdSource;
  bool externallyManaged;
  PersonName name;

  Person({
    this.uuid,
    this.link,
    this.externalId,
    this.externalIdSource,
    this.externallyManaged,
    this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        uuid: json["uuid"],
        link: Link.fromJson(json["link"]),
        externalId: json["externalId"],
        externalIdSource: json["externalIdSource"],
        externallyManaged: json["externallyManaged"],
        name: PersonName.fromJson(json["name"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "link": link.toJson(),
        "externalId": externalId,
        "externalIdSource": externalIdSource,
        "externallyManaged": externallyManaged,
        "name": name.toJson(),
      };
}

class PersonName {
  bool formatted;
  List<PurpleText> text;

  PersonName({
    this.formatted,
    this.text,
  });

  factory PersonName.fromJson(Map<String, dynamic> json) => PersonName(
        formatted: json["formatted"],
        text: List<PurpleText>.from(
            json["text"].map((x) => PurpleText.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "formatted": formatted,
        "text": List<dynamic>.from(text.map((x) => x.toJson())),
      };
}

class PurpleText {
  String value;

  PurpleText({
    this.value,
  });

  factory PurpleText.fromJson(Map<String, dynamic> json) => PurpleText(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}

class Visibility {
  String key;
  JobDescriptionClass value;

  Visibility({
    this.key,
    this.value,
  });

  factory Visibility.fromJson(Map<String, dynamic> json) => Visibility(
        key: json["key"],
        value: JobDescriptionClass.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value.toJson(),
      };
}

class PageInformation {
  int offset;
  int size;

  PageInformation({
    this.offset,
    this.size,
  });

  factory PageInformation.fromJson(Map<String, dynamic> json) =>
      PageInformation(
        offset: json["offset"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "size": size,
      };
}
