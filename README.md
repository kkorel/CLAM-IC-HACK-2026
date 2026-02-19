# clam: command line assistance module (FixErrorPls)

## The Story

Do you remember your first `git push --force`, `sudo rm -rf`, `chown -R root:root /`? It was a difficult time for everyone. Until our humble superhero, Clammy, opened ✨*the shell*✨ to everyone. 

## Clammy's Job

 Most tools try to be helpful all the time, but most users don't need the noice, setup and cognitive load. We asked Clammy to solve a simpler question. What is the smallest help that actually works?

We would like to introduce to you:

clam

A local command-line assistant, that only shows up when something breaks and disappears once it's fixed. If you don't need it, you forget it exists - and that's by design. 

## Demo

![CLAM Demo](https://github.com/yashpincha/ichack-26/blob/main/demo.gif)

## Quick Start

Installing our tool is incredibly simple:
```bash
git clone https://github.com/yashpincha/ichack-26.git
cd ichack-26
./install.sh
```

*Note*. Make sure that the directory `./.local/bin` exists on your device before you attempt an installation. You will also need to 
install the `jq` package.

Finally, you will need to select your LLM model (which can be local). For instance, you can set an OpenAI key as follows:
```bash
source clam config set openai_api_key "your-key"
```
By default, the model is local.

## Features

- **Context-Aware**: Considers terminal state, recent commands, and `--help` information
- **Flexible**: Supports various LLM models, from fast and cheap to powerful (and even local!)
- **Secure**: Enables local LLMs and sanitizes prompts for sensitive information
- **Efficient**: Caches recent queries for speed and convenience

## Supported Models

We support OpenAI, Groq, Anthropic, and Ollama models, and even local models. Configure your model with:

```bash
clam model
```

## How It Works

`clam.sh` provides faster, more accurate suggestions by considering:

- Your machine's environment
- Recently executed commands
- Current directory contents
- Command-specific help information

View the full prompt with:

```bash
clam command --dry-run "your command here"
```

## Tips and Tricks

### **Interactive Autocompletion**
Receive AI-assisted autocompletions, right in the terminal!

Use **Ctrl+Space** to enter an interactive session. Use `--explain` to receive short explanations for each autocompletion.
Navigate between suggestions using your keyboard.

```
$ ls # with file sizes in human-readable format

Generating suggestions...

╔════════════════════════════════════════════════════════════════════╗
║  Clam Suggestions                                                  ║
╠════════════════════════════════════════════════════════════════════╣
║  Use ↑/↓ to navigate, Enter to execute, Esc to cancel              ║
╚════════════════════════════════════════════════════════════════════╝

  ▶ ls -lh
    List files with sizes in human-readable format.

    ls -lhS
    List files by size, human-readable format.

    ls -lh --color=auto
    List files with color, human-readable sizes.

    ls -lh --group-directories-first
    List files with dirs first, human-readable sizes.

    ls -lh --time-style=long-iso
    List files with long ISO date, human-readable sizes.
```


### 🛡️ **Clammy Protects You**
Never accidentally run a dangerous command again.

- **Pattern Safeguards** (Fast, Local): Catches known dangerous patterns like `rm -rf /`
- **AI Harm Detection** (Intelligent): Analyzes commands for potential risks

```
$ rm temp
⚠ WARNING: Potentially harmful command detected!
▶ Command: rm important-file
▶ Reason: Deletes the 'important-file' file or directory, causing data loss.

Are you sure you want to continue? (y/N): 
```

### 🔧 **Fix Error Please (FEP)**
When a command fails, press `clam fep` to get an AI-suggested fix.

```
$ gitt push origin main
Command 'gitt' not found, did you mean:
  command 'gitu' from snap gitu (v0.39.0)
  command 'gitk' from deb gitk (1:2.43.0-1ubuntu7.3)
  command 'gitg' from deb gitg (44-1)
  command 'gita' from deb gita (0.16.6.1-2)
  command 'gist' from deb yorick (2.2.04+dfsg1-12)
  command 'gitit' from deb gitit (0.15.1.1+dfsg-1build2)
  command 'git' from deb git (1:2.43.0-1ubuntu7.3)
See 'snap info <snapname>' for additional versions.

$ clam fep
Analyzing error and generating fix...

━━━ Recommended Command ━━━
git push origin main

━━━ Explanation ━━━
The command failed because 'gitt' is not a recognized command. The correct command is 'git', which is the version control system used to push changes to a remote repository.

Run this command? [Y/n]
```

## Configuration

```bash
source clam config
```

Update settings with:

```bash
clam config set <key> <value>
```

Enable, disable, or check safeguarding status with:
```bash
clam safeguarding enable
clam safeguarding disable
clam safeguarding status
```

## Usage Tracking

```bash
clam usage
```

## Use Cases

- **Data Engineers**: Manipulate datasets efficiently
- **Backend Developers**: Deploy updates swiftly
- **Linux Users**: Navigate systems seamlessly
- **Terminal Novices**: Build command-line confidence
- **Efficiency Seekers**: Streamline repetitive tasks
- **Documentation Seekers**: Quickly understand commands

## Development

### Testing

To test the tool, just execute `./run_tests.sh`. It will automatically install `bats` if you do not already have it.

Alternatively, you may choose to use Docker to directly pull and run an existing image of the tool:
```
docker pull treefwog/autocomplete-sh:latest
docker run -it treefwog/autocomplete-sh:latest
```

## Developers

Developers:
- Arya Golkari
- Andras Bard
- James Yang
- Kuzey Korel
- Syed Sameer Faisal
- Yash Pincha

This project was influenced by [autocomplete-sh](https://github.com/closedloop-technologies/autocomplete-sh) and developed at ICHack '26.

## License

See the [MIT-LICENSE](./LICENSE) file for details.

