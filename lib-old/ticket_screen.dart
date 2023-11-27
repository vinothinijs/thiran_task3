import 'package:bloc_firestore/ticket_bloc.dart';
import 'package:bloc_firestore/ticket_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

class TicketScreen extends StatelessWidget {
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
            appBar: AppBar(
              title: const Text('Ticket System'),
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
                  onPressed: () {
                    ticketBloc.add(CreateTicketEvent(
                      title: titleController.text,
                      description: descController.text,
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
          );
        }
      },
    );
  }
}