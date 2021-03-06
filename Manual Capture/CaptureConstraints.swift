//
//  CaptureConstraints.swift
//  Capture
//
//  Created by Jean Flaherty on 11/22/15.
//  Copyright © 2015 mobileuse. All rights reserved.
//

import UIKit

typealias Constraint = NSLayoutConstraint
typealias Constraints = [NSLayoutConstraint]
typealias StyleConstraints = (UIView) -> Constraints


extension NSLayoutConstraint {
    convenience init(item: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, toItem: UIView? = nil, attribute toAttribute: NSLayoutAttribute = .NotAnAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(item: item, attribute: attribute,
            relatedBy: relation,
            toItem: toItem, attribute: toAttribute,
            multiplier: multiplier, constant: constant)
    }
    
}

struct Style {
    typealias StyleConstraints = ([UIView]) -> Constraints
    let constraints: StyleConstraints
    
    init(constraints: StyleConstraints){
        self.constraints = constraints
    }
    
    static let FillSuperview = Style { let view = $0[0]
        guard let superview = view.superview else { return [] }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = superview.bounds
        
        let horizontal = Constraint.constraintsWithVisualFormat("H:|[view]|",
            options: [.AlignAllCenterX, .AlignAllCenterY],
            metrics: nil, views: ["view" : view])
        let verticle = Constraint.constraintsWithVisualFormat("V:|[view]|",
            options: [.AlignAllCenterX, .AlignAllCenterY],
            metrics: nil, views: ["view" : view])
        
        return horizontal + verticle
    }
    
}

extension Style {
    
    static let CaptureButtonContainer = Style(){ let container = $0[0]
        guard let superview = container.superview else { return [] }
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = Constraint(item: container, attribute: .CenterY,
            toItem: superview, attribute: .CenterY)
        let rightMargin = Constraint(item: container, attribute: .RightMargin,
            toItem: superview, attribute: .RightMargin,
            constant: -10)
        let width = Constraint(item: container, attribute: .Width, constant: 60)
        let height = Constraint(item: container, attribute: .Height, constant: 60)
        
        return [centerY, rightMargin, width, height]
    }
    
    static let Toolbar = Style(){ let toolbar = $0[0]
        guard let superview = toolbar.superview else { return [] }
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        //toolbar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
//        toolbar.layer.borderWidth = 1.0
//        toolbar.layer.borderColor = UIColor.whiteColor().CGColor        
        
        let x = Constraint.constraintsWithVisualFormat("H:|[toolbar(40)]",
            options: [.AlignAllCenterX, .AlignAllCenterY],
            metrics: nil, views: ["toolbar" : toolbar])
        let y = Constraint.constraintsWithVisualFormat("V:|[toolbar]|",
            options: [.AlignAllCenterX, .AlignAllCenterY],
            metrics: nil, views: ["toolbar" : toolbar])
        
        return x + y
    }
    
    static let Capturebar = Style(){ let capturebar = $0[0]
        guard let superview = capturebar.superview else { return [] }
        
        capturebar.translatesAutoresizingMaskIntoConstraints = false
        //capturebar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//        capturebar.layer.borderWidth = 1.0
//        capturebar.layer.borderColor = UIColor.whiteColor().CGColor
        
        let x = Constraint.constraintsWithVisualFormat("H:[capturebar(80)]|",
            options: [.AlignAllCenterX, .AlignAllCenterY],
            metrics: nil, views: ["capturebar" : capturebar])
        let y = Constraint.constraintsWithVisualFormat("V:|[capturebar]|",
            options: [.AlignAllCenterX, .AlignAllCenterY],
            metrics: nil, views: ["capturebar" : capturebar])
        
        return x + y
    }
    
}

extension UIView {
    func layout(style: Style, views: UIView...){
        views.forEach { view in addSubview(view) }
        addConstraints(style.constraints(views))
    }
}