// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
public enum L10n {
  public enum Alert {
    /// Cancel
    public static var cancel: String { L10n.tr("Alert", "cancel") }
    /// Clear
    public static var clear: String { L10n.tr("Alert", "clear") }
    /// File downloaded 🚀
    public static var downloaded: String { L10n.tr("Alert", "downloaded") }
    /// Your purchase was restored.
    public static var restore: String { L10n.tr("Alert", "restore") }
    /// Settings
    public static var settings: String { L10n.tr("Alert", "settings") }
    /// Sure!
    public static var sure: String { L10n.tr("Alert", "sure") }

    public enum Rating {

      public enum General {
        /// If you appreciate what you’ve experienced so far, please take a moment to rate us 🙏
        public static var desc: String { L10n.tr("Alert", "Rating.General.desc") }
        /// I did not like it
        public static var negative: String { L10n.tr("Alert", "Rating.General.negative") }
        /// I like it 💖
        public static var positive: String { L10n.tr("Alert", "Rating.General.positive") }
        /// Did you like our app?
        public static var title: String { L10n.tr("Alert", "Rating.General.title") }
      }

      public enum Welcome {
        /// Help us out! We value your feedback. Do you have a moment to rate our app?
        public static var desc: String { L10n.tr("Alert", "Rating.Welcome.desc") }
        /// No, thanks
        public static var negative: String { L10n.tr("Alert", "Rating.Welcome.negative") }
        /// Rate the app 🎉
        public static var positive: String { L10n.tr("Alert", "Rating.Welcome.positive") }
        /// Welcome!
        public static var title: String { L10n.tr("Alert", "Rating.Welcome.title") }
      }
    }

    public enum Batch {
      /// All files downloaded 🚀
      public static var downloaded: String { L10n.tr("Alert", "batch.downloaded") }
    }

    public enum Clear {
      /// Are you sure you want to clear cache and history?
      public static var desc: String { L10n.tr("Alert", "clear.desc") }
      /// Cache and history cleared.
      public static var success: String { L10n.tr("Alert", "clear.success") }
      /// Clear cache and history
      public static var title: String { L10n.tr("Alert", "clear.title") }
    }

    public enum Gallery {
      /// This app needs access to your photos to work properly.
      public static var desc: String { L10n.tr("Alert", "gallery.desc") }
      /// Access Required
      public static var title: String { L10n.tr("Alert", "gallery.title") }
    }
  }
  public enum Componenets {

    public enum Premium {
      /// Features
      public static var features: String { L10n.tr("Componenets", "Premium.features") }

      public enum Container {
        /// Upgrade 🚀
        public static var action: String { L10n.tr("Componenets", "Premium.Container.action") }
        /// Convert any type of audios to 20+ formats
        public static var desc: String { L10n.tr("Componenets", "Premium.Container.desc") }
        /// Unlock
        public static var unlock: String { L10n.tr("Componenets", "Premium.Container.unlock") }
      }
    }
  }
  public enum Error {

    public enum Convert {

      public enum Sound {
        /// No audio channel found in the video.
        public static var channel: String { L10n.tr("Error", "convert.sound.channel") }
      }
    }
  }
  public enum General {
    /// and
    public static var and: String { L10n.tr("General", "and") }
    /// Collapse
    public static var collapse: String { L10n.tr("General", "collapse") }
    /// Continue
    public static var `continue`: String { L10n.tr("General", "continue") }
    /// Default
    public static var `default`: String { L10n.tr("General", "default") }
    /// Expand
    public static var expand: String { L10n.tr("General", "expand") }
    /// See less
    public static var less: String { L10n.tr("General", "less") }
    /// See more
    public static var more: String { L10n.tr("General", "more") }
    /// Premium
    public static var premium: String { L10n.tr("General", "premium") }
  }
  public enum Modules {

