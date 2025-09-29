# 🍔 Food Ordering Workflow App

A Flutter application that demonstrates a **food ordering workflow** similar to popular food delivery apps (Swiggy, Zomato, Uber Eats).

This project focuses on **BloC state management**, **SOLID architecture**, **error handling**, and **unit testing**. It is designed as an assignment project to showcase clean architecture and realistic workflows.

---

## ✨ Features

* 📋 **Restaurant List** – Browse local restaurants (mock data).
* 🍕 **Menu Screen** – View food items, add/remove from cart.
* 🛒 **Cart Screen** – Update quantity, view order summary, proceed to checkout.
* 📦 **Checkout Screen** – Enter delivery address, choose payment method, place order.
* ✅ **Order Confirmation** – Display order success message and details.
* 📜 **Order History** – View list of past orders with order details

---

## 🏗️ Architecture

The project follows **SOLID principles** and is structured into layers:

* **Data Layer** → Repositories (mock/fake API using `Future.delayed`)
* **Logic Layer** → BloCs handle events, manage state
* **Presentation Layer** → Flutter UI listens to BloC states

---

## 🛠️ Technologies Used

* [Flutter](https://flutter.dev/) (Material 3 design)
* [flutter_bloc](https://pub.dev/packages/flutter_bloc) for state management
* [equatable](https://pub.dev/packages/equatable) for value comparison
* [bloc_test](https://pub.dev/packages/bloc_test) for unit testing

---

## ⚙️ Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/harshitgupta73/food-delivery-app
   cd food_ordering_app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app on an emulator or connected device:

   ```bash
   flutter run
   ```
---

