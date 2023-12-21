import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notes/models/note.dart';
import 'package:notes/utils/token_storage.dart';

class ApiService {
  void addNote({
    required Note note,
  }) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_ADD']!);
      http.Response res = await http
          .post(requestUri, body: note.toJson(), headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        print(body['message']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateNote({required Note note, required String userId}) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      Note updatedNote = Note(
        id: note.id,
        userid: userId,
        title: note.title,
        content: note.content,
      );
      print(updatedNote.toJson());
      Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_UPDATE']!);
      http.Response res = await http.put(requestUri,
          body: updatedNote.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        print(body['message']);
      } else {
        print('not updated');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteNote({
    required Note note,
  }) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      Uri requestUri = Uri.parse(dotenv.env['NODE_API_POST_DELETE']!);
      http.Response res = await http
          .delete(requestUri, body: note.toJson(), headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        print(body['message']);
      }
    } catch (e) {
      print(e.toString());
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
