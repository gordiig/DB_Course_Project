//
//  Alertable.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 12.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation
import UIKit

protocol Alertable
{
    func showAlert(controller: UIViewController, title: String, withString str: String)
}

extension Alertable
{
    func showAlert(controller: UIViewController, title: String = "Error", withString str: String)
    {
        showAlert(controller: controller, title: title, withString: str)
    }
}