    public enum Batch {
      /// Download All
      public static var download: String { L10n.tr("Modules", "Batch.download") }
      /// Share All
      public static var share: String { L10n.tr("Modules", "Batch.share") }
      /// You can share or download each file seperatly in the history section.
      public static var tip: String { L10n.tr("Modules", "Batch.tip") }
      /// Batch
      public static var title: String { L10n.tr("Modules", "Batch.title") }
    }

    public enum Edit {
      /// Advance
      public static var advance: String { L10n.tr("Modules", "Edit.advance") }
      /// Bit Rate
      public static var bit: String { L10n.tr("Modules", "Edit.bit") }
      /// Channels
      public static var channels: String { L10n.tr("Modules", "Edit.channels") }
      /// Edit
      public static var edit: String { L10n.tr("Modules", "Edit.edit") }
      /// Export
      public static var export: String { L10n.tr("Modules", "Edit.export") }
      /// File Name
      public static var filename: String { L10n.tr("Modules", "Edit.filename") }
      /// Format
      public static var format: String { L10n.tr("Modules", "Edit.format") }
      /// Files Listed
      public static var listed: String { L10n.tr("Modules", "Edit.listed") }
      /// Range
      public static var range: String { L10n.tr("Modules", "Edit.range") }
      /// Sample Rate
      public static var sample: String { L10n.tr("Modules", "Edit.sample") }
      /// Speed
      public static var speed: String { L10n.tr("Modules", "Edit.speed") }
      /// Volume
      public static var volume: String { L10n.tr("Modules", "Edit.volume") }

      public enum Channels {
        /// Double
        public static var double: String { L10n.tr("Modules", "Edit.channels.double") }
        /// Single
        public static var single: String { L10n.tr("Modules", "Edit.channels.single") }
      }
    }

    public enum Export {
      /// Download
      public static var download: String { L10n.tr("Modules", "Export.download") }
      /// Share
      public static var share: String { L10n.tr("Modules", "Export.share") }
      /// Export
      public static var title: String { L10n.tr("Modules", "Export.title") }
    }

    public enum History {
      /// Date
      public static var date: String { L10n.tr("Modules", "History.date") }
      /// There's nothing yet.
      public static var empty: String { L10n.tr("Modules", "History.empty") }
      /// Convert History
      public static var title: String { L10n.tr("Modules", "History.title") }
    }

    public enum Home {
      /// Files
      public static var files: String { L10n.tr("Modules", "Home.files") }
      /// From
      public static var from: String { L10n.tr("Modules", "Home.from") }
      /// Gallery
      public static var gallery: String { L10n.tr("Modules", "Home.gallery") }
      /// Go
      public static var go: String { L10n.tr("Modules", "Home.go") }
      /// Import
      public static var `import`: String { L10n.tr("Modules", "Home.import") }
      /// Audio Converter
      public static var title: String { L10n.tr("Modules", "Home.title") }
    }

    public enum Language {
      /// Language
      public static var title: String { L10n.tr("Modules", "Language.title") }
    }

    public enum Onboard {
      /// Get Started
      public static var start: String { L10n.tr("Modules", "Onboard.start") }

      public enum Scene {

        public enum _1 {
          /// Convert your videos to any audio format in seconds! .MP3, .AVI, .WAW and more!
          public static var desc: String { L10n.tr("Modules", "Onboard.Scene.1.desc") }
          /// MP4 & MP3 Converter
          public static var title: String { L10n.tr("Modules", "Onboard.Scene.1.title") }
        }

        public enum _2 {
          /// Convert video to audio with best sound quality. No internet required. 
          public static var desc: String { L10n.tr("Modules", "Onboard.Scene.2.desc") }
          /// “Ultimate tool to\nconvert your video”
          public static var title: String { L10n.tr("Modules", "Onboard.Scene.2.title") }

          public enum Advantages {
            /// Adjust Audio Settings
            public static var _1: String { L10n.tr("Modules", "Onboard.Scene.2.advantages.1") }
            /// High Quality Output
            public static var _2: String { L10n.tr("Modules", "Onboard.Scene.2.advantages.2") }
            /// See Convert History
            public static var _3: String { L10n.tr("Modules", "Onboard.Scene.2.advantages.3") }
          }
        }
      }
    }

