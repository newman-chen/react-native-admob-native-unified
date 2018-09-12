//
//  CYNativeAdView.swift
//  NativeModuleSample
//
//  Created by Bill Lin on 2018/6/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//

import UIKit
import GoogleMobileAds

@objc class CYNativeAdView: UIView, GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate, GADVideoControllerDelegate {
  
  private var nativeAdView: GADUnifiedNativeAdView!
  private var adLoader: GADAdLoader!
  
  //MARK: Layout Property
  private let imageWidth: CGFloat = 88
  private let imageWidthScale: CGFloat = 1
  private let imageMargin: CGFloat = 8
  private let textMarginTop: CGFloat = 8
  private let textMarginLeft: CGFloat = 18
  private let textMarginRight: CGFloat = 10
  private let textHeight: CGFloat = 55
  private let advertiserMarginTop: CGFloat = 72
  private let advertiserImageSize: CGFloat = 20
  private let advertiserImageMarginRight: CGFloat = 5
  
  //MARK: Default Layout Property
  private let defaultLayoutMargin: CGFloat = 10
  private let defaultLayoutImageWidthScale: CGFloat = 4 / 9
  private let defaultLayoutImageScale: CGFloat = 3 / 4
  
  //MARK: Property
  var adUnitID: String?
  var adColors: Array<String>?
  var adLayoutWithImage: Bool = true
  
