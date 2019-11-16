# StateRestorationDemo

#### Swift app to demonstrate state preservation and restoration APIs.

![](https://raw.githubusercontent.com/shagedorn/StateRestorationDemo/master/Presentation/app_screenshot.png)

Created for a presentation at CocoaHeads Dresden on 09 July 2014. The Deckset presentation (rendered as PDF and the Markdown source) is included in the repository. Feel free to contact me for questions: [@hagidd](http://twitter.com/hagidd).

Last verified with Xcode 10 and iOS 12.0. The app is written in Swift 4.2.


## Tags 

Tags outline the various steps to enable state restoration in iOS apps:

+ `NO_STATE_RESTORATION`: The app without state restoration
+ `STATE_RESTORATION_OPT_IN`: The app generally enables state restoration, but does not implement it yet
+ `RESTORATION_IDENTIFIERS`: The app sets restoration identifiers on view controllers, but the controllers are not restored successfully yet
+ `BASIC_STATE_RESTORATION`: Initially created view controllers are restored successfully
+ `RESTORATION_CLASS`: Non-initial view controllers are restored, too
+ `STATE_ENCODING`: View controllers restore their views' state
+ `SIZE_CLASSES`: The window's size classes are preserved

**Note:** Both to improve the project and to support the current version of Swift, there have been major updates that are not reflected by the tagged commits. The tags are still helpful to follow the various steps, but you should use the latest commit on `master` for a working version.

## Limitations

By default, state restoration happens synchronously at launch on the main queue. While you can [move work off the main queue](https://developer.apple.com/documentation/uikit/uiapplication/1623060-extendstaterestoration), it will still kick in right after app launch and should finish as quickly as possible, which means it cannot easily be adopted by apps that need to log in or fetch a new session on every launch.

## Other Resources

Apple also published two very helpful sample projects:

[Apple Sample Code: State Restoration](https://developer.apple.com/library/content/samplecode/StateRestore/)

[Apple Sample Code: State Restoration of Child View Controllers](https://developer.apple.com/library/content/samplecode/StateRestoreChildViews/)

On iOS 13+, it is recommended to (re)store your model-level state using `NSUserActivity`. You can get started by reading [this blog post](https://www.vadimbulavin.com/ios13-ipados-uiscene-state-restoration-with-nsuseractivity-and-swiftui/).
