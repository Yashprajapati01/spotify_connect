# 🎵 Spotify Connect App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Spotify-1DB954?style=for-the-badge&logo=spotify&logoColor=white" alt="Spotify">
  <img src="https://img.shields.io/badge/Google%20Gemini-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Gemini">
  <img src="https://img.shields.io/badge/BLoC-00D2FF?style=for-the-badge&logo=flutter&logoColor=white" alt="BLoC">
</div>

<div align="center">
  <h3>🎶 Your Personal AI-Powered Playlist Generator</h3>
  <p>A modern Flutter application that seamlessly integrates with Spotify to create personalized playlists using Google's Gemini AI</p>
</div>

---

## 📖 Table of Contents

- [✨ Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🚀 Getting Started](#-getting-started)
- [🔧 Configuration](#-configuration)
- [📱 Screenshots](#-screenshots)
- [🛠️ Tech Stack](#️-tech-stack)
- [🧠 AI Integration](#-ai-integration)
- [📂 Project Structure](#-project-structure)
- [🔐 Security](#-security)
- [🧪 Testing](#-testing)
- [📋 Roadmap](#-roadmap)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## ✨ Features

### Core Functionality
- 🔐 **Spotify OAuth Authentication** - Secure login with deep linking support
- 👤 **User Profile Management** - Display user information and preferences
- 📋 **Playlist Discovery** - Browse and explore your Spotify playlists
- 🎨 **AI-Powered Playlist Generation** - Create custom playlists based on mood, genre, or description
- 🚀 **Explore Mode** - Advanced AI-powered playlist enhancement with taste analysis
- 💾 **Secure Token Storage** - Encrypted credential management
- 🔄 **Real-time Sync** - Stay updated with your Spotify account

### Technical Features
- 🏗️ **Clean Architecture** - Separation of concerns with Data, Domain, and Presentation layers
- 🎯 **BLoC Pattern** - Predictable state management
- 💉 **Dependency Injection** - Modular and testable code structure
- 🔗 **Deep Linking** - Seamless OAuth callback handling
- 🛡️ **Error Handling** - Comprehensive error management and user feedback

## 🏗️ Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │────│     Domain      │────│      Data       │
│                 │    │                 │    │                 │
│ • UI Widgets    │    │ • Entities      │    │ • Repositories  │
│ • BLoC/Cubit    │    │ • Use Cases     │    │ • Data Sources  │
│ • State Mgmt    │    │ • Repository    │    │ • Models        │
│                 │    │   Interfaces    │    │ • API Clients   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Spotify Developer Account
- Google AI Studio Account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Yashprajapati01/spotify_connect.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Spotify API Setup

1. Visit [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Create a new application
3. Add redirect URI: `myspotifyconnect://callback`
4. Note your Client ID and Client Secret

### Google Gemini API Setup

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Generate an API key
3. Keep it secure for configuration

### Environment Configuration

Create a `lib/secrets.dart` file:

```dart
// lib/secrets.dart
const String spotifyClientId = 'YOUR_SPOTIFY_CLIENT_ID';
const String spotifyClientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';
const String spotifyRedirectUri = 'myspotifyconnect://callback';
const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
```

> ⚠️ **Important**: Never commit your `secrets.dart` file to version control. Add it to `.gitignore`.

### Deep Linking Configuration

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme">
    
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="myspotifyconnect" />
    </intent-filter>
</activity>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>myspotifyconnect</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myspotifyconnect</string>
        </array>
    </dict>
</array>
```

## 📱 Screenshots

<div align="center">
  <img src="git_assets\auth.png" width="200" alt="Authentication">
  <img src="git_assets\agree.png" width="200" alt="Playlists">
  <img src="git_assets\generated.png" width="200" alt="AI Generation">
  <img src="git_assets\home_page.png" width="200" alt="Profile">
</div>

## 🛠️ Tech Stack

### Core Framework
- **Flutter** - UI framework
- **Dart** - Programming language

### State Management
- **flutter_bloc** - Business Logic Component pattern
- **equatable** - Value equality

### Networking
- **dio** - HTTP client

### Storage
- **flutter_secure_storage** - Secure credential storage

### Dependency Injection
- **injectable** - Code generation for DI
- **get_it** - Service locator

### Authentication & Deep Linking
- **app_links** - Deep linking support

## 🧠 AI Integration

The app leverages Google's Gemini AI to create intelligent playlist recommendations:

### How It Works

1. **User Input**: User provides mood, genre, or description
2. **AI Processing**: Gemini analyzes the input and generates track suggestions
3. **Spotify Integration**: App searches for tracks on Spotify
4. **Playlist Creation**: Creates and saves playlist to user's account

### Example Prompts
- "Create a chill playlist for studying"
- "I need energetic songs for my workout"
- "Make a romantic playlist for dinner"
- "Generate 90s rock classics"

## 🔍 Explore Mode & Analyze Me

### Explore Mode 🚀
A simple toggle switch on the home page that enhances your regular playlist generation with AI-powered music discovery.

**How it works:**
1. **Toggle ON** the Explore Mode switch on the home page
2. **Select playlists** as you normally would
3. **Enter your mood** in the text input
4. **Generate** - The AI will analyze your taste and add discovered songs to your playlist

When Explore Mode is enabled:
- ✨ **Smart Discovery**: Finds new songs based on your listening patterns
- 🎯 **Taste Analysis**: Analyzes your selected playlists in real-time
- 🎵 **Enhanced Playlists**: Combines your tracks with AI recommendations
- 🔄 **Seamless Integration**: Works with the existing playlist generation flow

### Analyze Me 🧠
A dedicated feature for deep music taste analysis and insights.

**Access:** Tap the brain icon (🧠) in the top-right corner of the home screen

**What you get:**
- 🧬 **Music DNA Profile**: Visual representation of your audio preferences
- 📊 **Audio Features Analysis**: Energy, danceability, and mood patterns
- 🎭 **Genre Universe**: Your preferred music genres and styles
- 💡 **Listening Insights**: Music diversity and personality analysis
- 🎯 **Music Personality**: AI-generated description of your listening style

### Example Workflows

**Explore Mode:**
```
1. Toggle Explore Mode ON
2. Select your "Chill Vibes" and "Study Music" playlists
3. Enter mood: "focused and calm"
4. Hit generate → Get 30 songs (your tracks + AI discoveries)
```

**Analyze Me:**
```
1. Tap the brain icon in the app bar
2. Wait for analysis to complete
3. Discover your music DNA and personality
4. Learn about your listening patterns and preferences
```

## 📂 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── colors/                     # App color constants
│   └── injection/                  # Dependency injection
├── feature/
│   └── spotify_connect/
│       ├── data/                   # Data layer
│       │   ├── datasources/        # Remote data sources
│       │   ├── models/             # Data models
|       |   ├── services/           # Gemini API
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecases/           # Business use cases
│       └── presentation/           # Presentation layer
│           ├── bloc/               # BLoC state management
│           ├── pages/              # UI pages
│           └── widgets/            # Reusable widgets
└── main.dart                       # App entry point
```

## 🔐 Security

### Best Practices Implemented

- 🔒 **Encrypted Storage**: Sensitive data stored using `flutter_secure_storage`
- 🛡️ **Token Management**: Secure OAuth token handling and refresh
- 🔑 **API Key Protection**: Environment-based configuration
- 🚫 **No Hardcoded Secrets**: All sensitive data externalized
- 🔐 **HTTPS Only**: All API communications over HTTPS


## 🧪 Testing

### Running Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Test coverage
flutter test --coverage
```

### Test Structure

```
test/
├── unit/
│   ├── data/
│   ├── domain/
│   └── presentation/
├── widget/
└── integration/
```

## 📋 Roadmap

### Phase 1: Core Features ✅
- [x] Spotify OAuth Authentication
- [x] User Profile Display
- [x] Playlist Listing
- [x] AI Playlist Generation
- [x] Secure Token Storage

### Phase 2: Enhanced Features ✅
- [x] **Explore Mode** - AI-powered playlist enhancement
- [x] **User Taste Analysis** - Analyze listening patterns and preferences
- [x] **Smart Recommendations** - Discover new music based on your taste
- [x] **Enhanced Playlist Creation** - Combine selected playlists with AI discoveries

### Phase 3: Advanced Features 🚧
- [ ] Playlist Detail View with Track Previews
- [ ] Playlist Editing Capabilities
- [ ] Social Features - Share and collaborate on playlists
- [ ] Advanced Audio Analysis - Tempo, key, and mood matching

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Getting Started

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass
- Follow conventional commit messages

### Code Style

This project follows [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

- Use `dart format` for formatting
- Follow naming conventions
- Add documentation for public APIs
- Keep functions small and focused

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Spotify** for their comprehensive Web API
- **Google** for the powerful Gemini AI
- **Flutter Team** for the amazing framework
- **Open Source Community** for the incredible packages


---

<div align="center">
  <p>Made with ❤️ by <strong>2Noob2Code</strong></p>
  <p>⭐ Star this repo if you found it helpful!</p>
</div>