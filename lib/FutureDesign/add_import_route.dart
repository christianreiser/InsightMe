import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insightme/AppIntegrations/overview_route.dart';
import 'package:insightme/FutureDesign/scaffold.dart';
import 'package:insightme/Import/import_from_json_route.dart';
import 'package:insightme/Journal/searchOrCreateAttribute.dart';
import 'package:insightme/Statistics/Functions/computeCorrelations.dart';

class AddImportRoute extends StatefulWidget {
  @override
  _AddImportRouteState createState() => _AddImportRouteState();
}

class _AddImportRouteState extends State<AddImportRoute> {
  /*
  Widget _popupMenu() {
    return PopupMenuButton<Choice>(
      onSelected: (Choice result) {
        if (result == Choice.exportDailySummaries) {
          //TODO: permission handler iOS privacy
        } else if (result == Choice.computeCorrelations) {
          ComputeCorrelations().computeCorrelations();
        } else if (result == Choice.importFromCSV) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Import()),
          );
        } else if (result == Choice.appIntegrations) {
          //TODO: app integrations
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppIntegrationsOverview()),
          );
        } else if (result == Choice.deleteAllData) {
          //TODO: delete all data
        }

        setState(() {
          debugPrint('result $result');
          Choice _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
        PopupMenuItem<Choice>(
          value: Choice.computeCorrelations,
          child: Row(
            children: [
              Icon(
                Icons.compare_arrows,
                //color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Compute correlations'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.appIntegrations,
          child: Row(
            children: [
              Icon(
                Icons.exit_to_app,
                //color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Other app integrations'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.exportDailySummaries,
          child: Row(
            children: [
              Icon(
                Icons.file_upload,
                //color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Export daily summaries'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.importFromCSV,
          child: Row(
            children: [
              Icon(
                Icons.file_download,
                //color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Import data from file'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.deleteAllData,
          child: Row(
            children: [
              Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text('Delete all data'),
            ],
          ),
        ),
        PopupMenuItem<Choice>(
          value: Choice.tmpFunction,
          child: Row(
            children: [
              Icon(
                Icons.directions_run,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Text('tmpFunction'),
            ],
          ),
        ),
      ],
    );
  }
   */

  void handleClick(String value) {
    switch (value) {
      case 'Get data from app':
        break;
      case 'Get from local file':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white,
        leading: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () {
                //TODO
              },
              child: Icon(
                Icons.create_new_folder_outlined,
                color: Colors.black,
              ),
            )),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  //TODO
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: PopupMenuButton<String>(
                onSelected: handleClick,
                icon: Icon(Icons.more_vert, color: Colors.black),
                itemBuilder: (BuildContext context) {
                  return {'Get data from app', 'Get from local file'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )),
        ],
      ),
      body: Center(
        child: GridView.extent(
          primary: false,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          maxCrossAxisExtent: 200.0,
          children: <Widget>[
            Card(
              elevation: 5,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 130),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Container(
                            width: 25,
                            height: 25,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert_outlined),
                              iconSize: 18,
                              onPressed: () {
                                //TODO
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Center(
                        child: Image.asset(
                            'assets/route_icons/folder_colored.png',
                            height: 50,
                            width: 50)),
                    SizedBox(height: 20),
                    Center(
                      child: Text('Emotion',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: Text('3 items', style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 130),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Container(
                            width: 25,
                            height: 25,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert_outlined),
                              iconSize: 18,
                              onPressed: () {
                                //TODO
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Center(
                        child: Image.asset(
                            'assets/route_icons/folder_colored.png',
                            height: 50,
                            width: 50)),
                    SizedBox(height: 20),
                    Center(
                      child: Text('Health',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: Text('10 items', style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 130),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Container(
                            width: 25,
                            height: 25,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert_outlined),
                              iconSize: 18,
                              onPressed: () {
                                //TODO
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Center(
                        child: Image.asset(
                            'assets/route_icons/folder_colored.png',
                            height: 50,
                            width: 50)),
                    SizedBox(height: 20),
                    Center(
                      child: Text('Activity',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: Text('10 items', style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => Container(
                color: Colors.black.withOpacity(.7),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                  child: SearchOrCreateAttribute(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
