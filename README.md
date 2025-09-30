# 🎵 Spotify Connect App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Spotify-1DB954?style=for-the-badge&logo=spotify&logoColor=white" alt="Spotify">
  <img src="https://img.shields.io/badge/Google%20Gemini-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Gemini">
  <img src="https://img.shields.io/badge/BLoC-00D2FF?style=for-the-badge&logo=flutter&logoColor=white" alt="BLoC">
</div>

<div align="center">
  <h3>🎶 Your Personal AI-Powered Music Intelligence Platform</h3>
  <p>A cutting-edge Flutter application that combines Spotify integration with advanced AI to analyze your music taste, generate intelligent playlists, and discover new music tailored to your preferences</p>
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
- 🎨 **AI-Powered Playlist Generation** - Create custom playlists based on mood and context
- 🚀 **Explore Mode** - Smart discovery engine that enhances playlists with AI recommendations
- 🧠 **Analyze Me** - Deep music taste analysis with personalized insights and music DNA
- 💾 **Secure Token Storage** - Encrypted credential management with auto-refresh
- 🔄 **Intelligent Caching** - Smart data caching for optimal performance
- 📊 **Music Intelligence** - Advanced audio feature analysis and preference learning

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
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language with null safety

### Architecture & State Management
- **Clean Architecture** - Domain-driven design with clear separation
- **BLoC Pattern** - Business Logic Component for predictable state management
- **flutter_bloc** - Official BLoC implementation
- **equatable** - Value equality for immutable objects

### Data & Networking
- **dio** - Powerful HTTP client with interceptors
- **flutter_secure_storage** - Encrypted local storage for sensitive data
- **JSON Serialization** - Custom serialization for complex data structures

### Dependency Injection
- **injectable** - Code generation for dependency injection
- **get_it** - Service locator pattern implementation
- **build_runner** - Code generation automation

### Authentication & Integration
- **app_links** - Deep linking and URL scheme handling
- **Spotify Web API** - Music data and playlist management
- **Google Gemini AI** - Natural language processing for mood analysis

### Performance & Caching
- **Smart Caching System** - Custom 7-day cache implementation
- **Lazy Loading** - Efficient resource management
- **Value Clamping** - Proper data validation and UI safety

## 🧠 AI & Music Intelligence

The app combines multiple AI technologies to create a comprehensive music intelligence platform:

### 🎯 Dual AI System

**1. Google Gemini AI** - Natural Language Processing
- Interprets mood and context descriptions
- Generates playlist names and descriptions
- Processes complex user preferences
- Creates contextual recommendations

**2. Spotify Recommendations API** - Music Intelligence
- Analyzes audio features (energy, danceability, valence)
- Provides seed-based recommendations
- Matches musical characteristics
- Discovers similar artists and tracks

### 🔬 Advanced Analysis Pipeline

**Taste Profile Generation:**
```
User Playlists → Audio Feature Extraction → Pattern Recognition → Taste Profile
     ↓                    ↓                      ↓                ↓
Selected Only    Energy/Dance/Mood Values    Genre Preferences   Music DNA
```

**Smart Discovery Process:**
```
Taste Profile + User Mood → Spotify Recommendations API → Enhanced Playlist
     ↓              ↓                    ↓                      ↓
Audio Features   Context Analysis    Seed Tracks           60% Original + 40% New
```

### 🎵 Example AI Interactions

**Explore Mode Prompts:**
- "feeling nostalgic and contemplative" → Generates low-energy, high-valence recommendations
- "pumped up for workout" → High-energy, high-danceability discoveries
- "relaxing after work" → Low-energy, moderate-valence chill tracks
- "creative coding session" → Instrumental, moderate-energy focus music

**Analyze Me Insights:**
- "The Energizer - You love upbeat, high-energy music that gets you moving!"
- "The Contemplator - You prefer calm, introspective music for deep thinking."
- "The Balanced Listener - You appreciate diverse musical moods and styles."

## 🚀 Explore Mode - Smart Music Discovery

**Explore Mode** transforms your regular playlist generation into an intelligent music discovery experience. Simply toggle it ON to unlock AI-powered recommendations based on your unique taste profile.

### 🎯 How Explore Mode Works

1. **Toggle Activation** 🔄
   - Simple switch on the home page
   - Visual feedback when enabled/disabled
   - Seamless integration with existing workflow

2. **Intelligent Analysis** 🧠
   - Analyzes ONLY your selected playlists (not your entire library)
   - Extracts audio features: energy, danceability, mood patterns
   - Builds real-time taste profile from your selections

3. **Smart Discovery** ✨
   - Uses Spotify's Recommendations API
   - Finds new songs matching your analyzed preferences
   - Combines original tracks with AI discoveries

