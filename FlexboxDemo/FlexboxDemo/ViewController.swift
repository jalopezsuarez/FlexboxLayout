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

    let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
    self.treeView =  UIView().configure({
      $0.backgroundColor = UIColor.white
      $0.layer.borderColor = UIColor.b.cgColor
      $0.layer.borderWidth = 2.0
      $0.style.justifyContent = .center
      $0.style.alignSelf = .stretch
      $0.style.margin = defaultMargin
      $0.style.flexDirection = .row
      $0.style.maxDimensions.width = ~(self.view.bounds.width - 40)
      }, children: [

        UIView().configure({
          $0.backgroundColor = UIColor.a
          $0.layer.cornerRadius = 12.0
          $0.style.dimensions = (24, 24)
          $0.style.margin = defaultMargin
          $0.style.alignSelf = .flexStart
          $0.style.justifyContent = .flexStart
        }),

        UIView().configure({
          $0.backgroundColor = UIColor.a
          $0.style.alignSelf = .center
          $0.style.flex = 0.8
          }, children: [
            UILabel().configure({
              $0.text = "Lorem Ipsum"
              $0.textAlignment = .center
              $0.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
              $0.style.alignSelf = .flexStart
              $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
            }),


            UILabel().configure({
              $0.text = "--"
              $0.textAlignment = .left
              $0.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
              $0.numberOfLines = 0
              $0.style.alignSelf = .flexStart
              $0.style.margin = (120, 6.0, 0, 0, 8.0, 0)
              $0.style.maxDimensions.height = 96
              $0.style.margin = defaultMargin
            })

          ]),

        UILabel().configure({
          $0.backgroundColor = UIColor.f
          $0.text = "88:88"
          $0.textColor = UIColor.a
          $0.textAlignment = .center
          $0.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightLight)
          $0.style.minDimensions = (64, 54)
          $0.style.alignSelf = .flexEnd
          $0.style.flex = 0.2
          $0.style.margin = defaultMargin
        })
      ])

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


