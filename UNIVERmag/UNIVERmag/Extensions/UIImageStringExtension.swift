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

extension String
{
    public func imageFromBase64() -> UIImage?
    {
        guard let data = Data(base64Encoded: self) else
        {
            return nil
        }
        
        guard let img = UIImage(data: data) else
        {
            return nil
        }
        
        return img
    }
}
