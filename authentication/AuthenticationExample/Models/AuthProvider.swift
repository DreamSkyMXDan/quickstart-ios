// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

/// Firebase Auth supported identity providers and other methods of authentication
enum AuthProvider: String {
  case google = "Google"
  case apple = "Apple"
  case twitter = "Twitter"
  case microsoft = "Microsoft"
  case gitHub = "GitHub"
  case yahoo = "Yahoo"
  case facebook = "Facebook"
  case emailPassword = "Email & Password Login"
  case passwordless = "Email Link/Passwordless"
  case phoneNumber = "Phone Number"
  case anonymous = "Anonymous Authentication"
  case custom = "Custom Auth System"

  var id: String {
    switch self {
    case .emailPassword:
      return "password"
    case .phoneNumber:
      return "phone"
    case .passwordless:
      return "emailLink"
    case .anonymous:
      return "anonymous"
    case .custom:
      return "custom"
    default:
      return rawValue.lowercased().appending(".com")
    }
  }
}

// MARK: DataSourceProvidable

extension AuthProvider: DataSourceProvidable {
  private static var providers: [AuthProvider] {
    [.google, .apple, .twitter, .microsoft, .gitHub, .yahoo, .facebook]
  }

  static var providerSection: Section {
    let providers = self.providers.map { Item(title: $0.rawValue) }
    let header = "Identity Providers"
    let footer = "Choose a login flow from one of the identity providers above."
    return Section(headerDescription: header, footerDescription: footer, items: providers)
  }

  static var emailPasswordSection: Section {
    let image = UIImage(named: "firebaseIcon")
    let item = Item(title: emailPassword.rawValue, hasNestedContent: true, image: image)
    let footer = "A example login flow with password authentication."
    return Section(footerDescription: footer, items: [item])
  }

  static var otherSection: Section {
    let lockSymbol = UIImage.systemImage("lock.slash.fill", tintColor: .systemOrange)
    let phoneSymbol = UIImage.systemImage("phone.fill", tintColor: .systemOrange)
    let anonSymbol = UIImage.systemImage("questionmark.circle.fill", tintColor: .systemOrange)
    let shieldSymbol = UIImage.systemImage("lock.shield.fill", tintColor: .systemOrange)

    let otherOptions = [
      Item(title: passwordless.rawValue, image: lockSymbol),
      Item(title: phoneNumber.rawValue, image: phoneSymbol),
      Item(title: anonymous.rawValue, image: anonSymbol),
      Item(title: custom.rawValue, image: shieldSymbol),
    ]
    return Section(footerDescription: "Other authentication methods.", items: otherOptions)
  }

  static var sections: [Section] {
    [providerSection, emailPasswordSection, otherSection]
  }

  static var authLinkSections: [Section] {
    let allItems = AuthProvider.sections.flatMap { $0.items }
    let header = "Manage linking between providers"
    let footer =
      "Select an unchecked row to link the currently signed in user to that auth provider. To unlink the user from a linked provider, select its corresponding row marked with a checkmark."
    return [Section(headerDescription: header, footerDescription: footer, items: allItems)]
  }

  var sections: [Section] { AuthProvider.sections }
}
