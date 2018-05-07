//
//  VCAlertDelegate.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 07.05.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation
import UIKit

protocol VCAlertDelegate: Alertable
{
    var alertDelegate: Alertable? { get set }
}
