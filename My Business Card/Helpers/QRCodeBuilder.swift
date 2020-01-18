//
//  QRCodeBuilder.swift
//  QRDS
//
//  Created by Irving Martinez on 1/1/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import Contacts
import UIKit

class QRCodeBuilder {
    
    // Build contact using "" as default values
    func createContact(card: Card) -> CNMutableContact {
        let contact = CNMutableContact()
        // Set contact first and last name
        contact.givenName = card.firstName ?? ""
        contact.familyName = card.lastName ?? ""
        contact.jobTitle = card.jobTitle ?? ""
        contact.organizationName = card.company ?? ""
        
        // Set contact email
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: card.email as NSString? ?? "")]
        
        // Set social
        contact.socialProfiles = [CNLabeledValue<CNSocialProfile>]()
        if card.twitter != nil && card.twitter != "" {
            let twitterProfile = CNLabeledValue(label: "Twitter", value: CNSocialProfile(urlString: nil, username: card.twitter, userIdentifier: nil, service: CNSocialProfileServiceTwitter))
            contact.socialProfiles.append(twitterProfile)
        }
        if card.linkedin != nil && card.linkedin != "" {
            let linkedinProfile = CNLabeledValue(label: "LinkedIn", value: CNSocialProfile(urlString: nil, username: card.linkedin, userIdentifier: nil, service: CNSocialProfileServiceLinkedIn))
            contact.socialProfiles.append(linkedinProfile)
        }
        
        // Set contact phone number with phone format
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue: card.phoneNumber ?? ""))]
        return contact
    }
    
    // MARK: - Create a QR Code image
    func createQr(contact: CNMutableContact) -> UIImage? {
        
        // Convert contact into data
        let contactData = try? CNContactVCardSerialization.data(with: [contact])
        guard contactData != nil else {
            return nil
        }
        // Convert contact data into a string
        let dataString = String(data: contactData!, encoding: String.Encoding.ascii)
        let data = dataString?.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        return processedImage
    }
}