  //MARK: Closure
  var onAdFailedToLoadClosure: ((_ view: CYNativeAdView) -> Void)?
  var onAdClickedClosure: ((_ view: CYNativeAdView) -> Void)?
  var onAdClosedClosure: ((_ view: CYNativeAdView) -> Void)?
  var onAdImpressionClosure: ((_ view: CYNativeAdView) -> Void)?
  var onAdLeftApplicationClosure: ((_ view: CYNativeAdView) -> Void)?
  var onUnifiedNativeAdLoadedClosure: ((_ view: CYNativeAdView) -> Void)?
  
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
    CYUtil.LOG(changedProps)
    CYUtil.LOG(adUnitID ?? "nil")
    CYUtil.LOG(adColors ?? "nil")
    CYUtil.LOG(adLayoutWithImage)
    if (changedProps.contains("adUnitID"))
    {
      reloadAd()
    }
    if (changedProps.contains("adColors"))
    {
      if let arr = adColors
      {
        /**
         * color[0] : ad's background color
         * color[1] : ad's headline text color
         * color[2] : ad's body text color
         * color[3] : ad's button text color
         * color[4] : ad's button backgroud color
         * e.g. {['#00ffff','#ff00ff', '#660000', '#53cd12', '#66000000']}
         */
        if (arr.count == 5)
        {
          self.backgroundColor = UIColor(hexString: arr[0])
          (nativeAdView.headlineView as? UILabel)?.textColor = UIColor(hexString: arr[1])
          (nativeAdView.bodyView as? UILabel)?.textColor = UIColor(hexString:  arr[2])
          (nativeAdView.callToActionView as? UIButton)?.setTitleColor(UIColor(hexString: arr[3]), for: .normal)
          nativeAdView.callToActionView?.backgroundColor = UIColor(hexString: arr[4])
        }
        else
        {
          #if DEBUG
          assert(false, "color array size must be 5")
          #else
          #endif
        }
      }
    }
    if (changedProps.contains("adLayoutWithImage"))
    {
//      layoutSubviews()
    }
  }
  
  override func layoutSubviews() {
    let selfFrame = self.frame
    let doubleMargin = imageMargin * 2
    
    let imageSize = CGSize(width: imageWidth, height: imageWidth * imageWidthScale)
    let adViewFrame = CGRect(x:0, y:0, width:selfFrame.size.width, height:imageSize.height + doubleMargin)
    CYUtil.LOG(adViewFrame)
    
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
    CYUtil.LOG("sambow image", imageFrame)
    let iconFrame = CGRect(x: textMarginLeft, y: advertiserMarginTop, width: advertiserImageSize, height: advertiserImageSize)
    let advertiserFrame = CGRect(x: iconFrame.maxX + advertiserImageMarginRight, y: iconFrame.minY, width: headlineFrame.maxX, height: iconFrame.size.height)
    
    nativeAdView.frame = adViewFrame
    nativeAdView.headlineView?.frame = headlineFrame
    nativeAdView.iconView?.frame = iconFrame
    nativeAdView.advertiserView?.frame = advertiserFrame
    nativeAdView.imageView?.frame = imageFrame
    
    nativeAdView.mediaView?.frame = CGRect.zero
    nativeAdView.starRatingView?.frame = CGRect.zero
    nativeAdView.priceView?.frame = CGRect.zero
    nativeAdView.storeView?.frame = CGRect.zero
    nativeAdView.callToActionView?.frame = CGRect.zero
    nativeAdView.bodyView?.frame = CGRect.zero
    
    
    (nativeAdView.headlineView as? UILabel)?.numberOfLines = 0
    (nativeAdView.headlineView as? UILabel)?.sizeToFit()
    nativeAdView.headlineView?.frame = CGRect(x: headlineFrame.minX, y: headlineFrame.minY, width: headlineFrame.width, height: nativeAdView.headlineView?.frame.height ?? headlineFrame.height)
//    defaultLayout()
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
                             adTypes: [.unifiedNative],
                             options: [multipleAdsOptions])
      adLoader.delegate = self
      
    }
    if (adLoader == nil)
    {
      return
    }
    let tGADRequest = GADRequest()
    //        tGADRequest.testDevices = [kGADSimulatorID, "9af3cff97fe881074866caa2257ffa7f"]
    adLoader.load(tGADRequest)
  }
  
  //MARK: Private Function
  private func initViews() {
    let nibView = Bundle.main.loadNibNamed("CYNativeAdView", owner: nil, options: nil)?.first
    guard let tempView = nibView as? GADUnifiedNativeAdView else {
      assert(false, "Could not load nib file for adView")
    }
    nativeAdView = tempView
    self.addSubview(nativeAdView)
    self.backgroundColor = UIColor(hexString: "f6f6f6")
  }
  
  private func defaultLayout()
  {
    let selfFrame = self.frame
    let doubleMargin = defaultLayoutMargin * 2
    
    let adViewFrame = CGRect(x:0, y:0, width:selfFrame.size.width, height:selfFrame.size.height)
    CYUtil.LOG(adViewFrame)
    let iconSize = adViewFrame.size.width * 1 / 10
    let iconFrame = CGRect(x:defaultLayoutMargin, y:defaultLayoutMargin, width:iconSize, height:iconSize )
    
    let maxImageWidth = adViewFrame.size.width * defaultLayoutImageWidthScale
    let imageSize = CGSize(width: maxImageWidth, height: maxImageWidth * defaultLayoutImageScale)
    let imageFrame = CGRect(x: adViewFrame.width - defaultLayoutMargin - imageSize.width, y: (adViewFrame.size.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
    
    nativeAdView.frame = adViewFrame
    nativeAdView.iconView?.frame = iconFrame
    nativeAdView.imageView?.frame = imageFrame
    nativeAdView.mediaView?.frame = imageFrame
    
    nativeAdView.headlineView?.sizeToFit()
    nativeAdView.headlineView?.frame.origin = CGPoint(x:iconFrame.origin.x + iconSize + defaultLayoutMargin, y:defaultLayoutMargin)
    let headlineFrame = (nativeAdView.headlineView?.frame)!
    
    nativeAdView.advertiserView?.sizeToFit()
    nativeAdView.advertiserView?.frame.origin = CGPoint(x:headlineFrame.origin.x, y:headlineFrame.origin.y + headlineFrame.size.height)
    let advertiserFrame = (nativeAdView.advertiserView?.frame)!
    
    let startView = (nativeAdView.starRatingView as? UIImageView)!
    let startImage = startView.image
    let startSize: CGSize!
    if (startImage == nil){
      startSize = CGSize.zero
    }
    else{
      startSize = startImage?.size
    }
    let startFrame = CGRect(x: headlineFrame.origin.x, y: advertiserFrame.origin.y + advertiserFrame.size.height, width: startSize.width, height: startSize.height)
    nativeAdView.starRatingView?.frame = startFrame
    
    nativeAdView.priceView?.sizeToFit()
    let priceSize = (nativeAdView.priceView?.frame.size)!
    nativeAdView.priceView?.frame.origin = CGPoint(x:defaultLayoutMargin, y:adViewFrame.size.height - defaultLayoutMargin - priceSize.height)
    let priceFrame = (nativeAdView.priceView?.frame)!
    
    nativeAdView.storeView?.sizeToFit()
    let storeSize = (nativeAdView.storeView?.frame.size)!
    nativeAdView.storeView?.frame.origin = CGPoint(x:priceFrame.origin.x + priceSize.width + defaultLayoutMargin, y:adViewFrame.size.height - defaultLayoutMargin - storeSize.height)
    let storeFrame = (nativeAdView.storeView?.frame)!
    
    nativeAdView.callToActionView?.sizeToFit()
    let callToActionSize = (nativeAdView.callToActionView?.frame.size)!
    nativeAdView.callToActionView?.frame.origin = CGPoint(x:storeFrame.origin.x + storeSize.width + defaultLayoutMargin, y:adViewFrame.size.height - defaultLayoutMargin - callToActionSize.height)
    let callToActionFrame = (nativeAdView.callToActionView?.frame)!
    
    nativeAdView.bodyView?.frame = CGRect(x: defaultLayoutMargin, y: startFrame.origin.y + startFrame.size.height, width: imageFrame.origin.x - doubleMargin, height: callToActionFrame.origin.y - startFrame.origin.y - startFrame.size.height)
  }
  
  private func setAdView(nativeAd: GADUnifiedNativeAd){
    nativeAd.delegate = self
    nativeAdView.nativeAd = nativeAd
    
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    
    CYUtil.LOG("nativeAd.callToAction", nativeAd.callToAction ?? "nil")
    CYUtil.LOG("nativeAd.store", nativeAd.store ?? "nil")
    CYUtil.LOG("nativeAd.price", nativeAd.price ?? "nil")
    
    if let controller = nativeAd.videoController, controller.hasVideoContent() {
      // The video controller has content. Show the media view.
      if let mediaView = nativeAdView.mediaView {
        mediaView.isHidden = false
        nativeAdView.imageView?.isHidden = true
        // This app uses a fixed width for the GADMediaView and changes its height
        // to match the aspect ratio of the video it displays.
        let heightConstraint = NSLayoutConstraint(item: mediaView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: mediaView,
                                                  attribute: .width,
                                                  multiplier: CGFloat(1 / controller.aspectRatio()),
                                                  constant: 0)
        heightConstraint.isActive = true
      }
      // By acting as the delegate to the GADVideoController, this ViewController
      // receives messages about events in the video lifecycle.
      controller.delegate = self
      //      videoStatusLabel.text = "Ad contains a video asset."
      
      CYUtil.LOG(nativeAdView.imageView?.frame ?? "nil")
    }
    else
    {
      // If the ad doesn't contain a video asset, the first image asset is shown
      // in the image view. The existing lower priority height constraint is used.
      nativeAdView.mediaView?.isHidden = true
      nativeAdView.imageView?.isHidden = false
      let firstImage: GADNativeAdImage? = nativeAd.images?.first
      (nativeAdView.imageView as? UIImageView)?.image = firstImage?.image
      (nativeAdView.imageView as? UIImageView)?.contentMode = .scaleAspectFill
      (nativeAdView.imageView as? UIImageView)?.clipsToBounds = true
      //      videoStatusLabel.text = "Ad does not contain a video."
    }
    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
    if let _ = nativeAd.icon {
      nativeAdView.iconView?.isHidden = false
    } else {
      nativeAdView.iconView?.isHidden = true
    }
    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(starRating:nativeAd.starRating)
    if let _ = nativeAd.starRating {
      nativeAdView.starRatingView?.isHidden = false
    }
    else {
      nativeAdView.starRatingView?.isHidden = true
    }
    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
    if let _ = nativeAd.store {
      nativeAdView.storeView?.isHidden = false
    }
    else {
      nativeAdView.storeView?.isHidden = true
    }
    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
    if let _ = nativeAd.price {
      nativeAdView.priceView?.isHidden = false
    }
    else {
      nativeAdView.priceView?.isHidden = true
    }
    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
    if let _ = nativeAd.advertiser {
      nativeAdView.advertiserView?.isHidden = false
    }
    else {
      nativeAdView.advertiserView?.isHidden = true
    }
    // In order for the SDK to process touch events properly, user interaction
    // should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false
    
    layoutSubviews()
  }
  
  private func imageOfStars(starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
      return nil
    }
    if rating >= 5 {
      return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
      return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
      return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
      return UIImage(named: "stars_3_5")
    } else {
      return nil
    }
  }
  
  //MARK: GADUnifiedNativeAdLoaderDelegate
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    CYUtil.LOG("adLoader error", error)
    CYUtil.LOG("adLoader id", adLoader.adUnitID)
    if let closure = onAdFailedToLoadClosure
    {
      closure(self)
    }
  }
  
  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("adLoader success", "headline", nativeAd.headline ?? "nil")
    setAdView(nativeAd: nativeAd)
    //        refreshAdButton.isEnabled = true
  }
  
  func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
    CYUtil.LOG("adLoaderDidFinishLoading")
    if let closure = onUnifiedNativeAdLoadedClosure
    {
      closure(self)
    }
  }
  
  //MARK: GADUnifiedNativeAdDelegate
  func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("nativeAdDidRecordClick")
    if let closure = onAdClickedClosure
    {
      closure(self)
    }
  }
  
  func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("nativeAdDidDismissScreen")
  }
  
  func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("nativeAdWillDismissScreen")
    if let closure = onAdClosedClosure
    {
      closure(self)
    }
  }
  
  func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("nativeAdWillPresentScreen")
  }
  
  func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("nativeAdDidRecordImpression")
    if let closure = onAdImpressionClosure
    {
      closure(self)
    }
  }
  
  func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
    CYUtil.LOG("nativeAdWillLeaveApplication")
    if let closure = onAdLeftApplicationClosure
    {
      closure(self)
    }
  }
  
  //MARK: GADVideoControllerDelegate
  func videoControllerDidMuteVideo(_ videoController: GADVideoController) {
    CYUtil.LOG("videoControllerDidMuteVideo")
  }
  
  func videoControllerDidPlayVideo(_ videoController: GADVideoController) {
    CYUtil.LOG("videoControllerDidPlayVideo")
  }
  
  func videoControllerDidPauseVideo(_ videoController: GADVideoController) {
    CYUtil.LOG("videoControllerDidPauseVideo")
  }
  
  func videoControllerDidUnmuteVideo(_ videoController: GADVideoController) {
    CYUtil.LOG("videoControllerDidUnmuteVideo")
  }
  
  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    CYUtil.LOG("videoControllerDidEndVideoPlayback")
  }
}
