# SRM Nexus 🚀

Welcome to the **SRM Nexus** project! You successfully built this app through "vibe coding", and now it's time to "vibe learn" how it all actually works under the hood. 

This README serves as your personal study guide. It breaks down the architecture, the code structure, and the logic that runs the app, making it easy to explain and demonstrate to your HOD.

---

## 🏗️ Architecture: How is the App Organized?

This app follows a clean, professional architecture called **MVVM (Model-View-ViewModel)** with **Dependency Injection**. It ensures that UI (what the user sees) is strictly separated from Business Logic (how data is fetched).

We achieved this using the **Provider** package and the **Repository Pattern**.

### 1. The Repository Pattern
Instead of UI screens fetching their own data directly, they ask a "Repository" for it. A Repository's only job is to provide data.
* **Why?** It allowed us to instantly swap between fake data (`MockAuthService`) and real network calls (`ApiAuthService`) without touching a single line of UI code!
* **Where:** `lib/core/repositories/` contains abstract interfaces (rules). `lib/core/services/` contains the actual implementations (the mock services).

### 2. Provider (Dependency Injection)
To pass these Repositories down to the screens, we wrap the whole app in `MultiProvider` (inside `main.dart`).
* When a screen needs data, it simply calls: `Provider.of<AuthRepository>(context)`.
* This magically finds the active repository (currently `MockAuthService`) and gets the data.

---

## 📂 Folder Structure

The `lib/` directory is split intelligently so that anyone can navigate the code easily:

```text
lib/
├── core/
│   ├── models/        # Data blueprints (e.g., StudentModel for profile info)
│   ├── repositories/  # Blueprints for data fetching (interfaces like AuthRepository)
│   └── services/      # The actual logic (e.g., MockAuthService returns your name "Harshanth")
│
├── screens/
│   ├── main_scaffold.dart      # The master screen holding the bottom navigation bar and drawer
│   ├── dashboard_screen.dart   # The main landing tab ("Home")
│   ├── attendance_screen.dart  # Detailed attendance UI
│   ├── marks_screen.dart       # Internal marks table
│   ├── results_screen.dart     # Semester results (CGPA)
│   ├── timetable_screen.dart   # The animated "Pending Server Access" screen
│   ├── srm_webview_login_screen.dart # 🔒 The magical embedded SRM Portal browser!
│   └── coming_soon_screen.dart # Placeholder for features not yet built
│
└── main.dart          # The entry point of the app (App setup + Initial Login Screen)
```

---

## 🎨 UI & UX Breakdown

The app feels extremely premium and smooth. Here is how we did it:

### 1. Glassmorphism & Blurs
If you look inside widgets like `main_scaffold.dart` (the bottom navigation bar), you will see `BackdropFilter(filter: ImageFilter.blur(...))`. This is what creates that sleek, frosted-glass effect over the background.

### 2. Micro-Animations (The "Vibe")
Notice how components slide up and fade in smoothly when you open them? 
We used Flutter's `AnimationController` combined with `FadeTransition` and `SlideTransition`. 
* Example: Open `timetable_screen.dart`. You'll see an `AnimationController` running a `.repeat(reverse: true)` loop that makes the cyan dot orbit and the gradient card "breathe" (pulse) endlessly.

### 3. Styling Theme
We used a strict palette to stay consistent:
* **Background:** Deep rich dark gray/black (`0xFF0A0A0F`).
* **Accents:** Modern Cyan (`0xFF00D4FF`) and Purple/Indigo (`0xFF6C63FF`).
* **Widgets:** White borders with very low opacity (e.g., `Colors.white.withValues(alpha: 0.06)`) to create subtle depth without looking flat.

---

## 🔐 The Login Flow (The Most Crucial Part)

You wanted a highly ethical approach that doesn't hack or bypass SRM firewalls. The solution was the **WebView Login Flow**.

1. **The Initial Screen (`main.dart`):** The user lands on a beautiful custom login UI.
2. **The SRM Button:** When they press "Sign in with SRM Portal", a modal bottom sheet slides up containing `SrmWebViewLoginScreen.dart`.
3. **The Embedded Browser:** We use the `webview_flutter` package to load the genuine SRM login URL `https://sp.srmist.edu.in/.../youLogin.jsp`.
4. **Solving the CAPTCHA:** Because it's a real browser, the SRM server natively handles the CAPTCHA image and validates the user just like Chrome or Safari would.
5. **The Interception:** In our code, we use a `NavigationDelegate`. When we detect the WebView successfully navigating to `HRDSystem.jsp` (meaning login succeeded), we inject JavaScript (`document.cookie`) to steal the session cookies securely.
6. **Storage & Success:** We store those cookies securely in the device's keychain using `flutter_secure_storage` and let the app proceed to the main dashboard.

---

## 🚀 Moving to Production (Post-HOD Demo)

Right now, the app is 100% powered by Mock Services in `lib/core/services/`.

When the HOD grants you server access, the transition is insanely simple:

1. **Write Network Logic:** We build `ApiTimetableService` and `ApiResultsService` that make `http.get` requests to the SRM portal using the cookies we captured during WebView login.
2. **Scrape the HTML:** Because SRM renders old-school HTML (no modern JSON APIs), we will use the `html` package in Dart to parse (`querySelector`) the raw HTML and extract the tables into our models.
3. **Flick the Switch:** Open `main.dart`, change `Provider<TimetableRepository>(create: (_) => MockTimetableService())` to `create: (_) => ApiTimetableService()`.

**The UI will remain untouched.** The screens won't even know the data source changed. That's the power of the Repository Pattern!

---

Good luck with your presentation! You built something incredible. 🌟
