
# 🎓 SkillHub - Your Personal Course Marketplace

SkillHub is a powerful and engaging platform designed to connect learners with a wide variety of courses in creative, technical, and personal development fields. With a blend of dynamic content, live workshops, and a thriving community, SkillHub fosters personal and professional growth for users from all walks of life.

## Table of Contents

- [Features](#-features)
- [Project Architecture](#-project-architecture)
- [Firebase Authentication Integration](#-firebase-authentication-integration)
- [API Integration](#-api-integration)
- [Product Filtering](#-product-filtering)
- [Project Structure](#-project-structure)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Development Tools](#-development-tools)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)
- [Support & Feedback](#-support--feedback)
- [Acknowledgements](#-acknowledgements)


## 🚀 Features

- **Firebase Authentication**: Users can log in using email/password, Google, or Facebook via Firebase Auth.
- **Product Listing from API**: Products are fetched dynamically from the [Dummy JSON Products API](https://dummyjson.com/docs/products).
- **Product Filtering**: Users can filter products by price, categories, brands, and more, with a dynamic UI.
- **Lazy Loading**: Product listings implement lazy loading for smooth scrolling and efficient data loading.
- **Creative Courses**: Explore courses on design, writing, photography, and more.
- **Technical Mastery**: Sharpen your skills in programming, data science, and tech-related fields.
- **Personal Development**: Learn about productivity, mental health, and lifestyle improvement.
- **Live Workshops**: Participate in interactive sessions with industry experts.
- **Community Support**: Engage with a community of learners, share progress, and collaborate.



## 📐 Project Architecture

SkillHub is built using the **MVVM (Model-View-ViewModel) architecture** pattern with **Provider** for state management. This architecture ensures a clean separation of concerns and makes the app more scalable and maintainable. Below is a brief overview of the architecture:

- **Model**: Represents the data layer, including API responses and data models.
- **View**: The UI layer (screens and widgets) that observes changes in the ViewModel.
- **ViewModel**: The logic layer where the business logic resides, communicating between the Model and View.

We use **Provider** for state management, which helps the app efficiently manage and update UI based on the ViewModel's state.



## 🔥 Firebase Authentication Integration

SkillHub integrates **Firebase Authentication** for secure and seamless user login. Users can log in using:

- **Email & Password** authentication
- **Google Sign-In**
- **Facebook Login**

Firebase authentication ensures proper error handling, including login failures, password validation, and account verification.



## 🌐 API Integration

SkillHub consumes the **Dummy JSON API** to fetch product data for listing and filtering. API features include:

- **Product Listing**: Products are fetched dynamically from the [Dummy JSON Products API](https://dummyjson.com/docs/products).
- **Lazy Loading**: To improve performance, products are loaded as users scroll through the product list.
- **Error Handling**: Ensures proper feedback is given to users in case of failed API calls.



## 🛠️ Product Filtering

The app includes a robust product filtering feature:

- **Filters Based on Design Requirements**: Filter products by categories, price ranges, brands, and more.
- **Dynamic Product Update**: The product list updates in real-time as the user selects or deselects filters.
- **Pagination and Lazy Loading**: Smooth, dynamic loading of products for a seamless user experience.


## 📂 Project Structure

The project follows a well-organized structure to maintain separation of concerns and modularity, as shown below:
```bash
lib/
├── main.dart
├── firebase_options.dart
├── res/
│   └── assets_res.dart
├── models/
│   ├── login_model.dart
│   ├── onboarding_model.dart
│   ├── product_model.dart
│   ├── signup_model.dart
│   └── user_model.dart
├── services/
│   ├── api_service.dart
│   └── auth_service.dart
├── view_models/
│   ├── account_viewmodel.dart
│   ├── auth_viewmodel.dart
│   ├── bottom_nav_viewmodel.dart
│   ├── courses_viewmodel.dart
│   ├── home_screen_viewmodel.dart
│   ├── login_viewmodel.dart
│   ├── onboarding_viewmodel.dart
│   └── signup_viewmodel.dart
├── views/
│   ├── pages/
│   │   ├── account_screen.dart
│   │   ├── courses_screen.dart
│   │   ├── home_screen.dart
│   │   ├── login_page.dart
│   │   ├── message_screen.dart
│   │   ├── onboarding_page.dart
│   │   ├── search_screen.dart
│   │   └── signup_page.dart
│   └── widgets/
│       ├── custom_appbar.dart
│       ├── filter_bottomsheet.dart
│       └── success_dialog.dart
├── linux/                
├── macos/                
├── screenshots/          
└── test/
```

## Screenshots

<img src="/screenshots/01.gif" alt="Animated GIF" width="200"/> <img src="/screenshots/02.gif" alt="Animated GIF" width="200"/>
<img src="/screenshots/03.gif" alt="Animated GIF" width="200"/><img src="/screenshots/04.gif" alt="Animated GIF" width="200"/>
<img src="/screenshots/05.gif" alt="Animated GIF" width="200"/><img src="/screenshots/1.jpg" alt="Home Screen" width="200"/>
<img src="/screenshots/2.jpg" alt="Home Screen" width="200"/> <img src="/screenshots/2n.jpg" alt="Home Screen" width="200"/> 
<img src="/screenshots/3.jpg" alt="Home Screen" width="200"/> <img src="/screenshots/4.jpg" alt="Home Screen" width="200"/>
<img src="/screenshots/5.jpg" alt="Home Screen" width="200"/> <img src="/screenshots/6.jpg" alt="Home Screen" width="200"/>
<img src="/screenshots/7.jpg" alt="Home Screen" width="200"/> <img src="/screenshots/8.jpg" alt="Home Screen" width="200"/>


## 📲 Getting Started

To get started with **SkillHub**, follow these steps:

### Prerequisites

Make sure you have Flutter installed on your machine. If you haven't installed Flutter yet, follow the [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/skillhub.git
   cd skillhub
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```



### First Time with Flutter?

Here are some resources to help you get started with Flutter:

- 📱 [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- 📚 [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For a deeper dive, check out the full [Flutter Documentation](https://docs.flutter.dev/), offering comprehensive guides, tutorials, and API references.



## 🛠️ Development Tools

To contribute or customize **SkillHub**, you can use the following tools:

- **IDE**: [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- **Framework**: [Flutter](https://flutter.dev/)
- **Languages**: Dart



## 🎯 Roadmap

- [ ] Add more course categories
- [ ] Implement user profiles and progress tracking
- [ ] Add offline course access
- [ ] Integrate payment gateways for course purchases



## 💡 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
   ```bash
   git clone https://github.com/your-username/skillhub.git
   ```

2. Create your feature branch:
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. Commit your changes:
   ```bash
   git commit -m 'Add some amazing feature'
   ```

4. Push to the branch:
   ```bash
   git push origin feature/AmazingFeature
   ```

5. Open a pull request.

For any questions, feel free to open an issue.



## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## 🌟 Support & Feedback

If you have any suggestions or issues, please feel free to create an issue or reach out to us at [your-email@example.com]. Your feedback is always appreciated!



## 🙌 Acknowledgements

Thanks to the Flutter team and the amazing open-source community that helps make projects like **SkillHub** possible!



Made with ❤️ using [Flutter](https://flutter.dev/)

