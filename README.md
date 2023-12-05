# ASLoader

ASLoader is a utility class for asynchronous loading of images and data.  
3 levels of Caching are available for different needs:
```swift
    public enum ASCacheType {
        case global, primary, main
    }
```

## Installation

Add ASLoader to your Swift package dependencies:
- With code:
```swift
dependencies: [
    .package(url: "https://github.com/YourUsername/ASLoader.git", from: "1.0.0") //Version you need
],
targets: [
    .target(name: "YourTarget", dependencies: ["ASLoader"])
]
```

- With SPM:  
 Add new package dependency with url:  
[https://github.com/YourUsername/ASLoader](https://github.com/YourUsername/ASLoader)

- With Cocoapods:  
Initialize pods in your project
```ruby
  pod init
```
Open PodFile
```ruby
  open podfile
```
Install with:
```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Your Project' do
  platform :ios, '15.1'
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'ASLoader' # <- This line added

end
```
## Usage

### 1. Import ASLoader

```swift
import ASLoader
```

### 2. Initialize ASLoader

```swift
let loader = ASLoaderClass.shared
```
### 3. Asynchronously Load Image

```swift
// Provide a placeholder image to be displayed while the actual image is being loaded
let placeholderImage = UIImage(named: "placeholder")

// Specify the URL of the image to be loaded
let imageURL = "https://example.com/image.jpg"

// Choose a cache type (optional, default is global)
let cacheType: ASLoaderClass.ASCacheType = .global

// Call the `loadImage` function
loader.loadImage(placeholderImage: placeholderImage, imageURL: imageURL, cacheType: cacheType) { result in
    switch result {
    case .success(let image):
        // Handle the loaded image
        print("Image loaded successfully")
    case .failure(let error):
        // Handle the error
        print("Error loading image:", error)
    }
}
```

### 3. Asynchronously Load Data

```swift
// Provide a placeholder value to be used while the actual data is being loaded
let placeholderData: Any = "Placeholder Data"

// Specify the URL from which data should be loaded
let dataURL = "https://example.com/data.json"

// Call the `loadData` function
loader.loadData(placeholder: placeholderData, dataURL: dataURL) { result in
    switch result {
    case let loadedData as Data:
        // Handle the loaded data
        print("Data loaded successfully:", loadedData)
    default:
        // Handle the error or placeholder value
        print("Error loading data")
    }
}
```

### 4. Cache using

#### Clear cache data

```swift
// Choose a cache type (optional, default is global)
let cacheType: ASLoaderClass.ASCacheType = .global

loader.clearImagesCache(cacheType)
```

#### Set cache data cuount limit

```swift
// Choose a cache type (optional, default is global)
let cacheType: ASLoaderClass.ASCacheType = .global
//Choose a limit of cache images
let limit: Int = 20

loader.setCacheLimit(limit, cacheType)

// Increase cache limit
increaseCacheLimit(1, cacheType)

// Decrease cache limit
decreaseCacheLimit(1, cacheType)
```





















