//
//  ExtensionImage.swift
//  FetchRecipes
//
//  Created by Fredy on 12/10/24.
//

import SwiftUI
import UIKit

/// Converts a SwiftUI `Image` view into a `UIImage` object.
///
/// This extension method wraps the SwiftUI `Image` view inside a `UIHostingController`, which is a UIKit-based controller
/// that allows SwiftUI views to be used within a UIKit context. The method renders the SwiftUI view into a `UIImage` using
/// the graphics context.
///
/// - Returns: A `UIImage` object if the conversion is successful, otherwise `nil`.
        
extension Image {
    func asUIImage() -> UIImage? {
        // Create a UIHostingController to wrap the SwiftUI Image view
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let size = controller.view.intrinsicContentSize
        
        // Set the size of the view
        view?.frame = CGRect(origin: .zero, size: size)

        // Render the SwiftUI view into a UIImage
        UIGraphicsBeginImageContextWithOptions(size, view?.isOpaque ?? true, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        // Check if the graphics context is available before rendering
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        view?.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
