# FlexboxLayout
[![Swift](https://img.shields.io/badge/swift-3-orange.svg?style=flat)](#)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-iOS | macOS -lightgrey.svg?style=flat)](#)
[![Build](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://opensource.org/licenses/MIT)

Port of Facebook's [css-layout](facebook css layout) to Swift + *UIView* extension.


![GitHub Logo](doc/cell.jpg)
TL;DR
This layout and style is expressed in code in the following declarative fashion:


```swift

let view = UIView().define(children: [
  UIView().define { view in
    view.backgroundColor = UIColor.blue
    view.layer.cornerRadius = 24.0
    view.style.dimensions = (48, 48)
    view.style.margin = defaultMargin
    view.style.alignSelf = .center
    view.style.justifyContent = .flexStart
  },
  UIView().define(children: [
    UILabel().define { view in
      view.text = "TITLE"
      view.textAlignment = .center
      view.font = ...
      view.style.alignSelf = .flexStart
    },
    UILabel().define { view in
      view.text = "SUBTITLE"
      view.textAlignment = .left
      view.font = ...
      view.style.alignSelf = .flexStart
    }
  ]) { view in
    view.backgroundColor = grayColor()
    view.style.alignSelf = .center
    view.style.flex = 0.8
  },
  UILabel().define { view in
    view.backgroundColor = UIColor.red
    view.text = "88:88"
    view.textAlignment = .center
    view.style.minDimensions = (64, 54)
    view.style.alignSelf = .flexEnd
    view.style.flex = 0.2
    view.style.margin = defaultMargin
  }
]) { view in
  view.backgroundColor = UIColor.white
  view.style.justifyContent = .center
  view.style.alignSelf = .stretch
  view.style.margin = defaultMargin
  view.style.flexDirection = .row
}

view.render()

```

The  `configure` function stores the configuration closure for each view and these are recursively re-applied whenever the `render` function is called on the root view.

This allows you to have a React-inspired design of your view logic.


 
