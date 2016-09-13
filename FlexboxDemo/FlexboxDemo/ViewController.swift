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

    let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
    self.treeView?.removeFromSuperview()

    self.treeView = UIView().define(children: [
      UIView().define { view in
        view.backgroundColor = UIColor.d
        view.layer.cornerRadius = 24.0
        view.style.dimensions = (48, 48)
        view.style.margin = defaultMargin
        view.style.alignSelf = .center
        view.style.justifyContent = .flexStart
      },
      UIView().define(children: [
        UILabel().define { view in
          view.text = "Lorem Ipsum"
          view.textAlignment = .center
          view.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
          view.style.alignSelf = .flexStart
          view.style.margin = (0, 4.0, 0, 0, 8.0, 0)
        },
        UILabel().define { view in
          view.text = "--"
          view.textAlignment = .left
          view.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
          view.numberOfLines = 0
          view.style.alignSelf = .flexStart
          view.style.margin = (120, 6.0, 0, 0, 8.0, 0)
          view.style.maxDimensions.height = 96
          view.style.margin = defaultMargin
        }
      ]) { view in
        view.backgroundColor = UIColor.a
        view.style.alignSelf = .center
        view.style.flex = 0.8
      },
      UILabel().define { view in
        view.backgroundColor = UIColor.f
        view.text = "88:88"
        view.textColor = UIColor.a
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
        view.style.minDimensions = (64, 54)
        view.style.alignSelf = .flexEnd
        view.style.flex = 0.2
        view.style.margin = defaultMargin
      }
    ]) { view in
      view.backgroundColor = UIColor.white
      view.layer.borderColor = UIColor.b.cgColor
      view.layer.borderWidth = 2.0
      view.style.justifyContent = .center
      view.style.alignSelf = .stretch
      view.style.margin = defaultMargin
      view.style.flexDirection = .row
      view.style.maxDimensions.width = ~(self.view.bounds.width - 40)
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


