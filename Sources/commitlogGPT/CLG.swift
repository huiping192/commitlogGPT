import Foundation
import ArgumentParser

@main
struct CLG: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "clg",
    abstract: "Generates commit messages",
    discussion: """
          Generates commit messages using OpenAI's ChatGPT.
          """,
    version: "0.0.1",
    shouldDisplay: true,
    helpNames: [.long, .short]
  )
//  @Flag(name: .shortAndLong, help: "Enable debug mode.")
//  var debug: Bool = false
//
//  @Flag(name: .long, help: "Clear settings.")
//  var clearSettings: Bool = false
  
  mutating func run() async throws {
    let client = Client()

//    if clearSettings {
//      client.clearSettings()
//      print("Settings cleared.")
//      return
//    }
    await client.run()
  }
}
