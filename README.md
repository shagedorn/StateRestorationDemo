# StateRestorationDemo

#### Swift app to demonstrate state preservation and restoration APIs.

![](https://raw.githubusercontent.com/shagedorn/StateRestorationDemo/master/Presentation/app_screenshot.png =320x)

Created for a presentation at CocoaHeads Dresden on 09 July 2014. The presentation is included in the repository, the slides are currently only available in German. Feel free to contact me if English slides are of interest: [@hagidd](http://twitter.com/hagidd).

## Tags 

Tags outline the various steps to enable state restoration in iOS apps:

+ `NO_STATE_RESTORATION`: The app without state restoration
+ `STATE_RESTORATION_OPT_IN`: The app generally enables state restoration, but does not implement it yet
+ `RESTORATION_IDENTIFIERS`: The app sets restoration identifiers on view controllers, but the controllers are not restored successfully yet
+ `BASIC_STATE_RESTORATION`: Initially created view controllers are restored successfully
+ `RESTORATION_CLASS`: Non-initial view controllers are restored, too
+ `STATE_ENCODING`: View controllers restore their views' state
+ `SIZE_CLASSES`: The window's size classes are preserved
