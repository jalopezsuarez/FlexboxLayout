//
//  ViewController.swift
//  Demo
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

class ViewController: UIViewController {

  var treeView: UIView? = nil
  var toggle = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.prepareViewHierarchy()
  }

  func prepareViewHierarchy() {

    self.treeView?.removeFromSuperview()

    self.treeView = UIView().define(children: [
      UIView().define { view in
        view.backgroundColor = UIColor.d
        view.layer.cornerRadius = 24.0
        view.useFlexbox = true
        view.layout_width = 48
        view.layout_height = 48
        view.layout_marginAll = 16
        view.layout_alignSelf = .center
        view.layout_justifyContent = .flexStart
      },
      UIView().define(children: [
        UILabel().define { view in
          view.text = "Lorem Ipsum"
          view.textAlignment = .left
          view.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
          view.useFlexbox = true
          view.layout_alignSelf = .flexStart
        },
        UILabel().define { view in
          view.text = "--"
          view.textAlignment = .left
          view.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
          view.numberOfLines = 0
          view.useFlexbox = true
          view.layout_alignSelf = .flexStart
          view.layout_maxHeight = 96
        }
      ]) { view in
        view.backgroundColor = UIColor.a
        view.useFlexbox = true
        view.layout_alignSelf = .center
        view.layout_flexGrow = 0.8
        view.layout_paddingAll = 8
      },
      UILabel().define { view in
        view.text = "88:88"
        view.textColor = UIColor.f
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        view.useFlexbox = true
        view.layout_minWidth = 64
        view.layout_alignSelf = .center
        view.layout_flexShrink = 0.2
        view.layout_paddingAll = 8
        view.layout_marginAll = 2

      }
    ]) { view in
      view.backgroundColor = UIColor.white
      view.layer.borderColor = UIColor.b.cgColor
      view.layer.borderWidth = 2.0
      view.useFlexbox = true
      view.layout_justifyContent = .center
      view.layout_alignSelf = .stretch
      view.layout_marginAll = 8
      view.layout_flexDirection = .row
      view.layout_maxWidth = self.view.bounds.width - 40
    }

    self.view.addSubview(self.treeView!)
  }

  override func viewDidLayoutSubviews() {
    self.render()
  }

  func render() {
    self.treeView?.render()
    self.treeView?.center = self.view.center
  }

  func injected() {
    self.prepareViewHierarchy()
    self.render()
  }
  
  
}


