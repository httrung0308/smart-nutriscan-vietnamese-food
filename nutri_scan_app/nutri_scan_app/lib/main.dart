import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NutriScanApp());
}

class NutriScanApp extends StatelessWidget {
  const NutriScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart NutriScan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true, // Áp dụng Material Design 3
      ),
      home: const ScanScreen(),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  String _foodName = "Chưa có dữ liệu";
  String _confidence = "";
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Hàm chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _foodName = "Đang chờ phân tích...";
        _confidence = "";
      });
      await _uploadImageToServer(_image!);
    }
  }

  // Hàm gửi ảnh lên Backend FastAPI
  Future<void> _uploadImageToServer(File imageFile) async {
    setState(() => _isLoading = true);

    try {
      // 🔴 LƯU Ý ĐỊA CHỈ IP: 
      // Nếu dùng máy ảo Android: 10.0.2.2
      // Nếu dùng đt thật: Điền địa chỉ IPv4 của máy tính (VD: 192.168.1.x)
      //-----
      var uri = Uri.parse("http://10.0.2.2:8001/predict");
      // var uri = Uri.parse("http://127.0.0.1:8000/predict");
      
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResult = json.decode(responseData);

      if (response.statusCode == 200) {
        setState(() {
          _foodName = jsonResult['food'].toString().toUpperCase();
          _confidence = "Độ tự tin: ${jsonResult['confidence']}";
        });
      } else {
        // THAY ĐỔI Ở ĐÂY: Hiển thị nguyên nhân AI bị lỗi
        setState(() {
          _foodName = "Lỗi xử lý AI!";
          _confidence = "Chi tiết: ${jsonResult['error'] ?? 'Lỗi không xác định'}";
        });
      }
    } catch (e) {
      setState(() {
        _foodName = "Không thể kết nối Server";
        _confidence = "Vui lòng bật FastAPI Server";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart NutriScan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Khung hiển thị ảnh
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: _image == null
                  ? const Icon(Icons.image, size: 100, color: Colors.grey)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 32),
            
            // Hiển thị kết quả AI
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading) ...[
              Text(
                _foodName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 8),
              Text(
                _confidence,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 32),

            // Nút chọn ảnh
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Chọn ảnh đồ ăn', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}