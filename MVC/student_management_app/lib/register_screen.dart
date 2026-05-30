import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController(); // Dùng nhập text dạng YYYY-MM-DD cho lẹ

  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // NHỚ ĐỔI SỐ CỔNG CHỖ NÀY GIỐNG BÊN MÀN HÌNH ĐĂNG NHẬP NHA BRO
        final response = await http.post(
          Uri.parse('https://10.0.2.2:7018/api/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'FullName': _fullNameController.text,
            'Username': _usernameController.text,
            'Password': _passwordController.text,
            'PhoneNumber': _phoneController.text,
            'Address': _addressController.text,
            'Email': _emailController.text,
            'DateOfBirth': _dobController.text.isEmpty ? "2000-01-01" : _dobController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tạo tài khoản thành công!")),
          );
          Navigator.pop(context); // Đẩy về lại trang Login
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi: Tên đăng nhập hoặc Email đã tồn tại!")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng Ký Tài Khoản", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Thông tin sinh viên", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                      SizedBox(height: 16.0),

                      _buildTextField(_fullNameController, "Họ và Tên", Icons.badge),
                      SizedBox(height: 12.0),
                      _buildTextField(_usernameController, "Tên đăng nhập", Icons.person),
                      SizedBox(height: 12.0),
                      _buildTextField(_passwordController, "Mật khẩu", Icons.lock, isPassword: true),
                      SizedBox(height: 12.0),
                      _buildTextField(_phoneController, "Số điện thoại", Icons.phone),
                      SizedBox(height: 12.0),
                      _buildTextField(_emailController, "Email", Icons.email),
                      SizedBox(height: 12.0),
                      _buildTextField(_addressController, "Địa chỉ", Icons.location_on),
                      SizedBox(height: 12.0),
                      _buildTextField(_dobController, "Ngày sinh (VD: 2004-01-19)", Icons.calendar_today),

                      SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("ĐĂNG KÝ", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hàm tạo ô nhập liệu cho code đỡ dài
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade800),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      validator: (value) => value!.isEmpty ? "Vui lòng nhập $label" : null,
    );
  }
}