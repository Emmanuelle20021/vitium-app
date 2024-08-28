import 'package:flutter/material.dart';
import 'package:vitium/models/postulant_model.dart';
import 'package:vitium/services/postulant_service.dart';

class PostulantListScreen extends StatefulWidget {
  const PostulantListScreen({super.key});

  @override
  State<PostulantListScreen> createState() => _PostulantListScreenState();
}

class _PostulantListScreenState extends State<PostulantListScreen> {
  List<Postulant>? postulants = List.empty();

  void _getPostulants() async {
    var allPostulants = await PostulantService().getAllPostulants();
    setState(() {
      postulants = allPostulants;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPostulants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postulantes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: postulants!.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) =>
                    PostulantListCard(postulants![index]),
                itemCount: postulants?.length,
              )
            : const Center(
                child: Text('No hay postulantes'),
              ),
      ),
    );
  }
}

class PostulantListCard extends StatefulWidget {
  final Postulant _postulant;

  const PostulantListCard(this._postulant, {super.key});

  @override
  State<PostulantListCard> createState() => _PostulantListCardState();
}

class _PostulantListCardState extends State<PostulantListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget._postulant.image),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget._postulant.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget._postulant.email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _getDisabilities(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDisabilities() {
    List<Widget> disabilities = [];
    for (var disabilitie in widget._postulant.disabilities) {
      disabilities.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            disabilitie,
            style: const TextStyle(
              color: Colors.brown,
              fontSize: 8,
            ),
          ),
        ),
      );
    }
    return disabilities;
  }
}
