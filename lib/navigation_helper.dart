import 'package:flutter/material.dart';
import 'package:insightme/Journal/journal_route.dart';

import 'Database/Route/edit_attributes.dart';
import 'Database/Route/edit_entries.dart';
import 'Database/attribute.dart';
import 'Database/entry.dart';
import 'FutureDesign/scaffold.dart';
import 'Journal/searchOrCreateAttribute.dart';

class NavigationHelper {
  // navigation back to journal and refresh to show new entry
  Future<bool> navigateToScaffoldRoute(context) async {
    // don't use pop because it doesn't refresh the page
    // RemoveUntil is needed to remove the old outdated journal route
    bool result =
        await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
      context,
    ) {
      return ScaffoldRouteDesign();
    }), (Route<dynamic> route) => false);
    return result;
  }

  // navigation back  and refresh to show new entry
  void navigateToJournalRoute(context, attributeName) async {
    // don't use pop because it doesn't refresh the page
    // RemoveUntil is needed to remove the old outdated  route
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
        context,
        ) {
      return JournalRoute(attributeName);
    }), (Route<dynamic> route) => false);
  }


  // navigation back  and refresh to show new entry
  void navigateToSearchOrCreateAttributeRoute(context) async {
    // don't use pop because it doesn't refresh the page
    // RemoveUntil is needed to remove the old outdated  route
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
        context,
        ) {
      return SearchOrCreateAttribute();
    }), (Route<dynamic> route) => false);
  }

  void navigateToEditEntry(Entry entry, context, thisIsANewEntry) async {
    /*
    * navigation to editing entry
    */
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditEntry(entry, thisIsANewEntry);
      }),
    );
  }

  // navigation for editing entry
  void navigateToEditAttribute(
      Attribute attribute, String title, context) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditAttribute(attribute, title);
    }));
  }

//  // navigation for editing entry
//  void navigateToCovidStayHealthy(context) async {
//    await Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return StayHealthy();
//    }));
//  }

  // navigation for editing entry
  void navigateToFutureDesign(
      context) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScaffoldRouteDesign();
    }));
  }
}
