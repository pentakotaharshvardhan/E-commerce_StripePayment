# 📚 3D FlipBook E-Commerce App (Flutter + Stripe)

An interactive Flutter-based e-commerce application featuring a realistic book-style UI with 3D product previews and Stripe payment integration.

---

## 🚀 Features

- 📖 Realistic animated book opening effect
- 📄 Smooth page flip product navigation
- 🧊 3D product preview using `model_viewer_plus`
  - Auto-rotate
  - Camera controls
  - AR support
- 💳 Secure Stripe Payment Sheet integration
- 🎬 Swipe hint animation using Rive
- 🎉 Payment Success screen after successful transaction

---

## 🛠 Tech Stack

- **Flutter**
- **Dart**
- **flutter_stripe**
- **model_viewer_plus**
- **rive**
- **page_flip**
- **http**
- **Node.js (Stripe Payment Intent Backend)**

---

## 📂 Project Structure

```
project-root/
│
├── lib/
│   ├── main.dart
│   ├── item_data.dart
│   ├── BookCoverUI.dart
│   ├── PaymentSuccessPage.dart
│
├── android/
├── ios/
├── backend/   (Stripe Payment Intent Server)
│
├── pubspec.yaml
└── README.md
```

---

## 🔑 Stripe Configuration

Inside `main.dart`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "YOUR_STRIPE_PUBLISHABLE_KEY";
  runApp(const RealisticBookApp());
}
```

⚠️ **Important:** Never expose your Stripe Secret Key in the frontend.

---

## 🌐 Backend Requirement

Your backend must create a Stripe PaymentIntent.

### Endpoint

```
POST /create-payment-intent
```

### Request Body

```json
{
  "amount": 10000
}
```

> Amount must be sent in the smallest currency unit (e.g., paise for INR, cents for USD).

### Response

```json
{
  "clientSecret": "your_client_secret_here"
}
```

---

## 💳 Payment Flow

1. User taps **BUY NOW**
2. App sends request to backend to create PaymentIntent
3. Stripe Payment Sheet is initialized
4. Payment sheet is presented
5. On success → Navigate to `PaymentSuccessScreen`

---

## ▶️ Running the Project

### 1️⃣ Install Dependencies

```
flutter pub get
```

### 2️⃣ Run in Debug Mode

```
flutter run
```

### 3️⃣ Run in Profile Mode (Performance Testing)

```
flutter run --profile
```

### 4️⃣ Build Release APK

```
flutter build apk --release
```

---

## 📦 Dependencies

Add the following in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_stripe: ^latest_version
  model_viewer_plus: ^latest_version
  rive: ^latest_version
  page_flip: ^latest_version
  http: ^latest_version
```

Then run:

```
flutter pub get
```

---

## ⚡ Performance Notes

- Load only one `ModelViewer` at a time (WebView is heavy)
- Test performance using `--profile` or `--release`
- Avoid heavy logic inside `build()` method
- Use lazy loading where possible
- Debug mode is slower than release mode

---

## 🔐 Security Best Practices

- Always create PaymentIntent from backend
- Never expose Stripe Secret Key
- Use HTTPS for backend API
- Use Release mode for production deployment

---

## 📄 License

This project is built for educational and demonstration purposes.