4. **Enhanced Generation** 🎵
   - Creates playlists with 60% original + 40% discovered tracks
   - Intelligent track arrangement for optimal flow
   - Mood-matched recommendations

### 🎮 User Experience

**When Explore Mode is OFF:**
- Standard playlist generation
- Uses only selected playlist tracks
- Quick and familiar workflow

**When Explore Mode is ON:**
- Enhanced with AI discoveries
- Input hint changes to "Describe your mood (Explore Mode ON)..."
- Send button icon changes to explore (🔍)
- Generates enriched playlists with new music

---

## 🧠 Analyze Me - Your Music DNA

**Analyze Me** provides deep insights into your music personality through comprehensive taste analysis and intelligent caching for instant results.

### 🔬 Advanced Music Intelligence

1. **Music DNA Profiling** 🧬
   - Visual DNA strands showing energy, danceability, and mood levels
   - Gradient-based design with realistic percentage calculations (0-100%)
   - Color-coded indicators for different preference levels

2. **Audio Features Analysis** 📊
   - Detailed breakdown of your listening patterns
   - Progress bars with proper value clamping
   - Descriptive insights for each audio feature

3. **Genre Universe** 🌌
   - Discovers your preferred genres from playlist names
   - Beautiful gradient genre tags
   - Expandable genre exploration

4. **Listening Insights** 💡
   - Music diversity scoring
   - Artist preference tracking
   - Personalized music personality description

### 🚀 Smart Caching System

- **7-Day Cache**: Analysis results cached for one week
- **Instant Loading**: Subsequent visits load immediately from cache
- **Force Refresh**: Manual refresh button for updated analysis
- **Performance Optimized**: Reduces API calls and improves responsiveness

### 🎨 Visual Features

- **Responsive UI**: Prevents overflow with proper constraints
- **Smooth Animations**: Fade-in effects and smooth transitions
- **Spotify Design**: Consistent with Spotify's visual language
- **Error Handling**: Graceful error states with retry options

---

## 📱 Complete User Workflows

### Explore Mode Workflow
```
🏠 Home Screen
├── 🔄 Toggle "Explore Mode" ON
├── ✅ Select 2-3 playlists (e.g., "Workout", "Chill")
├── 💭 Enter mood: "energetic but focused"
├── 🔍 Tap generate (explore icon appears)
└── 🎵 Receive 30-song playlist:
    ├── 18 songs from your selected playlists
    └── 12 AI-discovered songs matching your taste
```

### Analyze Me Workflow
```
🏠 Home Screen
├── 🧠 Tap brain icon in top-right
├── ⚡ First visit: Analysis runs (30-60 seconds)
│   ├── 📊 Analyzes all your playlists
│   ├── 💾 Caches results for 7 days
│   └── 🎯 Generates music DNA profile
├── 🔄 Subsequent visits: Instant load from cache
└── 📈 View comprehensive analysis:
    ├── 🧬 Music DNA visualization
    ├── 📊 Audio features breakdown
    ├── 🎭 Genre preferences
    ├── 💡 Listening insights
    └── 🎯 Music personality description
```

### Cache Management
```
📱 Analyze Me Screen
├── 🔄 "Refresh Analysis" button
│   ├── Forces new analysis
│   ├── Updates cache with fresh data
│   └── Reflects recent listening changes
├── ⏰ Auto-expiry after 7 days
└── 🚀 Instant loading for cached results
```

