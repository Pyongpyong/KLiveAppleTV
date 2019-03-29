//
//  GridViewCell.swift
//  KLiveAppleTV
//
//  Created by sangpyo hong on 30/03/2019.
//  Copyright © 2019 sangpyo hong. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var channel: UILabel!
    func loadImage(url: String){
        if let imgurl = URL(string: url){
            do{
                let imgdata = try Data(contentsOf: imgurl)
                imageView.image = UIImage(data: imgdata)
            }
            catch {
                print(error)
            }
        }
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if(self.isFocused){
            self.backgroundColor = UIColor.orange
        }
        else{
            self.backgroundColor = UIColor.gray
        }
    }
}
