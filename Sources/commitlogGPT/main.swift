//
//  File.swift
//  
//
//  Created by 郭 輝平 on 2023/03/30.
//

import Foundation

let openAIRepository = OpenAIRepository()
let keyManager = KeyManager()
let test = Test()

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

let diff = test.runShellCommand("/usr/bin/git", arguments: ["diff", "--cached"])

if diff.isEmpty {
  print("No changes to commit.")
  exit(0)
}

do {
  print("Requesting commit logs...")
  let commitlogs = try await openAIRepository.receiveCommitlogs(by: diff)
  await test.confirmCommitLog(suggestCommitLogs: commitlogs)
} catch {
  print("Failed to get result from openapi. error: \(error.localizedDescription)")
}
  



class Test {
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
    for (index, choice) in choices.enumerated() {
      print("\(index + 1). \(choice)")
    }
    print("Enter your choice number:")
    if let input = readLine(), let choice = Int(input), 1...choices.count ~= choice {
      return choices[choice - 1]
    }
    return nil
  }


  func confirmCommitLog(suggestCommitLogs: [String]) async {
    let more = "More Options"
    let quit = "Quit"
    
    var choices: [String] = suggestCommitLogs
    choices.append(more)
    choices.append(quit)

    while true {
      guard let answer = promptUser(choices: choices) else {
        print("Invalid choice. Please try again.")
        continue
      }
          
      if answer == more {
        await getMore()
        return
      } else if answer == quit {
        exit(0)
      } else {
        let escapedMessage = escapeCommitMessage(answer)
        let _ = runShellCommand("/usr/bin/git", arguments: ["commit", "-m", escapedMessage])
        return
      }
    }
  }


  func getMore() async {
    do {
      print("Requesting more commit logs...")
      let commitlogs = try await openAIRepository.receiveCommitlogs(by: diff)
      await confirmCommitLog(suggestCommitLogs: commitlogs)
    } catch {
      print("Failed to get result from openapi. error: \(error.localizedDescription)")
    }
  }
}
