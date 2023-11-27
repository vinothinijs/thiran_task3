part of 'ticket_bloc.dart';
abstract class TicketEvent extends Equatable{}

class CreateTicketEvent extends TicketEvent {
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  CreateTicketEvent({required this.title,required this.description,required this.latitude,required this.longitude});

  @override
  List<Object?> get props => [title,description,latitude,longitude];
}

class FetchTicketsEvent extends TicketEvent {
  @override
  List<Object?> get props => [];
}