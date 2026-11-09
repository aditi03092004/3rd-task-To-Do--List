# 📝 To-Do List App — Modern Task Management in Flutter

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47.9-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.13.7-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Material 3](https://img.shields.io/badge/Design-Material%203-blue?logo=materialdesign&logoColor=white)](https://m3.material.io)
[![Tests](https://img.shields.io/badge/Tests-12%2F12%20Passing-brightgreen?logo=checkmarx&logoColor=white)](test/)
[![Code Style](https://img.shields.io/badge/Style-flutter__lints-blueviolet)](analysis_options.yaml)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An elegant, high-performance, single-screen **To-Do List application** engineered in **Flutter & Dart** following senior software engineering standards. Designed specifically as an **internship-submission-ready project**, this app demonstrates reactive state management with `setState()`, dynamic collection manipulation, smooth touch gestures via `Dismissible`, keyboard actions, and Material 3 design principles in an eye-catching blue-and-white theme.

---

## 📌 Table of Contents

- [1. Project Overview](#1-project-overview)
- [2. Internship Project Objective](#2-internship-project-objective)
- [3. Key Features](#3-key-features)
- [4. Technologies & Architecture](#4-technologies--architecture)
- [5. Project Folder Structure](#5-project-folder-structure)
- [6. Application Screenshots](#6-application-screenshots)
- [7. Task Management Functionality Deep-Dive](#7-task-management-functionality-deep-dive)
- [8. Installation & Setup Instructions](#8-installation--setup-instructions)
- [9. How to Execute the Application](#9-how-to-execute-the-application)
- [10. Testing & Verification](#10-testing--verification)

---

## 1. Project Overview

The **To-Do List App** provides a lightweight, distraction-free environment for everyday task tracking. With real-time metrics, dynamic counters, and fluid swipe gestures, users can quickly capture tasks, track progress against completion goals, mark off items with strikethrough feedback, and undo accidental removals with a single tap.

---

## 2. Internship Project Objective

The primary objective of this project is to implement a robust, production-grade single-screen Flutter application satisfying core mobile engineering competencies:

- **State Management**: Clean and reactive UI updates using `StatefulWidget` and `setState()` without unnecessary external dependencies.
- **Scrollable Dynamic Collections**: Optimizing rendering with `ListView.builder` and custom slivers (`CustomScrollView`).
- **Interactive Gestures**: Implementing native swipe-to-delete with `Dismissible` and custom visual feedback.
- **Form & Input Validation**: Real-time input validation preventing empty/whitespace tasks with hardware and soft keyboard `onSubmitted` support.
- **Design Systems**: Crafting a modern Material 3 interface with soft elevation, rounded card surfaces, clean typography, and a cohesive blue-and-white theme.

---

## 3. Key Features

- 📅 **Dynamic App Header**:
  - Displays the app title **"My Tasks"** and inspiring subtitle: *"Stay organized. Get things done."*
  - Automatically formats the current date in clean format (e.g., `Monday, Nov 9, 2026`).
- 📊 **Dynamic Task Overview Card**:
  - Displays **Total Tasks**, **Remaining Tasks**, and **Completed Tasks**.
  - Dynamic completion progress bar with percentage indicator.
  - Motivational status message adapting to user completion rate.
  - Recalculated dynamically from list state upon every add, toggle, or delete action.
- ✍️ **Intuitive Task Creation**:
  - `TextField` with placeholder *"What needs to be done?"*.
  - Dual submission support: tap modern **Add** button or press **Enter/Done** on the keyboard.
  - Input validation: suppresses whitespace and blank submissions.
  - Auto-clearing input field with animated clear (X) button.
- ✅ **Task Card & Strikethrough Styling**:
  - Custom rounded checkbox for marking tasks completed or uncompleted.
  - Fluid strikethrough styling (`TextDecoration.lineThrough`), muted text, and status badge when marked complete.
  - Creation timestamp formatted cleanly (e.g., `11:45 AM`).
- 🗑️ **Swipe-to-Delete with Undo**:
  - Swipe task to delete via Flutter's `Dismissible` widget.
  - Vibrant red background with trash icon during swipe.
  - Instant SnackBar confirmation featuring a one-tap **UNDO** action.
- 🌟 **Empty State Experience**:
  - Custom checklist illustration with glowing blue accent.
  - Clear message: *"No tasks yet!"* and subtitle: *"Add your first task and start being productive."*
  - Interactive **Quick Suggestion Chips** enabling users to populate tasks with one tap.
- 🎯 **Category Filtering**:
  - Real-time pill filters: **All**, **Active**, and **Done**.

---

## 4. Technologies & Architecture

- **Framework**: Flutter 3.47+ (Channel Stable)
- **Language**: Dart 3.13+
- **Design System**: Material 3 Design (`useMaterial3: true`)
- **State Management**: `StatefulWidget` & `setState()`
- **Layout Widgets**: `SafeArea`, `CustomScrollView`, `SliverList`, `Row`, `Column`, `Container`, `CardThemeData`, `Dismissible`
- **Zero Heavy External Dependencies**: Pure Flutter SDK implementation for optimal compilation speed, zero dependency bloat, and maximum reliability.

---

## 5. Project Folder Structure

```text
3rd-task-To-Do--List/
│
├── android/                      # Native Android project configuration
├── ios/                          # Native iOS project configuration
├── web/                          # Web platform support
├── windows/                      # Native Windows runner
├── macos/                        # macOS platform support
├── linux/                        # Linux platform support
│
├── lib/
│   ├── models/
│   │   └── task.dart             # Task data model (id, title, isCompleted, createdAt)
│   ├── screens/
│   │   └── todo_screen.dart      # Main single-screen To-Do state and layout
│   ├── utils/
│   │   └── date_formatter.dart   # Clean date & time formatting helper
│   ├── widgets/
│   │   ├── add_task_field.dart   # Reusable task input component with validation
│   │   ├── empty_state.dart      # Empty state with interactive suggestion chips
│   │   ├── task_item.dart        # Reusable task card with Dismissible & Checkbox
│   │   └── task_summary.dart     # Overview card with progress bar & 3 counters
│   └── main.dart                 # Application entry point and Material 3 theme config
│
├── test/
│   ├── task_model_test.dart      # Unit tests for Task model logic & serialization
│   └── widget_test.dart          # 8+ comprehensive widget and integration tests
│
├── analysis_options.yaml         # Linting and static analysis rules
├── pubspec.yaml                  # Project dependencies & metadata
└── README.md                     # Project documentation
```

---

## 6. Application Screenshots

| Main Tasks Screen | Task Completed & Counters | Swipe-to-Delete Action |
|:---:|:---:|:---:|
| ![Main Screen Placeholder](https://via.placeholder.com/320x640/2563EB/FFFFFF?text=Main+Tasks+Screen) | ![Completed State Placeholder](https://via.placeholder.com/320x640/10B981/FFFFFF?text=Completed+Task) | ![Swipe to Delete Placeholder](https://via.placeholder.com/320x640/EF4444/FFFFFF?text=Swipe+Delete) |

| Empty State Screen | Quick Filter View | SnackBar with Undo |
|:---:|:---:|:---:|
| ![Empty State Placeholder](https://via.placeholder.com/320x640/F8FAFC/2563EB?text=Empty+State) | ![Filter View Placeholder](https://via.placeholder.com/320x640/2563EB/FFFFFF?text=Active+Tasks+Filter) | ![Undo Snackbar Placeholder](https://via.placeholder.com/320x640/0F172A/60A5FA?text=Undo+Snackbar) |

---

## 7. Task Management Functionality Deep-Dive

### A. Dynamic Calculation (No Manual Hardcoding)
The application computes all counts dynamically directly from the underlying `List<Task>` state:

```dart
int get _totalTasks => _tasks.length;
int get _completedTasks => _tasks.where((task) => task.isCompleted).length;
int get _remainingTasks => _tasks.where((task) => !task.isCompleted).length;
```

Any modification (creation, toggle, deletion, undo) triggers `setState()`, guaranteeing that all counters and the linear progress indicator remain 100% consistent with the active task list.

### B. Swipe-To-Delete with Unique Keys
Each item in the list is wrapped in a `Dismissible` widget keyed with `ValueKey('task_dismissible_${task.id}')`. This prevents duplicate widget recycling issues and ensures smooth animated dismissals.

```dart
Dismissible(
  key: ValueKey('task_dismissible_${task.id}'),
  direction: DismissDirection.endToStart,
  background: _buildSwipeDeleteBackground(),
  onDismissed: (_) => onDelete(),
  child: ...
)
```

### C. Validation & Clean Inputs
The input field inspects user input:
- String trimming removes trailing and leading whitespace.
- Blank input is ignored cleanly without throwing exceptions.
- The input controller resets upon submission.

---

## 8. Installation & Setup Instructions

### Prerequisites
1. **Flutter SDK**: Version 3.24.0 or higher.
2. **Dart SDK**: Version 3.5.0 or higher.
3. An IDE: **IntelliJ IDEA**, **Android Studio**, or **VS Code** with Flutter plugins installed.
4. Git installed and configured.

### Step-by-Step Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/aditi03092004/3rd-task-To-Do--List.git
   cd 3rd-task-To-Do--List
   ```

2. **Fetch Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Verify static analysis**:
   ```bash
   flutter analyze
   ```
   *(Expected output: `No issues found!`)*

---

## 9. How to Execute the Application

### Running on Connected Device / Emulator:
```bash
flutter run
```

### Running on Specific Platforms:
- **Chrome / Web Browser**:
  ```bash
  flutter run -d chrome
  ```
- **Windows Desktop**:
  ```bash
  flutter run -d windows
  ```
- **Android Emulator**:
  ```bash
  flutter run -d <emulator-id>
  ```

---

## 10. Testing & Verification

The project includes unit and widget test suites ensuring the stability of state management, gestures, and UI components.

### Execute All Tests:
```bash
flutter test
```

### Test Suite Coverage:
| Test Case | Description | Result |
|:---|:---|:---:|
| **Task Model Tests** | Unique ID generation, trimming, toggle(), copyWith(), serialization | ✅ Pass |
| **Launch & Render** | Verifies header, date, 3 metric counters, add task field | ✅ Pass |
| **Empty State** | Displays "No tasks yet!" illustration when list is empty | ✅ Pass |
| **Input Validation** | Rejects empty and whitespace-only submissions | ✅ Pass |
| **Dynamic Task Addition** | Adds task, clears input, increments counters | ✅ Pass |
| **Keyboard Submission** | Submits task using Enter key (`TextInputAction.done`) | ✅ Pass |
| **Completion Toggle** | Toggles checkbox, updates strikethrough, updates counters | ✅ Pass |
| **Swipe to Delete** | Dismissible gesture deletes item, updates counts, shows Undo | ✅ Pass |
| **Task Filtering** | Filters tasks by All, Active, and Done accurately | ✅ Pass |

---

## 👨‍💻 Author & Submission Information

- **Project**: To-Do List App (3rd Task)
- **Repository**: [https://github.com/aditi03092004/3rd-task-To-Do--List.git](https://github.com/aditi03092004/3rd-task-To-Do--List.git)
- **Role**: Senior Flutter Developer (Internship Submission)
