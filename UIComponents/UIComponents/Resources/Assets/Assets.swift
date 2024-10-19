// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public enum Colors {
    public static let appBlack = ColorAsset(name: "AppBlack")
    public static let appBlue = ColorAsset(name: "appBlue")
    public static let appClearBlack = ColorAsset(name: "appClearBlack")
    public static let appClearWhite = ColorAsset(name: "appClearWhite")
    public static let appDarkgrey = ColorAsset(name: "appDarkgrey")
    public static let appOrange = ColorAsset(name: "appOrange")
    public static let appPink = ColorAsset(name: "appPink")
    public static let appWhite = ColorAsset(name: "appWhite")
    public static let appPrimaryBackground = ColorAsset(name: "appPrimaryBackground")
    public static let appSecondaryBackground = ColorAsset(name: "appSecondaryBackground")
    public static let appCinder = ColorAsset(name: "appCinder")
    public static let appHeather = ColorAsset(name: "appHeather")
    public static let appRaven = ColorAsset(name: "appRaven")
    public static let appRed = ColorAsset(name: "appRed")
    public static let appYellow = ColorAsset(name: "appYellow")
    public static let appZircon = ColorAsset(name: "appZircon")
  }
  public enum Icons {
    public static let icAdjust = ImageAsset(name: "ic_adjust")
    public static let icBackup = ImageAsset(name: "ic_backup")
    public static let icDownload = ImageAsset(name: "ic_download")
    public static let icEqualizer = ImageAsset(name: "ic_equalizer")
    public static let icExportFile = ImageAsset(name: "ic_export_file")
    public static let icFile = ImageAsset(name: "ic_file")
    public static let icGallery = ImageAsset(name: "ic_gallery")
    public static let icLike = ImageAsset(name: "ic_like")
    public static let icLink = ImageAsset(name: "ic_link")
    public static let icSetting = ImageAsset(name: "ic_setting")
    public static let icShare = ImageAsset(name: "ic_share")
    public static let icSun = ImageAsset(name: "ic_sun")
    public static let icTranslateLanguage = ImageAsset(name: "ic_translate_language")
    public static let icAddress = ImageAsset(name: "ic_address")
    public static let icBack = ImageAsset(name: "ic_back")
    public static let icClock = ImageAsset(name: "ic_clock")
    public static let icClose = ImageAsset(name: "ic_close")
    public static let icComment = ImageAsset(name: "ic_comment")
    public static let icHeart = ImageAsset(name: "ic_heart")
    public static let icHome = ImageAsset(name: "ic_home")
    public static let icLogout = ImageAsset(name: "ic_logout")
    public static let icMail = ImageAsset(name: "ic_mail")
    public static let icMenu = ImageAsset(name: "ic_menu")
    public static let icMore = ImageAsset(name: "ic_more")
    public static let icPassword = ImageAsset(name: "ic_password")
    public static let icRestaurant = ImageAsset(name: "ic_restaurant")
    public static let icSend = ImageAsset(name: "ic_send")
    public static let icUser = ImageAsset(name: "ic_user")
    public static let icUsers = ImageAsset(name: "ic_users")
    public static let icWarning = ImageAsset(name: "ic_warning")
  }
  public enum Images {
    public static let imgBlueWave = ImageAsset(name: "img_blue_wave")
    public static let imgCoverMock = ImageAsset(name: "img_cover_mock")
    public static let imgEditorsPick = ImageAsset(name: "img_editors_pick")
    public static let imgEmptyBanner = ImageAsset(name: "img_empty_banner")
    public static let imgLogoFodamy = ImageAsset(name: "img_logo_fodamy")
    public static let imgOnbT1 = ImageAsset(name: "img_onb_t_1")
    public static let imgOnbT10 = ImageAsset(name: "img_onb_t_10")
    public static let imgOnbT2 = ImageAsset(name: "img_onb_t_2")
    public static let imgOnbT3 = ImageAsset(name: "img_onb_t_3")
    public static let imgOnbT4 = ImageAsset(name: "img_onb_t_4")
    public static let imgOnbT5 = ImageAsset(name: "img_onb_t_5")
    public static let imgOnbT6 = ImageAsset(name: "img_onb_t_6")
    public static let imgOnbT7 = ImageAsset(name: "img_onb_t_7")
    public static let imgOnbT8 = ImageAsset(name: "img_onb_t_8")
    public static let imgOnbT9 = ImageAsset(name: "img_onb_t_9")
    public static let imgOnboard2Banner = ImageAsset(name: "img_onboard_2_banner")
    public static let imgPaywallBanner = ImageAsset(name: "img_paywall_banner")
    public static let imgPwBannerDe = ImageAsset(name: "img_pw_banner_de")
    public static let imgPwBannerEs = ImageAsset(name: "img_pw_banner_es")
    public static let imgPwBannerFr = ImageAsset(name: "img_pw_banner_fr")
    public static let imgPwBannerKo = ImageAsset(name: "img_pw_banner_ko")
    public static let imgPwBannerPt = ImageAsset(name: "img_pw_banner_pt")
    public static let imgPwBannerVi = ImageAsset(name: "img_pw_banner_vi")
    public static let imgSettingContainerBanner = ImageAsset(name: "img_setting_container_banner")
    public static let imgWalkthrough1 = ImageAsset(name: "img_walkthrough_1")
    public static let imgWalkthrough2 = ImageAsset(name: "img_walkthrough_2")
    public static let imgWalkthrough3 = ImageAsset(name: "img_walkthrough_3")
    public static let imgWalkthrough4 = ImageAsset(name: "img_walkthrough_4")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
