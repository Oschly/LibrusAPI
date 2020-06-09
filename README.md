# LibrusKit

## Description
LibrusKit is a wrapper for one of the most popular school registers in Poland - Librus Synergia. The goal is to achieve stability, convenient error handling and easy use of it.

## Build

1. Download project and open it.


	```
	$ git clone https://github.com/Oschly/LibrusKit/
	$ cd LibrusKit

	```

2. Download, install dependencies and generate `.xcodeproj` file. Then open it.

	```	
	$ swift package update
	$ swift package generate-xcodeproj
	$ open LibrusKit.xcodeproj
	```
	
## How to use it

1. Import library.

	```swift
	import LibrusKit
	```

2. Call method to acquire `Result` type with `LKAccountsList` object.

	```swift
	LKAuthenticator.instance.getAccountsList(email:password:) { result in /* code */ }
	```

3. Implement a structure that has conformance to `RefreshCredentials` protocol.

	```swift
	struct RefreshTokenCredentials: RefreshCredentials {
		// Protocol requirements
		let token: String
		let login: String
		
		// Further code
	}
	```
	
4. Take `login` and `token` strings from chosen account in `LKAccountsList` object provided by method in step 2 and initialize struct implemented above with given data.


	```swift
	LKAuthenticator.instance.getAccountsList(email: "example@example.com",  password: "examplePassword") { result in 
		do {
			let accountList = try result.get() // open result
			let chosenAccount = accountList.accounts[0] // Take first available account
			let credentials = RefreshTokenCredentials(token: chosenAccount.token, login: chosenAccount.login)
		} catch {
			print(error)
		}
	}
	```

5. Now You can call any method that You would like to.

	```swift
	LKAPI.instance.getEvents(credentials: credentials) { result in /* your code */ }
	```
	
## Tips
1. Call all methods on background thread to avoid app's hanging.

## Notes
Project is under active development, it may work differently on release.
Right now error handling for invalid credentials doesn't work. It will be implemented soon (as most of the error handling).
