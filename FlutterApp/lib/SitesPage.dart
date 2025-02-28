import 'package:classroom_finder_app/AddEditSitePage.dart';
import 'package:classroom_finder_app/Models/AddEditSiteDTO.dart';
import 'package:classroom_finder_app/Models/Site.dart';
import 'package:classroom_finder_app/Services/Apiservices.dart';
import 'package:flutter/material.dart';

class SitesPage extends StatefulWidget {
  const SitesPage({super.key});

  @override
  State<SitesPage> createState() => _SitesPageState();
}

class _SitesPageState extends State<SitesPage> {
  List<Site> mySites = [];
  List<Site> nearbySites = [];

  @override
  void initState() {
    super.initState();
    updateSites();
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  updateSites() async {
    try {
      var newMySites = await ApiService.getUserSites();
      //var newNearbySites = await ApiService.getNearbySites(lat: position.latitude, lon: position.longitude);
      setState(() {
        mySites = newMySites;
        nearbySites = newMySites;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 96, 154, 253), 
          child: Icon(Icons.add, color: Colors.white,), 
          onPressed: () async {
            await Navigator.push(context,MaterialPageRoute(builder: (context) => Addsitepage()));
            updateSites();
          }
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'My Sites',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10), // Adds padding around the grid
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 4 / 3, // Slightly more balanced aspect ratio
                  ),
                  itemCount: mySites.length,
                  itemBuilder: (context, index) {
                    final site = mySites[index];

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded edges
                      elevation: 4, // Adds shadow for depth
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Site Name
                            Text(
                              site.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                                              
                            SizedBox(height: 4), // Spacing
                                              
                            // Room Count
                            Text(
                              '${site.roomCount} Room(s)',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                                              
                            Spacer(), // Pushes the menu button to the bottom
                                              
                            // Popup Menu (More actions)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: Colors.white), // Better icon
                                color: Colors.white,
                                onSelected: (value) async {
                                  if (value == "Edit") {
                                    try {
                                      AddEditSiteDTO siteData = await ApiService.GetEditSite(site.id);
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => Addsitepage(site: siteData),),);
                                      updateSites();
                                    } catch (e) {
                                      showSnackBar(e.toString(), Colors.red);
                                    }
                                  } else if (value == "Delete") {
                                    confirmDelete(context, site);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: "Edit",
                                    child: ListTile(
                                      leading: Icon(Icons.edit, color: Colors.blue),
                                      title: Text("Edit"),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "Delete",
                                    child: ListTile(
                                      leading: Icon(Icons.delete, color: Colors.red),
                                      title: Text("Delete"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              /*
              Divider(thickness: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Nearby Sites',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: nearbySites.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          nearbySites[index].name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context, Site site) async {
  bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete Site"),
      content: Text("Are you sure you want to delete ${site.name}?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // User pressed NO
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // User pressed YES
          child: Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm == true) {
    try {
      await ApiService.DeleteSite(site.id);
      showSnackBar("Successfully deleted ${site.name}", Colors.green);
      updateSites(); 
    } catch (e) {
      showSnackBar("Failed to delete: ${e.toString()}", Colors.red);
    }
  }
}
}
