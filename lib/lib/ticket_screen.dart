import 'dart:io';

import 'package:bloc_firestore/bloc/ticket_bloc.dart';
import 'package:bloc_firestore/ticket_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';

class TicketScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final TicketBloc ticketBloc = BlocProvider.of<TicketBloc>(context);

    TextEditingController descController = new TextEditingController();
    TextEditingController titleController = new TextEditingController();

    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) {
        if (state is TicketCreatedState) {
          return const Text('Ticket Created!');
        } else {
          descController.text = '';
          titleController.text = '';
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Ticket System'),
              leading: IconButton(onPressed: (){
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                } else {
                  scaffoldKey.currentState!.openDrawer();
                }
              }, icon: const Icon(Icons.menu)),
            ),
            body: Column(
              children: [
                Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                                hintText: 'Ticket Title'
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty) {
                                return 'Please enter ticket title';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: descController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                                hintText: 'Ticket Desc'
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty) {
                                return 'Please enter ticket description';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )),
                // Your ticket creation form here
                ElevatedButton(
                  onPressed: () async {
                    Position locationData = await _getLocation();
                    ticketBloc.add(CreateTicketEvent(
                      title: titleController.text,
                      description: descController.text,
                      latitude: locationData.latitude!,
                      longitude: locationData.longitude!
                    ));
                    const snackbar = SnackBar(content: Text("Ticket Created"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TicketListPage()));
                  },
                  child: const Text('Create Ticket'),
                ),
                ElevatedButton(
                    onPressed: () {
                      print("ticket list");
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TicketListPage()));
                    },
                    child: const Text("Ticket List")
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Text('Tickets App'),
                  ),
                  ListTile(
                    title: const Text('Ticket List'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>TicketListPage()));
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Position> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      throw Exception("Location Permission denied");
    }

    Position locationData = await Geolocator.getCurrentPosition();
    return locationData;
  }

  Future<File?> _pickFile() async {
    try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if(result != null) {
          String filePath = result.files.single.path!;
          return File(filePath);
        } else {
          print("File not selected");
        }
    }catch(e) {
        print('Error picking file ${e}');
    }
  }
}