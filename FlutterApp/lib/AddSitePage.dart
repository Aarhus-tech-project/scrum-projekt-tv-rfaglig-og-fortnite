import 'package:flutter/material.dart';
import 'package:classroom_finder_app/Models/AddEditSiteDTO.dart';
import 'package:geolocator/geolocator.dart';

class Addsitepage extends StatefulWidget {
  const Addsitepage({super.key});

  @override
  State<Addsitepage> createState() => _AddsitepageState();
}

class _AddsitepageState extends State<Addsitepage> {
  AddEditSiteDTO site = AddEditSiteDTO();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200], // Soft background color
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                'Add Site',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 16),

              // Name Input Field
              buildTextField(nameController, 'Name', 'Enter Site Name'),

              SizedBox(height: 12),

              // Address Input Field
              buildTextField(emailController, 'Address', 'Enter Site Address'),

              SizedBox(height: 16),

              // Private Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Colors.black54),
                  SizedBox(width: 6),
                  Text(
                    'Private',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  SizedBox(width: 6),
                  Switch(
                    value: isPrivate,
                    onChanged: (value) {
                      setState(() {
                        isPrivate = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),

              SizedBox(height: 16),

              // USERS LIST (Only shown when private)
              if (isPrivate)
                buildListContainer(
                  title: "Members",
                  items: site.users,
                  getDisplayText: (user) => user.email,
                  onEdit: (user) {
                    showAddEditUserDialog(user);
                  },
                  buttonText: "Add Member",
                  onPressed: () {
                    showAddEditUserDialog(null);
                  },
                  color: Colors.grey,
                ),

              // ROOMS LIST
              buildListContainer(
                title: "Rooms",
                items: site.rooms,
                getDisplayText: (room) => room.name,
                onEdit: (room) {
                  showAddEditRoomDialog(room);
                },
                buttonText: "Add Room",
                onPressed: () {
                  showAddEditRoomDialog(null);
                },
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

void showAddEditUserDialog(AddEditUserSiteDTO? user) {
  TextEditingController userEmailController = TextEditingController();

  bool createNew = user == null;
  if (createNew) {
    user = AddEditUserSiteDTO();
  }

  userEmailController.text = user.email;
  UserRole selectedRole = user.role;

  userEmailController.addListener(() {
    user!.email = userEmailController.text;
  },);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(createNew ? "Add Member" : "Edit Member"),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: userEmailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: 12),
                Text('Role'),
                DropdownButton<UserRole>(
                  value: selectedRole,
                  onChanged: (UserRole? value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedRole = value;
                        user!.role = value;
                      });
                    }
                  },
                  items: UserRole.values.map((UserRole role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(role.toString().split('.').last),
                    );
                  }).toList(),
                )
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              if (userEmailController.text.isNotEmpty) {
                setState(() {
                  if (createNew) {
                    site.users.add(user!);
                  }
                });
                Navigator.of(context).pop(); // Close dialog
              }
            },
            child: Text(createNew ? "Add" : "Save"),
          ),
        ],
      );
    },
  );
}


  void showAddEditRoomDialog(AddEditRoomDTO? room) {
    TextEditingController nameController = TextEditingController();
    TextEditingController latController = TextEditingController();
    TextEditingController lonController = TextEditingController();
    TextEditingController altController = TextEditingController();
    TextEditingController levelController = TextEditingController();
    bool autoLocation = true;

    bool createNew = room == null;
    if (createNew) {
      room = AddEditRoomDTO();
    }

    nameController.text = room.name;
    latController.text = room.lat.toString();
    lonController.text = room.lon.toString();
    altController.text = room.alt.toString();
    levelController.text = room.level.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(createNew ? "Add Room" : "Edit Room"),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: levelController,
                    decoration: InputDecoration(
                      labelText: "Floor",
                      hintText: "Enter Floor",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setDialogState(() {
                            autoLocation = !autoLocation;
                          },);
                        },
                        icon: Icon(Icons.location_searching, color: autoLocation ? Colors.blue : Colors.white),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(autoLocation ? Colors.grey.shade100 : Colors.grey.shade400),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), 
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: !autoLocation,
                          controller: latController,
                          decoration: InputDecoration(
                            labelText: "Lat",
                            hintText: "Enter name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: TextField(
                          controller: lonController,
                          decoration: InputDecoration(
                            labelText: "Lon",
                            hintText: "Enter name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: TextField(
                          controller: altController,
                          decoration: InputDecoration(
                            labelText: "Alt",
                            hintText: "Enter name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget buildTextField(TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

Widget buildListContainer<T>({
  required String title,
  required List<T> items,
  required String Function(T) getDisplayText,
  required void Function(T) onEdit,
  required String buttonText,
  required VoidCallback onPressed,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          SizedBox(height: 8),

          // List of Items
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      getDisplayText(items[index]), // Extracts text from item
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => onEdit(items[index]), // Passes the item for editing
                    ),
                  ),
                ),
              );
            },
          ),

          // Add Button
          Center(
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
