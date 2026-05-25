# Smart NutriScan 🇻🇳🍜

AI-powered Vietnamese Food Recognition System using **Flutter + FastAPI + PyTorch**

Smart NutriScan is a deep learning-based food recognition application designed to classify Vietnamese dishes from images captured on a mobile device.

The project combines:

* 📱 Flutter Mobile Application
* ⚡ FastAPI Backend API
* 🧠 PyTorch Deep Learning Model
* 🍲 Vietnamese Food Dataset
* 🔍 Real-time AI Inference Pipeline

This project was developed as a practical AI + Mobile + Backend integration project, focusing on:

* Computer Vision
* Deep Learning Deployment
* Mobile-Backend Communication
* AI Inference APIs
* End-to-End System Integration

---

# 🚀 Demo Pipeline

```text
User selects image on Flutter App
            ↓
Image uploaded to FastAPI Backend
            ↓
PyTorch model performs inference
            ↓
Predicted Vietnamese food class returned
            ↓
Flutter app displays prediction + confidence
```

---

# 🧠 Current Supported Vietnamese Foods

Current trained model supports:

| Class          | Description                          |
| -------------- | ------------------------------------ |
| `banh-hoi`     | Vietnamese woven rice vermicelli     |
| `banh-mi-chao` | Vietnamese skillet bread breakfast   |
| `bo-la-lot`    | Grilled beef wrapped in betel leaves |

---

# 🏗️ System Architecture

```text
Flutter Mobile App
        ↓ HTTP Multipart Upload
FastAPI Backend API
        ↓
PyTorch Deep Learning Model
        ↓
Prediction Result (JSON)
```

---

# 📂 Project Structure

```text
smart-nutriscan-vietnamese-food/
│
├── nutri_scan_app/                 # Flutter mobile application
│
├── nutriscan_backend/              # FastAPI backend
│   ├── main.py
│   ├── class_names.json
│   ├── nutriscan_vietnamese_3classes.pth
│   └── requirements.txt
│
├── .gitignore
└── README.md
```

---

# 📱 Flutter Mobile App

The Flutter application allows users to:

* Select images from gallery
* Upload food images to backend
* Receive prediction results
* Display confidence score
* Handle unknown predictions safely

### Example API Endpoint

```dart
http://10.0.2.2:8001/predict
```

`10.0.2.2` is used because the app runs on Android Emulator.

---

# ⚡ FastAPI Backend

The backend is built using FastAPI and handles:

* Image upload processing
* Image preprocessing
* Model inference
* Confidence calculation
* JSON response generation

### Backend Tech Stack

* FastAPI
* Uvicorn
* PyTorch
* Torchvision
* Pillow

---

# 🧠 Deep Learning Model

## Model Architecture

The current implementation uses:

```text
MobileNetV2 + SEBlock (Squeeze-and-Excitation)
```

### Why MobileNetV2?

* Lightweight
* Fast inference
* Mobile-friendly
* Suitable for real-time applications

### Why SEBlock?

SEBlock improves feature attention by helping the network focus on important channel information during inference.

---

# 📊 Dataset

The model was trained on a Vietnamese food dataset containing:

* ~3400 images
* 3 Vietnamese food categories
* Pre-split train / validate / test folders

Dataset structure:

```text
Train/
Validate/
Test/
```

Each folder contains:

```text
banh-hoi/
banh-mi-chao/
bo-la-lot/
```

---

# 🏋️ Model Training

Training was performed using:

* Google Colab
* PyTorch
* Transfer Learning
* Data Augmentation

### Training Features

* Validation Accuracy Tracking
* Best Model Checkpoint Saving
* JSON Class Export
* GPU Training Support

---

# 🔥 Model Output

The trained model exports:

```text
nutriscan_vietnamese_3classes.pth
class_names.json
```

These files are loaded directly by the FastAPI backend during inference.

---

# 🧪 API Example

## Request

```http
POST /predict
Content-Type: multipart/form-data
```

## Response

```json
{
  "prediction": "banh-mi-chao",
  "confidence": 92.41
}
```

---

# 🛠️ Installation

# 1️⃣ Clone Repository

```bash
git clone https://github.com/httrung0308/smart-nutriscan-vietnamese-food.git
```

---

# 2️⃣ Backend Setup

```bash
cd nutriscan_backend
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run backend:

```bash
python -m uvicorn main:app --reload --host 127.0.0.1 --port 8001
```

Backend URL:

```text
http://127.0.0.1:8001
```

Swagger Docs:

```text
http://127.0.0.1:8001/docs
```

---

# 3️⃣ Flutter App Setup

```bash
cd nutri_scan_app/nutri_scan_app
```

Install packages:

```bash
flutter pub get
```

Run app:

```bash
flutter run
```

---

# ⚠️ Important Notes

## Flutter Web

This project is intended for:

* Android Emulator
* Android Devices

Flutter Web is not recommended because:

```dart
Image.file()
```

is not fully supported on web environments.

---

## Android Emulator Networking

When using Android Emulator:

```dart
http://10.0.2.2:8001/predict
```

must be used instead of:

```dart
localhost
```

because Android Emulator maps:

```text
10.0.2.2 → Host Machine
```

---

# 🧩 Future Improvements

Planned future improvements include:

* More Vietnamese food classes
* CBAM Attention Module integration
* Nutritional estimation
* Calorie prediction
* Food ingredient analysis
* Camera live detection
* Cloud deployment
* User history tracking

---

# 📌 Technical Skills Demonstrated

This project demonstrates practical experience in:

* Deep Learning
* Computer Vision
* Transfer Learning
* PyTorch
* Flutter Development
* FastAPI
* REST APIs
* Mobile-Backend Integration
* AI Model Deployment
* Dataset Engineering
* MLOps Workflow
* Debugging & QA Testing

---

# 👨‍💻 Author

**Trung**

GitHub:
[httrung0308](https://github.com/httrung0308?utm_source=chatgpt.com)

---

# ⭐ Acknowledgements

Special thanks to:

* PyTorch
* FastAPI
* Flutter
* Google Colab
* Open-source AI community