    public enum Paywall {
      /// Purchase
      public static var purchase: String { L10n.tr("Modules", "Paywall.purchase") }
      /// Try 3 Days Free
      public static var `try`: String { L10n.tr("Modules", "Paywall.try") }
      /// Week
      public static var week: String { L10n.tr("Modules", "Paywall.week") }
      /// Weekly
      public static var weekly: String { L10n.tr("Modules", "Paywall.weekly") }
      /// Year
      public static var year: String { L10n.tr("Modules", "Paywall.year") }
      /// Yearly
      public static var yearly: String { L10n.tr("Modules", "Paywall.yearly") }

      public enum Advantages {

        public enum _1 {
          /// Convert unlimited videos to any format. No limits.
          public static var desc: String { L10n.tr("Modules", "Paywall.advantages.1.desc") }
          /// Unlimited Conversions 🚀
          public static var title: String { L10n.tr("Modules", "Paywall.advantages.1.title") }
        }

        public enum _2 {
          /// Convert your videos and audios without internet. Works perfectly.
          public static var desc: String { L10n.tr("Modules", "Paywall.advantages.2.desc") }
          /// Works Offline ✈️
          public static var title: String { L10n.tr("Modules", "Paywall.advantages.2.title") }
        }

        public enum _3 {
          /// Save your time with 10x faster premium conversions!
          public static var desc: String { L10n.tr("Modules", "Paywall.advantages.3.desc") }
          /// 10x Faster ⚡
          public static var title: String { L10n.tr("Modules", "Paywall.advantages.3.title") }
        }
      }
    }

    public enum Settings {
      /// Settings
      public static var title: String { L10n.tr("Modules", "Settings.title") }

      public enum Section {

        public enum General {
          /// Clear History
          public static var clear: String { L10n.tr("Modules", "Settings.Section.general.clear") }
          /// Rate Us
          public static var rate: String { L10n.tr("Modules", "Settings.Section.general.rate") }
          /// Restore Purchases
          public static var restore: String { L10n.tr("Modules", "Settings.Section.general.restore") }
          /// General
          public static var title: String { L10n.tr("Modules", "Settings.Section.general.title") }
        }

        public enum Help {
          /// Contact Us
          public static var contact: String { L10n.tr("Modules", "Settings.Section.help.contact") }
          /// Help & Support
          public static var title: String { L10n.tr("Modules", "Settings.Section.help.title") }
        }

        public enum Other {
          /// Privacy Policy
          public static var privacy: String { L10n.tr("Modules", "Settings.Section.other.privacy") }
          /// Terms of Use
          public static var terms: String { L10n.tr("Modules", "Settings.Section.other.terms") }
          /// Other
          public static var title: String { L10n.tr("Modules", "Settings.Section.other.title") }
        }

        public enum Settings {
          /// Language
          public static var language: String { L10n.tr("Modules", "Settings.Section.settings.language") }
          /// Color Theme
          public static var theme: String { L10n.tr("Modules", "Settings.Section.settings.theme") }
          /// Settings
          public static var title: String { L10n.tr("Modules", "Settings.Section.settings.title") }
        }
      }
    }
  }
  public enum Placeholder {
    /// E-mail Adresi
    public static var email: String { L10n.tr("Placeholder", "email") }
    /// Şifre
    public static var password: String { L10n.tr("Placeholder", "password") }
    /// Kullanıcı Adı
    public static var username: String { L10n.tr("Placeholder", "username") }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    guard let bundle = LocalizableManager.bundle else {
        fatalError("Cannot find bundle!")
    }
    let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
    let locale = Locale(identifier: LocalizableManager.lang)
    return String(format: format, locale: locale, arguments: args)
  }
}

private final class BundleToken {}
