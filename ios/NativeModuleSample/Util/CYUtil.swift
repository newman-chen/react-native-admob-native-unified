//
//  CYUtil.swift
//  ReactNativeTest2
//
//  Created by Bill Lin on 2018/6/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

import UIKit

class CYUtil: NSObject {
  static var LOG_TAG = "sambow"
  static func LOG(_ items: Any...)
  {
    print(LOG_TAG, items)
  }
}
