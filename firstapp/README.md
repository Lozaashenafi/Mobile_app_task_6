# Flutter E-Commerce Mobile App

## 📱 Project Overview

A Flutter e-commerce application that implements product management with UI design replication and comprehensive navigation features. This project completes Task 6 and Task 7 as part of mobile development A2SV assignments.

---

## 📋 Tasks Implementation

### **Submission — Task 6: Flutter User Interface Implementation**

This README documents the submission for Task 6. The screenshots below illustrate the app UI and key features implemented for this task.

**Features Implemented:**

- Replicated provided Figma design with pixel-perfect accuracy
- Implemented consistent design system with proper spacing, typography, and colors
- Utilized appropriate Flutter widgets: Container, Column, Row, Image, Text, Button
- Designed responsive layouts for different screen sizes
- Created custom UI components matching the design reference

**Screenshots:**

| ![Home Screen](assets/images/screenshoot1.jpg) | ![Product Detail](assets/images/screenshoot2.jpg) | ![Add Product](assets/images/screenshoot3.jpg) | ![Search Functionality](assets/images/screenshoot4.jpg) |
| :--------------------------------------------: | :-----------------------------------------------: | :--------------------------------------------: | :-----------------------------------------------------: |
|                 _Home Screen _                 |             _Product Detail Screen _              |              _Add Product Screen_              |                     _Search Screen_                     |

---

### **Task 7: Navigation and Routing Implementation**

Task 7 implements app routing using named routes and demonstrates passing data between screens in the e-commerce application.

**Features Implemented:**

- **Named Routes**: Configured named routes in MaterialApp with proper route hierarchy
- **Screen Navigation**: Implemented three main screens (Home, Add/Edit, Detail) with seamless navigation
- **Data Passing**: Successfully pass product data from Add/Edit screens back to Home screen
- **Navigation Animations**: Custom page transitions with smooth animations between screens
- **Back Button Handling**: Proper navigation stack management and back button functionality

### Task 9: Entities, Use Cases, and Repositories

**Description:**  
Refactored the entire project using **Clean Architecture** to improve scalability and maintainability.

**Layer Responsibilities:**

- **Domain Layer**

  - Business entities (`Product`)
  - Use cases (Create, Read, Update, Delete)
  - Repository contracts

- **Data Layer**

  - Models extending domain entities
  - Repository implementations
  - Data mapping and persistence logic

- **Presentation Layer**
  - UI screens and widgets
  - State management using Provider
  - UI logic separated from business logic

**Benefits:**

- Clear separation of concerns
- Easier testing and debugging
- Scalable and maintainable structure
- Industry-standard Flutter architecture

## Task 10: Data Overview Layer

**Description:**  
Implemented the Data Layer structure and documented architecture and data flow.

### Folder Structure

lib/
│── core/ # Shared utilities and error handling
│── features/ # Feature-based modules
│ └── ecommerce/
│── test/ # Unit and widget tests

### Data Models

- Implemented `ProductModel` in  
  `features/ecommerce/data/models/product_model.dart`
- Mirrors the `Product` domain entity
- Includes `fromJson` and `toJson` methods
- Unit tests added to ensure correct data mapping

### Task 11: Contracts of Data Sources (Domain & Data Layer Interfaces)

In this task, the project structure was refactored to follow Clean Architecture principles by defining clear contracts (abstract classes) for data sources and repositories.

**Key Implementations:**

- **Repository Contracts:** Established the `ProductRepository` interface in the Domain layer to decouple the business logic from data implementations.
- **Data Source Interfaces:** Created abstract classes for `ProductRemoteDataSource` and `ProductLocalDataSource` to define the methods required for remote API calls and local caching.
- **Dependency Setup:** Structured the dependency flow ensuring the repository depends on these contracts rather than concrete implementations.

---

### Task 12: Repository Implementation & Testing

This task focused on the concrete implementation of the Repository and ensuring reliability through Unit Testing.

**Key Implementations:**

- **Repository Logic (`ProductRepositoryImpl`):**
  - **Network Awareness:** Integrated `NetworkInfo` to check for internet connectivity.
  - **Remote Logic:** When the device is online, the app fetches data from the `RemoteDataSource` and automatically updates the local cache.
  - **Offline Fallback:** When the device is offline, the app seamlessly switches to the `LocalDataSource` (Shared Preferences) to provide a smooth user experience.
- **Unit Testing:**
  - Implemented a comprehensive test suite using `Mockito` for the `ProductRepositoryImpl`.
  - Verified that the repository checks for network connection.
  - Tested successful data fetching and caching when online.
  - Tested the fallback mechanism to ensure data is retrieved from local storage when the connection is unavailable.
  - Tested `create`, `update`, and `delete` operations to ensure both remote and local sources are synchronized.

### Task 13: Network Information Implementation

- **Feature**: Integrated network connectivity detection using the `internet_connection_checker` package.
- **Abstraction**: Implemented a `NetworkInfo` contract and its concrete implementation `NetworkInfoImpl`.
- **Repository Integration**: Updated `ProductRepositoryImpl` to depend on `NetworkInfo` via constructor injection.
- **Offline Support**: Enhanced all repository methods to check for connectivity before attempting remote operations, with graceful fallbacks to the local cache when offline or when API requests fail.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Dart enabled
- Emulator or physical device

### Run the app

```bash
flutter pub get
flutter run
```
