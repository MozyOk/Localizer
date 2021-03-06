//
//  Localizer+SwitchLanguage.swift
//  Localizer
//
//  Created by Nicolas Degen on 28.08.18.
//  Copyright © 2018 Nicolas Degen. All rights reserved.
//

import Foundation

extension Localizer {
  public class func setLanguage(languageId: String) {
    // TODO : Check if languageId available!
    UserDefaults.standard.set(languageId, forKey: currentLanguageUserDefaultsKey)
    
    // Call all registered callbacks
    for callback in Localizer.onLanguageDidChangeCallbackList {
      callback()
    }
    Localizer.overrideDeviceLanguage = true
    NotificationCenter.default.post(name: Notification.Name(rawValue: didSwitchLanguageNotificationKey), object: nil)
  }
  
  open class func availableLanguages(_ excludeBase: Bool = false, forBundle bundle: Bundle = mainBundle) -> Set<String> {
    
    var availableLanguages = Set<String>()
    for (bundle, _) in bundleTableHierarchy {
      bundle.localizations.forEach { localization in
        availableLanguages.insert(localization)
      }
    }
    // If excludeBase = true, don't include "Base" in available languages
    if let indexOfBase = availableLanguages.index(of: "Base") , excludeBase == true {
      availableLanguages.remove(at: indexOfBase)
    }
    return availableLanguages
  }
  
  open class func displayNameForLanguage(_ languageId: String) -> String {
    let locale = NSLocale(localeIdentifier: currentLanguage)
    if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: languageId) {
      return displayName
    }
    return String()
  }
}
