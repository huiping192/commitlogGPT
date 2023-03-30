//
//  File.swift
//  
//
//  Created by 郭 輝平 on 2023/03/30.
//

import Foundation

class KeyManager {
  private func tokenFileURL() -> URL {
    let home = FileManager.default.homeDirectoryForCurrentUser
    return home.appendingPathComponent(".commitlogGPT.openai_token")
  }
  
  func saveToken(_ token: String) {
    do {
      try token.write(to: tokenFileURL(), atomically: true, encoding: .utf8)
    } catch {
      print("Error saving token: \(error)")
    }
  }
  
  func receiveCachedToken() -> String? {
    do {
      if FileManager.default.fileExists(atPath: tokenFileURL().path) {
        let token = try String(contentsOf: tokenFileURL(), encoding: .utf8)
        return token.trimmingCharacters(in: .whitespacesAndNewlines)
      }
    } catch {
      print("Error reading token: \(error)")
      return nil
    }
    
    return nil
  }
  
  func removeToken() {
    let fileURL = tokenFileURL()
    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: fileURL.path) {
        try? fileManager.removeItem(at: fileURL)
        print("Token file removed.")
    } else {
        print("Token file not found.")
    }
  }
}
