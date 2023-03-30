//
//  File.swift
//  
//
//  Created by 郭 輝平 on 2023/03/30.
//

import Foundation

let openAIRepository = OpenAIRepository()
let keyManager = KeyManager()


let cachedToken = keyManager.receiveCachedToken()
var openAIToken: String = ""
if let cachedToken {
  openAIToken = cachedToken
} else {
  print("Please enter your OpenAI token:")
  guard let token = readLine() else {
    print("Failed to read OpenAI token.")
    abort()
  }

  // Store the OpenAI token for later use
  print("Your OpenAI API key is: \(token)")
  keyManager.saveToken(token)
  openAIToken = token
}

openAIRepository.configureToken(token: openAIToken)

let diff = runShellCommand("/usr/bin/git", arguments: ["diff", "--cached"])

if diff.isEmpty {
  print("No changes to commit.")
  exit(0)
}

do {
  print("Requesting commit logs...")
  let commitlogs = try await openAIRepository.receiveCommitlogs(by: diff)
  confirmCommitLog(suggestCommitLogs: commitlogs)
} catch {
  print("Failed to get result from openapi. error: \(error.localizedDescription)")
}
  


@Sendable func runShellCommand(_ command: String, arguments: [String]) -> String {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: command)
  process.arguments = arguments
  
  let outputPipe = Pipe()
  process.standardOutput = outputPipe
  
  do {
    try process.run()
  } catch {
    print("Failed to run \(command) \(arguments.joined(separator: " "))")
    exit(1)
  }
  
  let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
  return String(data: outputData, encoding: .utf8) ?? ""
}


func escapeCommitMessage(_ message: String) -> String {
  return message.replacingOccurrences(of: "'", with: "\\'")
}

func promptUser(choices: [String]) -> String? {
  print("[debug] \(choices)")
  
  for (index, choice) in choices.enumerated() {
    print("\(index + 1). \(choice)")
  }
  print("Enter your choice number:")
  if let input = readLine(), let choice = Int(input), 1...choices.count ~= choice {
    return choices[choice - 1]
  }
  return nil
}

let CUSTOM_MESSAGE_OPTION = "Custom Message"
let MORE_OPTION = "More Options"


func confirmCommitLog(suggestCommitLogs: [String]) {
  let choices = suggestCommitLogs + [
    CUSTOM_MESSAGE_OPTION,
    MORE_OPTION
  ]
  
  var firstRequestSent = false
  
  while true {
    do {
      guard let answer = promptUser(choices: choices) else {
        print("Invalid choice. Please try again.")
        continue
      }
      
      firstRequestSent = true
      
      if answer == CUSTOM_MESSAGE_OPTION {
        let _ = runShellCommand("/usr/bin/git", arguments: ["commit"])
        return
      } else if answer == MORE_OPTION {
        continue
      } else {
        let escapedMessage = escapeCommitMessage(answer)
        let _ = runShellCommand("/usr/bin/git", arguments: ["commit", "-m", escapedMessage])
        return
      }
    } catch {
      print("Aborted.")
      print(error.localizedDescription)
      exit(1)
    }
  }
}
