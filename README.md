# CurrencyExchanger
A Sample Project to for computing the exchange of currencies 

## This is a simple app that only fetch the exchange rate of other currencies 
[Source](https://api.exchangeratesapi.io/latest)

## Architecture Used
MVVM + [Coordinator Pattern](http://khanlou.com/2015/10/coordinators-redux/) + Programmatic UI

#### The Choice of using Coordinator is actually based on my experience on how to architecture the app with minimal used of boilerplate and to solve the navigation flow of the app for the developer to be clear on what will be the next screen to show. 

### The Main app is actually dissected with these parts
- Coordinator
	- The flow navigation of the app
- VC
	- logic controller of the app
- View
	- The class of the app on where the UI is being designed programmatically
### Programmatic UI Rocks!
A Storyboard full of vcs is really slow to load and use, thats why I use it with the creation of UI in my project, the traditional programmatic UI creation is actually confusing and tends to bloat the class file thats why Im using [SnapKit](https://github.com/SnapKit/SnapKit) for the [DSL](https://www.swiftbysundell.com/articles/building-dsls-in-swift/)

## Pods Used

[SnapKit](https://github.com/SnapKit/SnapKit)
- DSL for Programmatic UI

[Moya](https://github.com/Moya/Moya)
- Networking abstraction layer that sufficiently encapsulates actually calling Alamofire directly. It should be simple enough that common things are easy, but comprehensive enough that complicated things are also easy.

[RealmSwift](https://realm.io/docs/swift/latest/)
- I used Realm in this project because of the ease of use and I think it is suitable for a small project that doesn't really rely heavily on a complex threading

- Data Persistence(local storage)

### How To Install

1. Cocoapods needs to be installed first on your machine

2. Clone the project

3. run in the terminal
	
	``` 
	pod install 
	``` 

4. go inside the directory and 
	``` 
	open CurrencyExchanger.xcworkspace
	```

5. Build and Run
