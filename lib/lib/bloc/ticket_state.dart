part of 'ticket_bloc.dart';

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