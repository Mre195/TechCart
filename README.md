# 🛒 TechCart
### Flutter + Firebase Mobile E-Commerce App

A mobile e-commerce app for browsing and purchasing PC components (GPU, CPU, RAM, Storage). Built with Flutter and Firebase — featuring real-time Firestore inventory, a persistent cart, Firebase Authentication, and a light/dark theme toggle.

---

## 🛠️ Technology Stack

| Technology | Details |
|---|---|
| Flutter | Dart, cross-platform (Android / iOS) |
| Firebase Auth | Email/password authentication |
| Cloud Firestore | Products, cart, and user data |
| State Management | `ValueNotifier` for theme |
| Packages | `cloud_firestore`, `firebase_auth`, `firebase_core` |

---

## 📁 Project Structure

```
lib/
└── pages/
    ├── main.dart             # App entry point, Firebase init, auth routing
    ├── login.dart            # Login screen
    ├── signup.dart           # User sign-up
    ├── signupadmin.dart      # Admin sign-up
    ├── home.dart             # Home screen with category grid + promo slider
    ├── products.dart         # Product listing with category filter + cart
    ├── cart.dart             # Cart screen with quantity controls + payment
    ├── cartitem.dart         # CartItem model
    ├── cartservice.dart      # Firestore cart CRUD operations
    ├── settings.dart         # Password update + account deletion
    ├── drawer.dart           # Side navigation drawer
    ├── photo_slider.dart     # Auto-scrolling promo banner
    └── theme_controller.dart # Global dark/light mode ValueNotifier

assets/
    ├── logo.png
    ├── lolg.png
    ├── pa.jpeg / pa2.jpeg / pa3.jpeg
    └── [product images]
```

---

## 🔥 Firebase Setup

> You need to connect your own Firebase project to run this app.

### 1. Create a Firebase project
Go to [console.firebase.google.com](https://console.firebase.google.com), create a project, and register your Android/iOS app.

### 2. Add config files
- Android: place `google-services.json` in `android/app/`
- iOS: place `GoogleService-Info.plist` in `ios/Runner/`

> These files are excluded from the repo via `.gitignore` — you must add your own.

### 3. Enable services
- **Authentication** → Email/Password provider
- **Cloud Firestore** → Create database

### 4. Firestore Collections

#### `products` collection
| Field | Type | Notes |
|---|---|---|
| id | int | Timestamp-based unique ID |
| name | String | Product display name |
| price | double | Price in JD |
| image | String | Asset path e.g. `assets/gpu1.png` |
| category | String | `GPU` / `CPU` / `RAM` / `Storage` |
| stock | int | Available quantity |

#### `users/{uid}/cart` subcollection
| Field | Type | Notes |
|---|---|---|
| productId | int | References `products` document ID |
| quantity | int | Items in cart |

#### `data/{uid}` collection
| Field | Type | Notes |
|---|---|---|
| first_name | String | |
| last_name | String | |
| email | String | |
| role | String | `"user"` or `"admin"` |

---

## ⚙️ Setup & Running

### Prerequisites
- Flutter SDK installed (`flutter --version`)
- Android Studio or VS Code with Flutter plugin
- A Firebase project configured (see above)

### Steps
```bash
# 1. Clone the repo
git clone https://github.com/Mre195/TechCart.git
cd TechCart

# 2. Add your Firebase config files (see Firebase Setup above)

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## ✨ Features

| Screen | Features |
|---|---|
| Login | Firebase email/password auth, show/hide password, guest access |
| Sign Up | Create user account, name saved to Firestore + Firebase display name |
| Home | Auto-scrolling promo banner, 4 category cards (GPU, CPU, RAM, Storage) |
| Products | Firestore product list, category dropdown filter, quantity selector, add to cart |
| Cart | Persistent Firestore cart, quantity +/−, stock validation, total cost, payment |
| Settings | Change password (with re-auth), delete account (clears all Firestore data) |
| Drawer | Navigation, shows username/email, logout |
| Theme | Light/Dark toggle, applies globally via `ValueNotifier` |

---

## 👤 User Roles

| Role | Access |
|---|---|
| Guest | Browse products only — no cart |
| User | Full cart and purchase flow |
| Admin | All of the above + manage products — manually in Firestore console |

---

## 🔑 Password Rules

- Minimum **8 characters**
- Must match the confirm password field
- Password change requires entering the **current password** first (Firebase re-authentication)

---

## 👤 Author

**Moath Refaie**  
Applied Science University — Faculty of Information Technology, Amman, Jordan  
GitHub: [github.com/Mre195](https://github.com/Mre195)
