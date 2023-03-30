# CommitlogGPT
CommitlogGPT is a command-line tool built with Swift that generates commit messages using OpenAI's ChatGPT. It is inspired by [RomanHotsiy/commitgpt](https://github.com/RomanHotsiy/commitgpt) and aims to provide a simple way to create meaningful commit messages for your Git repositories.

# Prerequisites
Swift 5.5 or later
OpenAI API Key

#Installation
Clone this repository to your local machine:

```
git clone https://github.com/huiping192/commitlogGPT.git
cd commitlogGPT
swift build -c release
cp .build/release/clg /usr/local/bin/clg
```


# Usage

build and run the project:

```

clg
```

The tool will analyze your staged changes in your Git repository and generate commit messages using ChatGPT. You can select one of the suggested commit messages, or ask for more options.

# example

![example gif](https://github.com/huiping192/commitlogGPT/blob/main/example.gif)


# Contributing
Contributions are welcome! Feel free to submit a pull request or create an issue for any suggestions or improvements.

# License
This project is licensed under the MIT License. See the LICENSE file for details.