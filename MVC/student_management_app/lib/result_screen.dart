import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

class ResultScreen extends StatefulWidget {
  final int userId;
  final String fullName;

  ResultScreen({required this.userId, required this.fullName});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<dynamic> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      final response = await http.get(
        Uri.parse('https://10.0.2.2:7018/api/results/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _results = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        _showError("Không lấy được dữ liệu điểm!");
      }
    } catch (e) {
      _showError("Lỗi kết nối: $e");
    }
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bảng Điểm - ${widget.fullName}", style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.blue.shade800,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          // Gắn nút Đăng xuất
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blue.shade50,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _results.isEmpty
            ? Center(child: Text("Chưa có điểm môn nào", style: TextStyle(fontSize: 18)))
            : ListView.builder(
          padding: EdgeInsets.all(12.0),
          itemCount: _results.length,
          itemBuilder: (context, index) {
            var item = _results[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade800,
                  child: Text(
                    item['finalGrade'],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  item['subjectName'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text("Mã môn: ${item['subjectCode']} | ${item['semester']}"),
                    Text("Quá trình: ${item['processScore']} - Thi: ${item['examScore']}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}