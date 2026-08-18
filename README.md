# CLAM

CLAM (Command Line Assistance Module) is a bash tool that adds LLM-powered
completion, error recovery, and command safety checks on top of a normal
shell session. We built it as a team of six at IC Hack 2026, Imperial
College London's student hackathon, where it placed second. It was
influenced by [autocomplete-sh](https://github.com/closedloop-technologies/autocomplete-sh).

The idea behind it was to keep the assistant out of the way most of the
time. It only does anything when you ask for suggestions, when a command
fails, or when you are about to run something that looks dangerous.

## Features

### Interactive autocompletion

Once enabled, pressing Ctrl+Space sends the current command line, along
with terminal context (recent history, current directory, the target
command's `--help` output), to an LLM and returns two to five suggested
completions with short explanations. Add `--explain` before pressing
Ctrl+Space to always show the explanations inline. Suggestions are cached
locally by a hash of the input so repeated queries do not re-hit the API.

```
$ ls # with file sizes in human-readable format
```

You can inspect the exact prompt that would be sent, without calling the
API, with:

```bash
clam command --dry-run "your command here"
```

### Fix Error Please (`fep`)

CLAM hooks into `PROMPT_COMMAND` to remember the last command you ran and
its exit code. When something fails, running `clam fep` (or just `fep`
once CLAM is enabled) sends that failed command, its exit code, and
recent terminal context to the LLM, which proposes a corrected command and
a short explanation. You are asked to confirm before it runs.

### Safeguards

When enabled, CLAM wraps a set of higher-risk commands (`rm`, `dd`,
`mkfs`, `shutdown`, `reboot`, `chmod`, `chown`, `curl`, `wget`). Before one
of these actually runs, the full command is sent to the LLM for a harm
assessment; if it comes back flagged, you get a warning with the reason
and have to confirm before it proceeds. Assessments are cached locally by
command hash so repeated commands do not re-trigger an API call.
Safeguards can be toggled with:

```bash
clam safeguard enable
clam safeguard disable
clam safeguard status
```

### Model selection

CLAM can talk to OpenAI, Anthropic, Groq, or a local Ollama instance. Run
`clam model` for an interactive picker, or set values directly with
`clam config set <key> <value>` (model, provider, endpoint, temperature,
and so on).

### Other commands

- `clam usage` — shows request count, cache size, and estimated API cost
- `clam system` — shows the system and terminal information CLAM includes as context
- `clam config` — shows current configuration; `clam config reset` restores defaults
- `clam clear` — clears the completion cache, harm-detection cache, and log file
- `clam demo` — a quick walkthrough of the features above
- `clam enable` / `clam disable` — turn CLAM's completion, safeguards, and prompt hook on or off for the current shell
- `clam install` / `clam remove` — add or remove the `.bashrc` hook
- `clam --help` — full command list

Commands that change the current shell's state (`enable`, `disable`,
`config`) need to be run with `source clam ...` rather than `clam ...`,
since CLAM otherwise runs as a subprocess and cannot modify your
interactive shell.

## Installation

CLAM currently only supports bash.

```bash
git clone https://github.com/kkorel/CLAM-IC-HACK-2026.git
cd CLAM-IC-HACK-2026
./install.sh
```

`install.sh` copies `clam.sh` to `~/.local/bin` (falling back to
`/usr/local/bin`), symlinks it as `clam`, checks that `jq` is installed,
makes sure `bash-completion` is sourced, and runs `clam install`, which
adds the necessary lines to `~/.bashrc`. After that, reload your shell
with `source ~/.bashrc` and run `clam model` to pick a provider and set an
API key.

## Repository layout

- `clam.sh` — the tool itself; every command is implemented here
- `install.sh` — installs `clam.sh` and wires it into `.bashrc`
- `run_tests.sh` — installs `bats` if missing, then runs the test suite
- `tests/` — bats and shell tests covering the core commands, harm
  detection, and the `rm` safeguard
- `USAGE.md` — a manual walkthrough of the commands, used for testing by hand

## Testing

```bash
./run_tests.sh
```

This runs `tests/test_clam.bats`, which requires a real
`CLAM_OPENAI_API_KEY` since it calls the live OpenAI API, along with the
plain shell tests `test_harm_basic.sh`, `test_harm_detection.sh`,
`test_rm.sh`, and `test_final_verification.sh`.

## License

MIT. See [LICENSE](./LICENSE) for details.