## 📂 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── app_colors.dart            # Spotify-themed color constants
│   └── injection/                  # Dependency injection setup
├── feature/
│   └── spotify_connect/
│       ├── data/                   # Data layer
│       │   ├── datasources/        # Remote data sources
│       │   │   ├── spotify_auth_remote_data_source.dart
│       │   │   ├── spotify_data_source.dart
│       │   │   └── spotify_playlist_remote_data_source.dart
│       │   ├── models/             # Data models & DTOs
│       │   │   ├── playlist_model.dart
│       │   │   ├── token_model.dart
│       │   │   └── usermodel.dart
│       │   ├── services/           # External services
│       │   │   ├── gemini_service.dart
│       │   │   └── taste_profile_cache_service.dart  # 🆕 Caching
│       │   └── repositories/       # Repository implementations
│       ├── domain/                 # Domain layer
│       │   ├── entities/           # Business entities
│       │   │   ├── auth_token.dart
│       │   │   ├── enhanced_playlist.dart           # 🆕 Explore Mode
│       │   │   ├── explore_mode_request.dart        # 🆕 Explore Mode
│       │   │   ├── user_taste_profile.dart          # 🆕 Analyze Me
│       │   │   ├── generated_playlist.dart
│       │   │   ├── playlist_entity.dart
│       │   │   ├── track.dart
│       │   │   └── user_profile.dart
│       │   ├── repositories/       # Repository interfaces
│       │   └── usecases/           # Business use cases
│       │       ├── analyze_user_taste.dart          # 🆕 Music Intelligence
│       │       ├── generate_enhanced_playlist.dart  # 🆕 Explore Mode
│       │       ├── authenticate_user.dart
│       │       ├── create_playlist.dart
│       │       ├── generate_mood_playlist.dart
│       │       └── get_user_playlist.dart
│       └── presentation/           # Presentation layer
│           ├── bloc/               # BLoC state management
│           │   ├── auth/           # Authentication BLoC
│           │   ├── explore_mode/   # 🆕 Explore Mode BLoC
│           │   ├── playlist_generation/  # Enhanced generation
│           │   └── playlist_selection/
│           ├── screens/            # UI screens
│           │   ├── analyze_me_screen.dart     # 🆕 Music Analysis
│           │   ├── explore_mode_screen.dart   # 🆕 (Legacy)
│           │   ├── home_screen.dart           # Enhanced with toggles
│           │   ├── login_screen.dart
│           │   └── splash.dart
│           └── widgets/            # Reusable widgets
│               ├── analyze_me_widgets.dart    # 🆕 Analysis UI
│               ├── explore_mode_widgets.dart  # 🆕 (Legacy)
│               ├── playlist_card.dart
│               └── playlist_list.dart
└── main.dart                       # App entry point
```

### 🆕 New Components Added

**Intelligence Features:**
- `TasteProfileCacheService` - Smart caching with 7-day expiry
- `AnalyzeUserTaste` - Music taste analysis engine
- `GenerateEnhancedPlaylist` - AI-powered playlist enhancement
- `ExploreModeBloc` - State management for music intelligence
- `AnalyzeMeScreen` - Comprehensive taste analysis UI

**Enhanced Entities:**
- `UserTasteProfile` - Music DNA and preference data
- `EnhancedPlaylist` - Playlist with discovery metadata
- `ExploreModeRequest` - Configuration for enhanced generation

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
- [x] Spotify OAuth Authentication with Deep Linking
- [x] User Profile Display and Management
- [x] Playlist Discovery and Browsing
- [x] AI-Powered Playlist Generation
- [x] Secure Token Storage with Auto-Refresh

### Phase 2: Intelligence Features ✅
- [x] **Explore Mode** - Smart music discovery toggle
- [x] **Analyze Me** - Comprehensive music taste analysis
- [x] **Music DNA Profiling** - Visual audio feature representation
- [x] **Intelligent Caching** - 7-day cache with force refresh
- [x] **Smart Recommendations** - Spotify API-powered discoveries
- [x] **Enhanced UI/UX** - Overflow protection and proper value clamping

### Phase 3: Advanced Analytics 🚧
- [ ] **Real-time Audio Analysis** - Live Spotify Audio Features integration
- [ ] **Listening History Tracking** - Temporal pattern analysis
- [ ] **Mood-based Recommendations** - Context-aware suggestions
- [ ] **Social Music Intelligence** - Compare taste profiles with friends

### Phase 4: Premium Features 🔮
- [ ] **Playlist Collaboration** - Share and co-create playlists
- [ ] **Advanced Filtering** - Tempo, key, and mood-based filtering
- [ ] **Export Capabilities** - Backup and migrate playlists
- [ ] **Music Discovery Insights** - Track recommendation success rates

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

## 🎯 Key Features Highlights

### 🚀 Explore Mode
- **Smart Toggle**: Simple ON/OFF switch for enhanced generation
- **Selective Analysis**: Analyzes only selected playlists, not entire library
- **Real-time Discovery**: Finds new music based on current selections
- **Seamless Integration**: Works within existing playlist generation flow

### 🧠 Analyze Me
- **7-Day Caching**: Instant loading with weekly refresh cycle
- **Music DNA**: Visual representation of audio preferences
- **Personality Insights**: AI-generated music personality descriptions
- **Performance Optimized**: Efficient caching reduces API calls

### 🔧 Technical Excellence
- **Clean Architecture**: Domain-driven design with clear separation
- **Smart Caching**: Intelligent data management for optimal performance
- **Error Resilience**: Comprehensive error handling and recovery
- **UI Safety**: Proper value clamping and overflow protection

---

## 🙏 Acknowledgments

- **Spotify** for their comprehensive Web API and Recommendations engine
- **Google** for the powerful Gemini AI natural language processing
- **Flutter Team** for the exceptional cross-platform framework
- **Open Source Community** for the incredible packages and inspiration
- **Music Intelligence Research** for audio feature analysis methodologies

---

<div align="center">
  <p>Made with ❤️ and 🎵 by <strong>2Noob2Code</strong></p>
  <p>⭐ Star this repo if you found it helpful!</p>
  
  <br>
  
  <p><em>"Where AI meets music, magic happens"</em> ✨</p>
</div>