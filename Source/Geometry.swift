//
//  Geometry.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 28/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias EdgeInsets = UIEdgeInsets
#else
    import AppKit
    public typealias EdgeInsets = NSEdgeInsets
#endif

extension Node {
    
    //  Apply the layout to the given view hierarchy.
    public func apply(_ view: ViewType) {
        
        let x = layout.position.left.isNormal ? CGFloat(layout.position.left) : 0
        let y = layout.position.top.isNormal ? CGFloat(layout.position.top) : 0
        let w = layout.dimension.width.isNormal ? CGFloat(layout.dimension.width) : 0
        let h = layout.dimension.height.isNormal ? CGFloat(layout.dimension.height) : 0
        
        let frame = CGRect(x: x, y: y, width: w, height: h)
        view.applyFrame(frame.integral)
        
        if let children = self.children {
            for (s, node) in zip(view.subviews, children) {
                let subview = s as ViewType
                node.apply(subview)
            }
        }
    }
}

public extension CGSize {
    
    //  Undefined size
    public static let undefined = CGSize(width: CGFloat(Undefined), height: CGFloat(Undefined))
    
    //  Convenience constructor
    public init(_ width: CGFloat,_ height: CGFloat = CGFloat(Undefined)) {
        self.init(width: width, height: height)
    }
    
    //  Returns true is this value is less than .19209290E-07F
    public var isZero: Bool {
        return self.width < CGFloat(Float.ulpOfOne) && self.height < CGFloat(Float.ulpOfOne)
    }
}

prefix operator ~

public prefix func ~(number: CGFloat) -> Float {
    return Float(number)
}

public prefix func ~(size: CGSize) -> Dimension {
    return (width: ~size.width, height: ~size.height)
}

public prefix func ~(insets: EdgeInsets) -> Inset {
    return (left: ~insets.left, top: ~insets.top, right: ~insets.right, bottom: ~insets.bottom, start: ~insets.left, end: ~insets.right)
}

extension Float {
    internal var isDefined: Bool {
        return self > 0 && self < 4096
    }
}

//MARK: - Internal and Private

internal func zeroIfNan(_ value: Float) -> CGFloat {
    return value.isDefined ? CGFloat(value) : 0
}

internal func zeroIfNan(_ value: CGFloat) -> CGFloat {
    return Float(value).isDefined ? value : 0
}

internal func maxIfNaN(_ value: Float) -> CGFloat {
    return value.isDefined ? CGFloat(value) : CGFloat(Float.greatestFiniteMagnitude)
}

internal func sizeZeroIfNan(_ size: Dimension) -> CGSize {
    return CGSize(width: CGFloat(zeroIfNan(size.0)), height: CGFloat(zeroIfNan(size.1)))
}

internal func sizeZeroIfNan(_ size: CGSize) -> CGSize {
    return CGSize(width: CGFloat(zeroIfNan(size.width)), height: CGFloat(zeroIfNan(size.height)))
}

internal func sizeMaxIfNan(_ size: Dimension) -> CGSize {
    return CGSize(width: CGFloat(maxIfNaN(size.0)), height: CGFloat(maxIfNaN(size.1)))
}

private extension UIView {
    
    func applyFrame(_ frame: CGRect) {
        self.frame = frame
    }
}

