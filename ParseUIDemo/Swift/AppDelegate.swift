/*
*  Copyright (c) 2015, Parse, LLC. All rights reserved.
*
*  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
*  copy, modify, and distribute this software in source code or binary form for use
*  in connection with the web services and APIs provided by Parse.
*
*  As with any software that integrates with the Parse platform, your use of
*  this software is subject to the Parse Terms of Service
*  [https://www.parse.com/about/terms]. This copyright notice shall be
*  included in all copies or substantial portions of the software.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
*  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
*  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
*  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
*  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

import UIKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Parse.setApplicationId("UdNpOP2XFoEiXLZEBDl6xONmCMH8VjETmnEsl0xJ", clientKey: "wNJFho0fQaQFQ2Fe1x9b67lVBakJiAtFj1Uz30A9")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        PFTwitterUtils.initializeWithConsumerKey("3Q9hMEKqqSg4ie2pibZ2sVJuv", consumerSecret: "IEZ9wv2d1EpXNGFKGp7sAGdxRtyqtPwygyciFZwTHTGhPp4FMj")

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: UIDemoViewController())
        window?.makeKeyAndVisible()

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.setupTestData()
        }

        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    // MARK: Test Data

    private func setupTestData() {
        let todoTitles = [
            "Build Parse",
            "Make everything awesome",
            "Go out for the longest run",
            "Do more stuff",
            "Conquer the world",
            "Build a house",
            "Grow a tree",
            "Be awesome",
            "Setup an app",
            "Do stuff",
            "Buy groceries",
            "Wash clothes"
        ];

        var objects: [PFObject] = Array()

        let query = PFQuery(className: "Todo")
        if let todos = query.findObjects() as? [PFObject] {
            if todos.count == 0 {
                for (index, title) in enumerate(todoTitles) {
                    let todo = PFObject(className: "Todo")
                    todo["title"] = title
                    todo["priority"] = index % 3
                    objects.append(todo)
                }
            }
        }

        let appNames = [ "Anypic", "Anywall", "f8" ]
        let appsQuery = PFQuery(className: "App")
        if let apps = appsQuery.findObjects() as? [PFObject] {
            if apps.count == 0 {
                for (index, appName) in enumerate(appNames) {
                    let bundle = NSBundle.mainBundle()
                    if let filePath = bundle.pathForResource(String(index), ofType: "png") {
                        if let data = NSData(contentsOfFile: filePath) {
                            let file = PFFile(name: filePath.lastPathComponent, data: data)
                            let object = PFObject(className: "App")
                            object["icon"] = file
                            object["name"] = appName
                            objects.append(object)
                        }
                    }
                }
            }
        }

        if objects.count != 0 {
            PFObject.saveAll(objects)
        }
    }

}
