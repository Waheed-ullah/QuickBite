QuickBite - Food Delivery App Prototype
A Flutter-based food delivery app prototype demonstrating modern app architecture, state management with GetX, and offline data persistence.

Features
Browse Restaurants - View restaurants with ratings, cuisine types, and delivery zones

Smart Filtering - Search, sort, and filter restaurants by cuisine and favorites

Menu Management - View restaurant menus with detailed item descriptions

Shopping Cart - Add/remove items, update quantities, apply promo codes

Order Flow - Complete checkout process with delivery fee calculation

Offline Support - Data persistence using Hive local database

Favorites System - Save favorite restaurants locally

Tech Stack
Flutter 3.x - Cross-platform framework

GetX - State management, dependency injection, and routing

Hive - Fast local database for offline storage

Clean Architecture - Feature-based modular structure

Project Structure
text
lib/
├── data/           # Data layer (models, repositories, services)
├── modules/        # Feature modules (restaurants, cart, orders)
├── common/         # Shared utilities and widgets
├── res/            # App resources (themes, colors, routes)
└── main.dart       # App entry point
Key Implementations
State Management
GetX for reactive state management

Controller-based architecture

Automatic dependency injection

Local Storage
Hive for persistent data storage

Cart items persist between app sessions

Favorites saved locally

Order history tracking

User Flow
Browse restaurants with search/filter

View menu and add items to cart

Apply promo codes (SAVE50, FIRST100)

Calculate delivery fees based on zones

Complete checkout process

Review order confirmation

Delivery Fee Logic
Urban: ₹20

Suburban: ₹30

Remote: ₹50

Multi-restaurant orders apply highest fee

Setup & Installation
Clone repository

Install dependencies:

bash
flutter pub get
Run the app:

bash
flutter run
Screens
Restaurants List - Browse with search/filter/sort

Restaurant Details - View menu and add items

Cart - Manage items and apply promo codes

Checkout - Enter delivery details

Order Review - Confirm order summary

Design Principles
Clean, intuitive UI with Material Design

Responsive layout for all screen sizes

Consistent color scheme and typography

Smooth animations and transitions

Clear user feedback with snackbars

Performance
Efficient state management with minimal rebuilds

Local caching for offline access

Optimized list rendering

Fast navigation with GetX