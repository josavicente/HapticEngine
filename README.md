# HapticEngine

Haptic Engine is a wrapper of [`Core Haptics`](https://developer.apple.com/documentation/corehaptics) to make it easier to create haptic taps combinations.

## Usage

```swift
import HapticEngine

let engine = HapticsEngine()

try? engine.launch(intensity: 0.2, sharpness: 0.8)


```

### Integration with SwiftUI

`HapticEngine` use Combine powerfull framework with `@Environment`. Create you own `engine` and pass as an environment object on root App View. Then, yo can access on any of your views Like that

```swift
import SwiftUI
import HapticEngine

@main
struct ExampleApp: App {
    

    let haptics = HapticEngine()
    
    var body: some Scene {
        WindowGroup {
            RuinNavigation()
                .environmentObject(haptics)   
        }
    }
}

import HapticEngine

struct SomeView: View {
    
  
    @EnvironmentObject private var haptics: HapticEngine
    .
    .
    .
    .
    .
}
```
## Installation

#### SwiftPM

```swift
dependencies: [
    .package(url: "https://github.com/josavicente/HapticEngine", from: "0.0.1")
],
targets: [
    .target(name: "YourTarget", dependencies: ["HapticEngine"])
]
```