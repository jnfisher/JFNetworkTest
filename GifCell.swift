//
//  GifCell.swift
//  JFNetworkTest
//
//  Created by John Fisher on 6/4/16.
//  Copyright © 2016 John Fisher. All rights reserved.
//

import UIKit
import FLAnimatedImage
import Alamofire

class GifCell: UITableViewCell {
  @IBOutlet var tags: UILabel!
  @IBOutlet var animatedImageView: FLAnimatedImageView!
  
  var pendingRequest:Request? = nil
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    pendingRequest?.cancel()
    super.prepareForReuse()
  }
}