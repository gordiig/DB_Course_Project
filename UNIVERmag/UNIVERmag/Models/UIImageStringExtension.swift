//
//  UIImageStringExtension.swift
//  UNIVERmag
//
//  Created by Dmitry Gorin on 10.04.2018.
//  Copyright © 2018 gordiig. All rights reserved.
//

import Foundation
import UIKit

public enum ImageFormat
{
    case png
    case jpeg(CGFloat)
}

extension UIImage
{
    public func base64(format: ImageFormat) -> String?
    {
        var imageData: Data?
        switch format
        {
            case .png: imageData = UIImagePNGRepresentation(self)
            case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData?.base64EncodedString()
    }
}
