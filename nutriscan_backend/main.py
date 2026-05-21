import io
import json
import torch
import torch.nn as nn
import torchvision
from torchvision import transforms
from PIL import Image
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse

# =========================
# 1. Khai báo model
# Phải giống kiến trúc lúc train trong Colab
# =========================

class SEBlock(nn.Module):
    def __init__(self, in_channels, reduction=16):
        super(SEBlock, self).__init__()
        self.avg_pool = nn.AdaptiveAvgPool2d(1)
        self.fc = nn.Sequential(
            nn.Linear(in_channels, in_channels // reduction, bias=False),
            nn.ReLU(inplace=True),
            nn.Linear(in_channels // reduction, in_channels, bias=False),
            nn.Sigmoid()
        )

    def forward(self, x):
        b, c, _, _ = x.size()
        y = self.avg_pool(x).view(b, c)
        y = self.fc(y).view(b, c, 1, 1)
        return x * y.expand_as(x)


class NutriScanModel(nn.Module):
    def __init__(self, num_classes):
        super(NutriScanModel, self).__init__()
        # Backend không cần tải pretrained nữa vì trọng số đã nằm trong file .pth
        self.backbone = torchvision.models.mobilenet_v2(weights=None).features
        self.se_block = SEBlock(in_channels=1280)
        self.pool = nn.AdaptiveAvgPool2d(1)
        self.flatten = nn.Flatten()
        self.fc = nn.Linear(1280, num_classes)

    def forward(self, x):
        x = self.backbone(x)
        x = self.se_block(x)
        x = self.pool(x)
        x = self.flatten(x)
        return self.fc(x)


# =========================
# 2. Load model và class
# =========================

app = FastAPI()
device = torch.device("cpu")

MODEL_PATH = "nutriscan_vietnamese_3classes.pth"
CLASS_PATH = "class_names.json"

with open(CLASS_PATH, "r", encoding="utf-8") as f:
    class_names = json.load(f)

model = NutriScanModel(num_classes=len(class_names))
model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
model.to(device)
model.eval()

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225])
])


# =========================
# 3. API test server
# =========================

@app.get("/")
def home():
    return {
        "message": "Smart NutriScan backend is running",
        "classes": class_names
    }


# =========================
# 4. API dự đoán ảnh
# =========================

@app.post("/predict")
async def predict_food(file: UploadFile = File(...)):
    try:
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")

        input_tensor = transform(image).unsqueeze(0).to(device)

        with torch.no_grad():
            outputs = model(input_tensor)
            probs = torch.softmax(outputs, dim=1)[0]
            pred_idx = torch.argmax(probs).item()
            conf_score = probs[pred_idx].item() * 100

        result_food = class_names[pred_idx]

        if conf_score < 70.0:
            return JSONResponse(content={
                "food": "Unknown",
                "confidence": f"{conf_score:.2f}%",
                "message": "Độ tự tin thấp, AI chưa chắc đây là món nào."
            })

        return JSONResponse(content={
            "food": result_food,
            "confidence": f"{conf_score:.2f}%",
            "message": "AI phân tích thành công!"
        })

    except Exception as e:
        return JSONResponse(
            content={"error": str(e)},
            status_code=400
        )