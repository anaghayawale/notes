import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:notes/models/note.dart';
import 'package:notes/utils/token_storage.dart';

class ApiService {
  String requestUri = dotenv.env['NODE_API_POST']!;

  Future<Note> addNote({
    required Note note,
  }) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      http.Response res = await http.post(Uri.parse('$requestUri/api/add'),
          body: note.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }).timeout(const Duration(seconds: 10));

      var body = jsonDecode(res.body);
      if (body['success'] == true) {
        (body['message']);
        return Note.fromMap(body['data']['addedNote']);
      } else {
        (body['error']);
        return Note(id: '', userid: '', title: '', content: '');
      }
    } catch (e) {
      if (e is TimeoutException) {
        return Note(id: '', userid: '', title: '', content: '');
      } else {
        return Note(
          id: '',
          userid: '',
          title: '',
          content: '',
        );
      }
    }
  }

  Future<bool> updateNote({required Note note}) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      http.Response res = await http.put(Uri.parse('$requestUri/api/update'),
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
      if (body['success']) {
        (body['message']);
        return true;
      } else {
        (body['error']);
        return false;
      }
    } catch (e) {
      (e.toString());
      return false;
    }
  }

  Future<bool> deleteNotes({
    required List<String?> ids,
  }) async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String requestBody = '{"id": ${jsonEncode(ids)}}';

      http.Response res = await http.delete(
        Uri.parse('$requestUri/api/delete'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );
      var body = jsonDecode(res.body);
      if (body['success']) {
        (body['message']);
        return true;
      } else {
        (body['error']);
        return false;
      }
    } catch (error) {
      ('Error occurred: $error');
      return false;
    }
  }

  Future<List<Note>> fetchNotes() async {
    try {
      String? token = await TokenStorage.retrieveToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      http.Response res = await http
          .get(Uri.parse('$requestUri/api/list'), headers: <String, String>{
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
        return [];
      }
    } catch (e) {
      (e.toString());
      return [];
    }
  }
}
