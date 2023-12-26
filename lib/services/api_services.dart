import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notes/models/note.dart';
import 'package:notes/utils/token_storage.dart';

class ApiService {
  Future<Note> addNote({
    required Note note,
  }) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      //Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_ADD']!);
      http.Response res = await http.post(
          Uri.parse('http://192.168.1.100:5000/api/add'),
          body: note.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(seconds: 10));

      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        print(body['data']['addedNote']);
        return Note.fromMap(body['data']['addedNote']);
      } else {
        print(body['error']);
        return Note(id: '', userid: '', title: '', content: '');
      }
    } catch (e) {
      if (e is TimeoutException) {
        print('Connection timed out');
        // Handle timeout, return a blank note
        return Note(id: '', userid: '', title: '', content: '');
      } else {
        print(e.toString());
        return Note(
          id: '',
          userid: '',
          title: '',
          content: '',
        );
      }
    }
  }

  void updateNote({required Note note}) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      print(jsonEncode({
        "id": note.id,
        "title": note.title,
        "content": note.content,
      }));
      //Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_UPDATE']!);
      http.Response res =
          await http.put(Uri.parse('http://192.168.1.113:5000/api/update'),
              body: jsonEncode({
                "id": note.id,
                "title": note.title,
                "content": note.content,
              }),
              headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        print(body['message']);
      } else {
        print(body['error']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteNotes({
    required List<String?> ids,
  }) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String requestBody = '{"id": ${jsonEncode(ids)}}';
      Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_DELETE']!);
      http.Response res = await http.delete(
        requestUri,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );
      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        print(body['message']);
      } else {
        print(body['error']);
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  Future<List<Note>> fetchNotes() async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_LIST']!);
      http.Response res = await http.get(requestUri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        List<Note> notes = [];
        for (var note in body['data']['notes']) {
          notes.add(Note.fromMap(note));
        }
        return notes;
      } else {
        throw Exception('Error fetching notes');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
