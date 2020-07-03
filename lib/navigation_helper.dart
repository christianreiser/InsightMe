import 'package:flutter/material.dart';
import 'package:insightme/scaffold_route.dart';

import 'Covid19/stayHealthy.dart';
import 'Database/Route/edit_attributes.dart';
import 'Database/Route/edit_entries.dart';
import 'Database/attribute.dart';
import 'Database/entry.dart';
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
      return ScaffoldRoute();
    }), (Route<dynamic> route) => false);
    return result;
  }

  // navigation for editing entry
  // function exists also in journal_route.dart but when using it from there:
  // state error
  void navigateToEditEntry(Entry entry, context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return EditEntry(entry);
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

  // navigation back to journal and refresh to show new entry
  void navigateToSearchOrCreateAttributeRoute(context) async {
    // don't use pop because it doesn't refresh the page
    // RemoveUntil is needed to remove the old outdated journal route
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (
      context,
    ) {
      return SearchOrCreateAttribute();
    }), (Route<dynamic> route) => false);
  }

  // navigation for editing entry
  void navigateToCovidStayHealthy(context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StayHealthy();
    }));
  }

}
