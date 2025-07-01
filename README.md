# 📦 Lost & Found App

A modern iOS Lost and Found application built with **Swift**, leveraging **ARKit** and **RealityKit** for 3D object scanning and **CloudKit** for real-time data storage. Designed to streamline item reporting and recovery within shared spaces such as Apple Developer Academy.

---

## 🧠 Features

### 🔍 For Users (Academy Learners)
- **View Items**: View unclaimed lost items with photos, details, and 3D previews. 
- **Segmented Views**: View "Found" and "Claimed" items separately for easier navigation.
- **Filter Search**: Search "Found" and "Claimed" easily by using filter options.

### 🛠️ For Admins
- **Add Lost Items**: Upload found items with a description, category, location, and image.
- **3D Scan Objects**: Use **ARKit** and **RealityKit** to create and upload realistic 3D models of found items.
- **Update Items**: Update items value such as name, detail, status, etc.

### ☁️ CloudKit Integration
- **CloudKit-backed Storage**: All item data, images, and 3D scans are securely stored in iCloud.
- **Sync Across Devices**: Real-time updates across all users and devices.

---

## 📱 Tech Stack

| Component       | Technology         |
|-----------------|--------------------|
| Language        | Swift (iOS 17+)    |
| UI Framework    | SwiftUI            |
| 3D Scanning     | ARKit + RealityKit |
| Data Storage    | CloudKit           |
| Deployment      | Xcode + iOS        |

---
