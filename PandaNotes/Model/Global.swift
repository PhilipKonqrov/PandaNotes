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
        guard let notesArr = try? Global.coreDataContext.fetch(fetchRequest) else { return [] }
        return notesArr
    }
    static var coreDataContext : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
