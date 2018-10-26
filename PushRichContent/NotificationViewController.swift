//
//  NotificationViewController.swift
//  PushRichContent
//
//  Created by NETBIZ on 26/10/18.
//  Copyright © 2018 Netbiz.in. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        self.preferredContentSize = CGSize.init(width: 300, height: 200)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        if let urlImageString = content.userInfo["urlImageString"] as? String {
            if let url = URL(string: urlImageString) {
                URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                    if let _ = error {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}
extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}
