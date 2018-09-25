//
//  CYTemplateAdView.swift
//  NativeModuleSample
//
//  Created by Bill Lin on 2018/9/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CYTemplateAdView: UIView, GADNativeCustomTemplateAdLoaderDelegate {

  private var templateAdView: TemplateAdView!
  private var adLoader: GADAdLoader!
  private var templateAd: GADNativeCustomTemplateAd!
  
//  private var 
  
  //MARK: Layout Property
  private let imageWidth: CGFloat = 88
  private let imageWidthScale: CGFloat = 1
  private let imageMargin: CGFloat = 12
  private let textMarginTop: CGFloat = 12
  private let textMarginLeft: CGFloat = 17
  private let textMarginRight: CGFloat = 12
  private let textHeight: CGFloat = 60
  private let advertiserMarginTop: CGFloat = 80
  private let advertiserImageSize: CGFloat = 20
  private let advertiserImageMarginRight: CGFloat = 5
  
  //MARK: Property
  var adUnitID: String? = "/1018855/app_news_headline_native_7/app_news_headline_native_7_IOS"
//  var adColors: Array<String>?
  var adLayoutWithImage: Bool = true
  var templateId: String? = "11796669"//"10157685"
  
  //MARK: Closure
  var onAdFailedToLoadClosure: ((_ view: CYTemplateAdView) -> Void)?
  var onAdClickedClosure: ((_ view: CYTemplateAdView) -> Void)?
  var onAdClosedClosure: ((_ view: CYTemplateAdView) -> Void)?
  var onAdImpressionClosure: ((_ view: CYTemplateAdView) -> Void)?
  var onAdLeftApplicationClosure: ((_ view: CYTemplateAdView) -> Void)?
  var onUnifiedNativeAdLoadedClosure: ((_ view: CYTemplateAdView) -> Void)?
  
  //MARK: Event Property
  var onAdFailedToLoad: RCTBubblingEventBlock?
  var onAdClicked: RCTBubblingEventBlock?
  var onAdClosed: RCTBubblingEventBlock?
  var onAdImpression: RCTBubblingEventBlock?
  var onAdLeftApplication: RCTBubblingEventBlock?
  var onUnifiedNativeAdLoaded: RCTBubblingEventBlock?
  
  //MARK: Override Function
  override init(frame: CGRect) {
    super.init(frame: frame)
    initViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didSetProps(_ changedProps: [String]!) {
    CYUtil.LOG("didSetProps", changedProps)
    CYUtil.LOG("didSetProps", adUnitID ?? "nil")
//    CYUtil.LOG("didSetProps", adColors ?? "nil")
    CYUtil.LOG("didSetProps", adLayoutWithImage)
    CYUtil.LOG("didSetProps", templateId ?? "nil")
    if (changedProps.contains("adUnitID"))
    {
      reloadAd()
    }
//    if (changedProps.contains("adColors"))
//    {
//      if let arr = adColors
//      {
//        /**
//         * color[0] : ad's background color
//         * color[1] : ad's headline text color
//         * color[2] : ad's body text color
//         * color[3] : ad's button text color
//         * color[4] : ad's button backgroud color
//         * e.g. {['#00ffff','#ff00ff', '#660000', '#53cd12', '#66000000']}
//         */
//        if (arr.count == 5)
//        {
//          self.backgroundColor = UIColor(hexString: arr[0])
//          templateAdView.headline.textColor = UIColor(hexString: arr[1])
////          (nativeAdView.bodyView as? UILabel)?.textColor = UIColor(hexString:  arr[2])
////          (nativeAdView.callToActionView as? UIButton)?.setTitleColor(UIColor(hexString: arr[3]), for: .normal)
////          nativeAdView.callToActionView?.backgroundColor = UIColor(hexString: arr[4])
//        }
//        else
//        {
//          #if DEBUG
//          assert(false, "color array size must be 5")
//          #else
//          #endif
//        }
//      }
//    }
    if (changedProps.contains("adLayoutWithImage"))
    {
      //      layoutSubviews()
    }
//    if (changedProps.contains("templateId"))
//    {
//
//    }
  }
  
  override func layoutSubviews() {
    let selfFrame = self.frame
    let doubleMargin = imageMargin * 2
    
    let imageSize = CGSize(width: imageWidth, height: imageWidth * imageWidthScale)
    let adViewFrame = CGRect(x:0, y:0, width:selfFrame.size.width, height:imageSize.height + doubleMargin)
    
    var headlineFrame: CGRect
    var imageFrame: CGRect
    
    if adLayoutWithImage
    {
      imageFrame = CGRect(x: adViewFrame.width - imageMargin - imageSize.width, y: imageMargin, width: imageSize.width, height: imageSize.height)
      headlineFrame = CGRect(x: textMarginLeft, y: textMarginTop, width: imageFrame.minX - textMarginRight - textMarginLeft, height: textHeight)
    }
    else
    {
      imageFrame = CGRect.zero
      headlineFrame = CGRect(x: textMarginLeft, y: textMarginTop, width: adViewFrame.width - textMarginLeft - textMarginLeft, height: textHeight)
    }
    
    let iconFrame = CGRect(x: textMarginLeft, y: advertiserMarginTop, width: advertiserImageSize, height: advertiserImageSize)
    let advertiserFrame = CGRect(x: iconFrame.maxX + advertiserImageMarginRight, y: iconFrame.minY, width: headlineFrame.maxX, height: iconFrame.size.height)
    
    templateAdView.frame = adViewFrame
    templateAdView.headline.frame = headlineFrame
    templateAdView.advertiserImage.frame = iconFrame
    templateAdView.advertiserTitle.frame = advertiserFrame
    templateAdView.image.frame = imageFrame
    
    templateAdView.headline.lineBreakMode = NSLineBreakMode.byWordWrapping
    templateAdView.headline.setLineSpacing(lineSpacing: 1.5)
    templateAdView.headline.numberOfLines = 0
    templateAdView.headline.sizeToFit()
    templateAdView.headline.frame = CGRect(x: headlineFrame.minX, y: headlineFrame.minY, width: headlineFrame.width, height: templateAdView.headline.frame.height)
  }
  
  //MARK: Public Function
  func reloadAd() {
    CYUtil.LOG("reloadAd")
    CYUtil.LOG("reloadAd", adUnitID ?? "nil")
    
    if (adLoader == nil && adUnitID != nil){
      CYUtil.LOG("create loader")
      let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
      multipleAdsOptions.numberOfAds = 1
      let tempId = (adUnitID)!
      adLoader = GADAdLoader(adUnitID: tempId, rootViewController: self.parentViewController,
                             adTypes: [.nativeCustomTemplate],
                             options: [multipleAdsOptions])
      adLoader.delegate = self
      
    }
    if (adLoader == nil)
    {
      CYUtil.LOG("adLoader == nil")
      return
    }
    if templateId == nil
    {
      CYUtil.LOG("templateId == nil")
      return
    }
    let tGADRequest = GADRequest()
    //        tGADRequest.testDevices = [kGADSimulatorID, "9af3cff97fe881074866caa2257ffa7f"]
    adLoader.load(tGADRequest)
  }
  
  //MARK: Private Function
  private func initViews() {
    let nibView = Bundle.main.loadNibNamed("CYTemplateAdView", owner: nil, options: nil)?.first
    guard let tempView = nibView as? TemplateAdView else {
      assert(false, "Could not load nib file for adView")
    }
    templateAdView = tempView
    templateAdView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedAd)))
    self.addSubview(templateAdView)
    self.backgroundColor = UIColor(hexString: "f6f6f6")
  }
  
  private func setAdView(templateAd: GADNativeCustomTemplateAd){
    let closure: GADNativeAdCustomClickHandler = {
      (assetID) in
      
    }
    self.templateAd = templateAd
    templateAd.customClickHandler = closure
    
    templateAdView.headline.text = templateAd.string(forKey: "Title")
    templateAdView.image.image = templateAd.image(forKey: "Cover")?.image
    templateAdView.advertiserTitle.text = templateAd.string(forKey: "Sponsor")
    templateAdView.advertiserImage.image = templateAd.image(forKey: "")?.image
    
    layoutSubviews()
  }
  
  @objc func clickedAd()
  {
    if templateAd != nil
    {
      templateAd.performClickOnAsset(withKey: "URL")
      if let urlStr = templateAd.string(forKey: "URL"), let url = URL(string: urlStr) {
        if #available(iOS 10.0, *)
        {
          UIApplication.shared.open(url, options: [:])
        }
        else
        {
          UIApplication.shared.openURL(url)
        }
      }
    }
  }
  
  //MARK: GADNativeCustomTemplateAdLoaderDelegate
  func adLoader(_ adLoader: GADAdLoader, didReceive nativeCustomTemplateAd: GADNativeCustomTemplateAd) {
//    CYUtil.LOG("adLoader success", "headline", nativeCustomTemplateAd.)
    setAdView(templateAd: nativeCustomTemplateAd)
  }
  
  func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
    CYUtil.LOG("adLoaderDidFinishLoading")
    if let closure = onUnifiedNativeAdLoadedClosure
    {
      closure(self)
    }
  }
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    CYUtil.LOG("adLoader error", error)
    CYUtil.LOG("adLoader id", adLoader.adUnitID)
    if let closure = onAdFailedToLoadClosure
    {
      closure(self)
    }
  }
  
  func nativeCustomTemplateIDs(for adLoader: GADAdLoader) -> [String] {
    CYUtil.LOG("nativeCustomTemplateIDs", templateId ?? "nil")
    return [templateId ?? ""]
  }
}
