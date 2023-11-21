import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_firestore/ticket_model.dart';
import 'package:bloc_firestore/ticket_bloc.dart';

class TicketListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TicketBloc>(context).add(FetchTicketsEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket List'),
      ),
      body: BlocBuilder<TicketBloc,TicketState>(
        builder:(context,state) {
          if (state is TicketsLoadingState) {
            return _buildLoadingState();
          } else if (state is TicketsLoadedState) {
            return _buildTicketList(state.tickets);
          } else if (state is TicketsErrorState) {
            return _buildErrorState(state.error);
          } else if (state is TicketInitialState) {
            return _buildLoadingState();
          } else {
            return Container(); // Handle other states if needed
          }
        }
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return ListTile(
          title: Text(ticket.title),
          subtitle: Text(ticket.description),
          // Add more details or actions as needed
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }
}