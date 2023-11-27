import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_firestore/model/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

//events and state's
part 'ticket_event.dart';
part 'ticket_state.dart';


//bloc
class TicketBloc extends Bloc<TicketEvent,TicketState> {
  TicketBloc() : super(TicketInitialState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<TicketState> mapEventToState(TicketEvent event) async* {
    if(event is CreateTicketEvent) {
      try {
        final Ticket newTicket = await _createTicketInFirebase(
            title: event.title,
            description: event.description,
            latitude: event.latitude,
            longitude: event.longitude
        );
        yield TicketCreatedState(createdTicket:newTicket);
      } catch (e) {
        yield TicketsErrorState(error: 'Failed to create ticket');
      }
    } else {
      try {
        final List<Ticket> tickets = await _fetchTicketsFromFirebase();
        yield TicketsLoadedState(tickets: tickets);
      } catch (e) {
        //yield TicketsErrorState(error: 'Failed to fetch tickets');
      }
    }
  }

  Future<Ticket> _createTicketInFirebase({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
  }) async {

    final DocumentReference<Map<String, dynamic>> docRef =
    await _firestore.collection('tickets').add({
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude':longitude
    });

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await docRef.get();

    return Ticket(
      id: snapshot.id,
      title: snapshot['title'] as String,
      description: snapshot['description'] as String,
      latitude: snapshot['latitude'] as double,
      longitude: snapshot['longitude'] as double
    );
  }


  Future<List<Ticket>> _fetchTicketsFromFirebase() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('tickets').get();
    return snapshot.docs
        .map((doc) => Ticket(
        id: doc.id,
        title: doc['title'] as String,
        description: doc['description'] as String,
        latitude: doc['latitude'] as double,
        longitude: doc['longitude'] as double
    )).toList();
  }
}