//
//  ViewController.swift
//  KLiveAppleTV
//
//  Created by sangpyo hong on 30/03/2019.
//  Copyright © 2019 sangpyo hong. All rights reserved.
//

import UIKit
import AVKit
import Kanna

struct KliveData : Codable {
    var tvgid: String = ""
    var tvgname: String = ""
    var tvglogo: String = ""
    var grouptitle: String = ""
    var channel: String = ""
    var radio: String = ""
    var link: String = ""
    
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "GridCell"
    let mainURL = "http://11.12.13.104:9801/m3u"
    
    var channels:Array<KliveData> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getM3UList()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GridViewCell
        
        cell.channel.text = self.channels[indexPath.item].channel
        cell.loadImage(url: self.channels[indexPath.item].tvglogo)
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            collectionView.bringSubviewToFront(cell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TVViewController()
        vc.url = self.channels[indexPath.item].link
        self.show(vc, sender: nil)
    }
    
    func getM3UList(){
        guard let main = URL(string: self.mainURL) else {
            print("Error: \(self.mainURL) doesn't seem to be a valid URL")
            return
        }
        do {
            let lolMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: lolMain, encoding: .utf8)
            if let m3u = doc.text{
                let m3ulink = m3u.replacingOccurrences(of: "#EXTM3U", with: "", options: .literal, range: nil)
                let links:Array<String> = m3ulink.components(separatedBy: "#EXTINF:-1")
                for link in links{
                    getKliveDataList(m3ustring: link)
                }
            }
            
        } catch let error {
            print("Error: \(error)")
        }
    }
    func getKliveDataList(m3ustring:String)
    {
        let links = m3ustring.components(separatedBy: "\n")
        if(links.count>2)
        {
            let nlinks = links[0].components(separatedBy: ",")
            var jsonlink = nlinks[0].replacingOccurrences(of: " tvg-id=", with: "\"tvgid\":", options: .literal, range: nil)
            jsonlink = jsonlink.replacingOccurrences(of: " tvg-name=", with: ",\"tvgname\":", options: .literal, range: nil)
            jsonlink = jsonlink.replacingOccurrences(of: " tvg-logo=", with: ",\"tvglogo\":", options: .literal, range: nil)
            jsonlink = jsonlink.replacingOccurrences(of: " group-title=", with: ",\"grouptitle\":", options: .literal, range: nil)
            jsonlink = jsonlink.replacingOccurrences(of: "11.12.13.104", with: "murakano99.asuscomm.com", options: .literal, range: nil)
            if(jsonlink.contains("POOQ RADIO") || jsonlink.contains("OKSUSU RADIO")){
                jsonlink = jsonlink.replacingOccurrences(of: " radio=", with: ",\"radio\":", options: .literal, range: nil)
            }
            else{
                jsonlink.append(",\"radio\":\"false\"")
            }
            
            let channel = ",\"channel\":\"\(nlinks[1])\""
            let url = ",\"link\":\"\(links[1])\""
            jsonlink = "{\(jsonlink)\(channel)\(url)}"
            let jData = Data(jsonlink.utf8)
            let decoder = JSONDecoder()
            do{
                let jsondata:KliveData = try decoder.decode(KliveData.self, from: jData)
                channels.append(jsondata)
            }
            catch {
                print(error)
            }
        }
    }
}

