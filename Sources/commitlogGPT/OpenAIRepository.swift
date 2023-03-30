//
//  File.swift
//  
//
//  Created by 郭 輝平 on 2023/03/30.
//

import Foundation
import OpenAISwift

class OpenAIRepository {
  
  init() {}
  
  private var token: String = ""
  
  func configureToken(token: String) {
    openAI = OpenAISwift(authToken: token)
  }
  
  var openAI: OpenAISwift!
  
  func receiveCommitlogs(by diff: String) async throws -> [String] {
    let text =
    """
    Suggest me a few good commit messages for my commit ${CONVENTIONAL_REQUEST}.\n
    ```
    \n
    \(diff)
    \n
    ```\n\n
    Output results as a list, spilt by \n, not more than 6 items.
    """
    
    let response = try await openAI.sendCompletion(with: text)
    return adjustResponse(text: response.choices.first?.text)
  }
  
  func receiveMoreCommitlogs(by diff: String) async throws -> [String] {
    let text =
    """
    Suggest a few more commit messages for my changes (without explanations)
    """
    
    let response = try await openAI.sendCompletion(with: text)
    return adjustResponse(text: response.choices.first?.text)
  }
  
  private func adjustResponse(text: String?) -> [String] {
    guard let text else { return [] }
    let lines = text.components(separatedBy: .newlines)
    let trimmedLines = lines.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    let filteredLines = trimmedLines.filter { !$0.isEmpty }
    let result = filteredLines.map { $0.components(separatedBy: ". ").last }.compactMap { $0 }
    return result
  }
  
}
