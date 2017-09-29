//
//  UIView+Flexbox.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias ViewType = UIView
#else
    import AppKit
    public typealias ViewType = NSView
#endif

//MARK: Layout

public protocol FlexboxView { }

extension FlexboxView where Self: ViewType {
    
    //  Configure the view and its flexbox style.
    // - Note: The configuration closure is stored away and called again in the render function
    public func configure(_ closure: @escaping ((Self) -> Void), children: [ViewType]? = nil) -> Self {
        
        //runs the configuration closure and stores it away
        closure(self)
        self.internalStore.configureClosure = { [weak self] in
            if let _self = self {
                closure(_self)
            }
        } as (() -> (Void))
        
        //adds the children as subviews
        if let children = children {
            for child in children {
                self.addSubview(child)
            }
        }
        
        return self
    }
    
    //  Re-configure the view and re-compute the flexbox layout
    public func render(_ bounds: CGSize = CGSize.undefined) {
        
        #if os(iOS)
            if let cell = self as? ComponentCell { cell.renderComponent(bounds) }
        #endif
        
        func preRender(_ view: ViewType) {
            view.preRender()
            for subview in view.subviews { preRender(subview) }
        }
        
        func postRender(_ view: ViewType) {
            view.postRender()
            for subview in view.subviews { postRender(subview) }
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        preRender(self)
        self.configure()
        self.layout(bounds)
        postRender(self)
        
        let timeElapsed = (CFAbsoluteTimeGetCurrent() - startTime)*1000
        
        // - Note: 60fps means you need to render a frame every ~16ms to not drop any frames.
        // This is even more important when used inside a cell.
        if timeElapsed > 16 {
            print(String(format: "- warning: render (%2f) ms.", arguments: [timeElapsed]))
        }
    }
    
    //  Recursively apply the configuration closure to this view tree
    fileprivate func configure() {
        func configure(_ view: ViewType) {
            
            //runs the configure closure
            view.internalStore.configureClosure?()
            
            //calls it recursively on the subviews
            for subview in view.subviews {
                configure(subview)
            }
        }
        
        //the view is configured before the layout
        configure(self)
    }   
    
    internal func preRender() {
        
        // The volatile component view will recreate is subviews at every render call
        // Therefore the old subviews have to be removed
        if let volatileComponentView = self as? VolatileComponentView { volatileComponentView.preRender() }
    }
    
    internal func postRender() {
        
        // content-size calculation for the scrollview should be applied after the layout
        if let scrollView = self as? UIScrollView {
            if let _ = self as? UITableView { return }
            if let _ = self as? UICollectionView { return }
            scrollView.postRender()
        }
    }    
}

extension ViewType: FlexboxView {
    
    //  The style for this flexbox node
    public var style: Style {
        return self.flexNode.style
    }
    
    //  Wether this view has or not a flexbox node associated
    internal var hasFlexNode: Bool {
        return (objc_getAssociatedObject(self, &__flexNodeHandle) != nil)
    }
    
    //  Returns the associated node for this view.
    internal var flexNode: Node {
        get {
            guard let node = objc_getAssociatedObject(self, &__flexNodeHandle) as? Node else {
                
                //lazily creates the node
                let newNode = Node()
                newNode.measure = { (node, width, height) -> Dimension in
                    
                    var opacityIsZero = false
                    #if os(iOS)
                        opacityIsZero = self.alpha < CGFloat(Float.ulpOfOne)
                    #endif
                    
                    if self.isHidden || opacityIsZero {
                        return (0,0) //no size for an hidden element
                    }
                    
                    //get the intrinsic size of the element if applicable
                    self.frame = CGRect.zero
                    var size = CGSize.zero
                    
                    #if os(iOS)
                        if let _ = self as? ComponentView {
                            //a componentview is a flexbox node therefore we piggy back on the
                            //flexbox engine to layout it
                            
                        } else {
                            size = self.sizeThatFits(CGSize(width: CGFloat(width), height: CGFloat(height)))
                            if size.isZero {
                                size = self.intrinsicContentSize
                            }
                        }
                    #else
                        if let control = self as? NSControl {
                            size = CGSize(width: -1, height: -1)
                            control.sizeToFit()
                            size = control.bounds.size
                        }
                    #endif
                    
                    var w: Float = width
                    var h: Float = height
                    
                    if size.width > CGFloat(Float.ulpOfOne) {
                        w = ~size.width
                        let lower = ~zeroIfNan(node.style.minDimensions.width)
                        let upper = ~min(maxIfNaN(width), maxIfNaN(node.style.maxDimensions.width))
                        w = w < lower ? lower : w
                        w = w > upper ? upper : w
                    }
                    
                    if size.height > CGFloat(Float.ulpOfOne) {
                        h = ~size.height
                        let lower = ~zeroIfNan(node.style.minDimensions.height)
                        let upper = ~min(maxIfNaN(height), maxIfNaN(node.style.maxDimensions.height))
                        h = h < lower ? lower : h
                        h = h > upper ? upper : h
                    }
                    
                    if !w.isDefined && node.style.maxDimensions.width.isDefined {
                        w = node.style.maxDimensions.width
                    }
                    
                    if !h.isDefined && node.style.maxDimensions.height.isDefined {
                        h = node.style.maxDimensions.height
                    }
                    
                    if !w.isDefined && node.style.minDimensions.width.isDefined {
                        w = node.style.minDimensions.width
                    }
                    
                    if !h.isDefined && node.style.minDimensions.height.isDefined {
                        h = node.style.minDimensions.height
                    }
                    
                    return (w, h)
                }
                
                objc_setAssociatedObject(self, &__flexNodeHandle, newNode, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newNode
            }
            
            return node
        }
        
        set {
            objc_setAssociatedObject(self, &__flexNodeHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func layout(_ bounds: CGSize = CGSize.undefined) {
        
        func prepare(_ view: ViewType) {
            for subview in view.subviews.filter({ return $0.hasFlexNode }) {
                prepare(subview)
            }
        }
        
        prepare(self)
        
        func compute() {
            self.recursivelyAddChildren()
            self.flexNode.layout(~bounds.width, maxHeight: ~bounds.height, parentDirection: .inherit)
            self.flexNode.apply(self)
        }
        
        compute()
    }
    
    fileprivate func recursivelyAddChildren() {
        
        //adds the children at this level
        var children = [Node]()
        for subview in self.subviews.filter({ return $0.hasFlexNode }) {
            children.append(subview.flexNode)
        }
        self.flexNode.children = children
        
        //adds the childrens in the subiews
        for subview in self.subviews.filter({ return $0.hasFlexNode }) {
            subview.recursivelyAddChildren()
        }
    }
}

//  Support structure for the view
internal class ViewStore {
    
    //  Render will always be called with animation disabled
    internal var notAnimatable: Bool = false
    
    //  The configuration closure passed as argument
    internal var configureClosure: (() -> (Void))?
}

extension ViewType {
    
    //  Internal store for this view
    internal var internalStore: ViewStore {
        get {
            guard let store = objc_getAssociatedObject(self, &__internalStoreHandle) as? ViewStore else {
                
                //lazily creates the node
                let store = ViewStore()
                objc_setAssociatedObject(self, &__internalStoreHandle, store, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return store
            }
            return store
        }
    }
}

private var __internalStoreHandle: UInt8 = 0
private var __flexNodeHandle: UInt8 = 0
