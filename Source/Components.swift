//
//  ComponentView.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 29/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

#if os(iOS)
    
    import UIKit
    
    public protocol ComponentStateType { }
    
    //MARK: - ComponentView
    
    //  When designing interfaces, break down the common design elements into reusable components
    //  with well-defined interfaces.
    //  That way, the next time you need to build some UI, you can write much less code.
    //  This means faster development time, fewer bugs, and fewer bytes down the wire.
    open class ComponentView: ViewType {
        
        //  The state of this component
        open var state: ComponentStateType? {
            didSet {
                self.didUpdateState()
            }
        }
        
        //  The configuration of this root node.
        //  - Note: Only the appearance and the node's style configuration should specified in here
        open func defaultConfiguration() {
            fatalError("Subclasses must implement the default configuration for this component.")
        }
        
        //  - Note: This method is left for the subclasses to implement
        open func constructComponent(_ state: ComponentStateType)  {
            fatalError("Subclasses must implement the component construction method.")
        }
        
        public init() {
            super.init(frame: CGRect.zero)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        fileprivate func didUpdateState() {
            guard let state = self.state else { return }
            self.constructComponent(state)
            return
        }
        
        //  Asks the view to calculate and return the size that best fits the specified size
        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            self.render(size)
            return self.bounds.size
        }
        
        //  Returns the natural size for the receiving view, considering only properties of the view itself.
        open override var intrinsicContentSize : CGSize {
            self.render(CGSize.undefined)
            return self.bounds.size
        }
    }
    
    //  Volatile components flush their view hierarchy at every call of 'render'.
    //  They're less performant but useful when the view hierarchy is dynamic and depends from
    //  some property of the state. (e.g. dynamic number of children)
    open class VolatileComponentView: ComponentView {
        
        public override init() {
            super.init()
            self.internalStore.notAnimatable = true
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.internalStore.notAnimatable = true
        }
        
        //  The volatile component view will recreate is subviews at every render call
        //  Therefore the old subviews have to be removed
        func preRender() {
            let configurationClosure = self.internalStore.configureClosure
            for view in self.subviews {
                view.removeFromSuperview()
            }
            
            configurationClosure?()
            self.constructComponent(self.state!)
            self.internalStore.configureClosure = configurationClosure
        }
    }
    
    //  Wraps a component in a 'UITableViewCell'.
    //  Set the state for the component through the 'state' property and invoke 'render' to render the underlying component.
    //  - Note: See the 'UITableView' extension.
    //  - Note: Call 'renderVisibleComponents' in 'UITableView' when the tableview bounds change.
    open class ComponentCell: UITableViewCell {
        
        //  The internal component
        open let component: ComponentView
        
        //  The state of this component
        open var state: ComponentStateType? {
            didSet {
                self.component.state = state
            }
        }
        
        //  Initialise a new cell with the given component
        public init(reuseIdentifier: String, component: ComponentView) {
            self.component = component
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(self.component)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // - Fix: Separator lines disappear between cells when reuse cells
        let CSSeparatorViewTag = 43298
        
        internal func renderComponent(_ size: CGSize? = nil) {
            let s = size ?? self.superview?.bounds.size ?? CGSize.undefined
            self.component.didUpdateState()
            self.component.render(s)
            
            // - Fix: Separator lines disappear between cells when reuse cells
            if self.viewWithTag(CSSeparatorViewTag) == nil {
                subviews.forEach { (view) in
                    if type(of: view).description().hasSuffix("SeparatorView") {
                        view.removeFromSuperview()
                        let separator = UIView(frame: view.frame)
                        separator.backgroundColor = view.backgroundColor
                        separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                        separator.tag = CSSeparatorViewTag
                        addSubview(separator)
                    }
                }
            }
        }
    }
    
    //  Wraps a component in a 'UICollectionViewCell'.
    //  Set the state for the component through the 'state' property and invoke 'render' to render the underlying component.
    //  - Note: See the 'UITableView' extension.
    //  - Note: Call 'renderVisibleComponents' in 'UITableView' when the tableview bounds change.
    open class CollectionComponentCell: UICollectionViewCell {
        
        //  The internal component
        open var component: ComponentView?
        
        //  The state of this component
        open var state: ComponentStateType? {
            didSet {
                self.component?.state = state
                
                let subviews = self.contentView.subviews
                subviews.forEach { $0.removeFromSuperview() }
                
                contentView.addSubview(self.component!)
                renderComponent(frame.size)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        internal func renderComponent(_ size: CGSize? = nil) {
            let s = size ?? self.superview?.bounds.size ?? CGSize.undefined
            self.component?.didUpdateState()
            self.component?.render(s)
        }
    }
    
#endif
