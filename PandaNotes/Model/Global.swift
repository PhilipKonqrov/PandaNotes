//
//  Global.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 9.08.21.
//

import Foundation
import CoreData
import UIKit
struct Global {
    static var notes: [NoteEntity] {
        let fetchRequest:NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let defaults = UserDefaults.standard
        let hide = defaults.bool(forKey: "hideEncryptedItems")
        if hide {
            fetchRequest.predicate = NSPredicate(format: "encrypted == %@", NSNumber(value: false))
        }
        guard let notesArr = try? Global.coreDataContext.fetch(fetchRequest) else { return [] }
        return notesArr
    }
    static var coreDataContext : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    static let menuItems: [MenuItem] = [
        MenuItem(titleText: "Hide encrypted notes", descriptionText: "Use this to hide all encrypted notes"),
        MenuItem(titleText: "Show encrypted notes", descriptionText: "Use this to show all encrypted notes")
    ]
}
