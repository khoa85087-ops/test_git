import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms
from PIL import Image
import os

# ===== MODEL =====
class SimpleCNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, 3, padding=1)
        self.conv3 = nn.Conv2d(64, 128, 3, padding=1)
        self.fc1 = nn.Linear(2048, 512)
        self.fc2 = nn.Linear(512, 10)

    def forward(self, x):
        x = F.max_pool2d(F.relu(self.conv1(x)), 2)
        x = F.max_pool2d(F.relu(self.conv2(x)), 2)
        x = F.max_pool2d(F.relu(self.conv3(x)), 2)
        x = x.view(-1, 2048)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# ===== LOAD MODEL =====
net = SimpleCNN()
net.load_state_dict(torch.load("cifar_net_khoa.pth", map_location='cpu'))
net.eval()

# ===== TRANSFORM =====
transform = transforms.Compose([
    transforms.Resize((32, 32)),
    transforms.ToTensor(),
    transforms.Normalize((0.5,0.5,0.5),(0.5,0.5,0.5))
])

# ===== CLASS =====
classes = ['airplane','automobile','bird','cat','deer','dog','frog','horse','ship','truck']

# ===== TEST =====
folder = "cifar100"

correct = 0
total = 0

for file in os.listdir(folder):
    if not file.endswith((".png", ".jpg", ".jpeg")):
        continue

    # ===== LẤY LABEL TỪ TÊN FILE =====
    # ví dụ: 0_bird.png -> bird
    true_label_name = file.split("_")[1].split(".")[0]

    if true_label_name not in classes:
        continue

    true_label = classes.index(true_label_name)

    # ===== LOAD IMAGE =====
    img_path = os.path.join(folder, file)
    img = Image.open(img_path).convert('RGB')
    img = transform(img).unsqueeze(0)

    # ===== PREDICT =====
    with torch.no_grad():
        outputs = net(img)
        probs = F.softmax(outputs, dim=1)
        conf, predicted = torch.max(probs, 1)

    pred_label = classes[predicted.item()]

    print(f"{file} -> {pred_label} ({conf.item():.4f})")

    # ===== ACCURACY =====
    total += 1
    if predicted.item() == true_label:
        correct += 1

# ===== RESULT =====
acc = correct / total if total > 0 else 0
print(f"\nAccuracy: {acc:.4f} ({correct}/{total})")
input("Press Enter to exit...")