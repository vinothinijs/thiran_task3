import 'package:bloc/bloc.dart';
import 'package:bloc_firestore/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

//events
abstract class TicketEvent extends Equatable{}

class CreateTicketEvent extends TicketEvent {
  final String title;
  final String description;

  CreateTicketEvent({required this.title,required this.description});

  @override
  List<Object?> get props => [title,description];
}

class FetchTicketsEvent extends TicketEvent {
  @override
  List<Object?> get props => [];
}

//state's
abstract class TicketState extends Equatable{}

class TicketInitialState extends TicketState {
  @override
  List<Object?> get props => [];
}

class TicketCreatedState extends TicketState {
  final Ticket createdTicket;

  TicketCreatedState({required this.createdTicket});

  @override
  List<Object?> get props => [];
}

class TicketsLoadingState extends TicketState {
  @override
  List<Object?> get props => [];
}

class TicketsLoadedState extends TicketState {
  final List<Ticket> tickets;

  TicketsLoadedState({required this.tickets});

  @override
  List<Object?> get props => [];
}

class TicketsErrorState extends TicketState {
  final String error;

  TicketsErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

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
          description: event.description
        );
        yield TicketCreatedState(createdTicket:newTicket);
      } catch (e) {
        yield TicketsErrorState(error: 'Failed to create ticket');
      }
    } else {
      //yield TicketLoadingState();
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
    required String description
  }) async {
    final DocumentReference<Map<String, dynamic>> docRef =
    await _firestore.collection('tickets').add({
      'title': title,
      'description': description
    });

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
    await docRef.get();

    return Ticket(
      id: snapshot.id,
      title: snapshot['title'] as String,
      description: snapshot['description'] as String
    );
  }


  Future<List<Ticket>> _fetchTicketsFromFirebase() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('tickets').get();
    return snapshot.docs
        .map((doc) => Ticket(
      id: doc.id,
      title: doc['title'] as String,
      description: doc['description'] as String
    )).toList();
  }
 }