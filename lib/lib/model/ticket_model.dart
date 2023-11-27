class Ticket {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String? attachment;

  Ticket ({required this.id,required this.title,required this.description,required this.latitude,required this.longitude,this.attachment});
}