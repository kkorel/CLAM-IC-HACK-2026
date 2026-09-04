# CLAM

CLAM (Command Line Assistance Module) is a bash script that adds LLM-generated command suggestions, a fix-my-last-command helper, and a harm check on risky commands to an interactive shell.

It only acts when you ask. A key binding turns the command you are typing, or a `# comment` describing what you want, into a menu of runnable suggestions; `fep` proposes a fix for the command that just failed; and wrappers around `rm`, `dd`, and seven other commands ask a model whether the exact command looks destructive before it runs. It is for bash users who want that help from OpenAI, Anthropic, Groq, or a local Ollama model without leaving the shell they already use. It was built at IC Hack 2026, the student-run hackathon at Imperial College London, on top of ClosedLoop Technologies' [autocomplete.sh](https://github.com/closedloop-technologies/autocomplete-sh).

## Quickstart

You need bash 4 or newer (the script uses associative arrays) with bash-completion, plus `jq`, `curl`, `bc`, `md5sum`, GNU `sed`, and GNU `find`. The installer only runs under bash and stops if `jq` or bash-completion is missing. On macOS the script's `#!/bin/bash` line selects the stock bash 3.2, which rejects the associative arrays at startup, and BSD `sed` rejects the `sed -i` calls that edit the config file.

Clone the repo, run the installer, and reload your shell:

```bash
git clone https://github.com/kkorel/CLAM-IC-HACK-2026.git
cd CLAM-IC-HACK-2026
bash install.sh
source ~/.bashrc
```

`install.sh` copies `clam.sh` to `~/.local/bin` if that directory exists and to `/usr/local/bin` otherwise, symlinks it there as `clam`, and finishes by running `clam install`. That step needs the chosen directory on your `PATH`. It creates `~/.clam/`, writes a default `~/.clam/config`, and appends `source clam enable` plus a completion line for the `clam` command to `~/.bashrc`, so every new interactive shell prints a banner and switches CLAM on.

Choose a provider and model. The menu takes the arrow keys, Enter to select, and `q` to quit, and asks for an API key if the chosen provider has none stored:

```bash
clam model
```

## Usage

`enable`, `disable`, and the plain `config` view act on the current shell, so run them as `source clam enable`, `source clam disable`, and `source clam config`. Every other command runs as a normal subprocess. Tab completion stays standard bash completion; only Ctrl+Space calls the model.

### Get suggestions for the line you are typing

Type a command, or a command followed by a `# comment` saying what you want, and press Ctrl+Space:

```bash
ls # show hidden files sorted by size
```

A menu of suggestions appears. Move with the arrow keys, press Enter to run the highlighted command, or `q` to cancel. End the line with `--explain` to show a one-line explanation under each suggestion. Results are cached by a hash of the line, so repeating it does not call the API.

The prompt contains the line, the names (not the values) of your environment variables, your last 20 history entries with hex strings, UUIDs, and 16-to-40-character tokens redacted, `ls -ld` output for up to 20 files in the current directory, the `--help` output of the first word, and your username, hostname, current, previous, and home directories, OS type, shell path, and terminal type. To print it without calling the API, or to get the raw suggestions outside the menu:

```bash
clam command --dry-run "ls # show largest files"
clam command "ls # show largest files"
```

### Fix the last failed command

CLAM records each command and its exit code from `PROMPT_COMMAND`. After a failure, run `fep` (Fix Error Please), optionally with a note about what you meant. It sends the failed command, its exit code, an `ls -la` of the current directory, and the same machine details as the suggestion prompt, then shows the model's recommended command and explanation and asks whether to run it. Enter or `y` runs it.

```bash
git stauts
fep
fep "I wanted the status of the branch, not the file"
```

### Check a risky command before it runs

With safeguards on, which is the default, `rm`, `dd`, `mkfs`, `shutdown`, `reboot`, `chmod`, `chown`, `curl`, and `wget` (those present on your `PATH`) are wrapped by shell functions, which are exported to bash scripts you start from that shell. Before the real command runs, the whole command line goes to the model for a harmful-or-not verdict. A flagged command prints the model's reason and needs `y` to continue; any other key cancels it. Verdicts are cached by command hash in `~/.clam/harm_cache`, and when the request fails or exceeds `harm_timeout` the command is allowed through. Suggestions chosen from the Ctrl+Space menu go through the same check.

```bash
clam safeguard status
clam safeguard disable
clam safeguard enable
```

`clam --help` lists the rest: `usage` prints the request count and estimated cost from the log, `clear` empties both caches and the log after you confirm, `system` prints the machine details included in prompts, `demo` prints a feature tour, and `remove` deletes `~/.clam/config`, the suggestion cache, the log, and every line of `~/.bashrc` containing `clam`, then offers to delete the script itself.

## Configuration

Settings live in `~/.clam/config`, one `key: value` per line, written by `clam install`. Change a value with `clam config set <key> <value>`, which only replaces keys already in the file; view them with `source clam config`; restore the defaults, discarding stored API keys, with `clam config reset`. `clam model` writes `provider`, `model`, `endpoint`, and the two cost keys for the chosen entry. `clam model openai gpt-4o-mini` does the same without the menu for the OpenAI, Anthropic, and Ollama entries; the Groq entries are only reachable through the menu.

On every load each non-empty key is exported as `CLAM_<KEY>` in upper case, and a value in the file overrides a `CLAM_*` variable already in the environment. When a key line is blank, the matching `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, or `GROQ_API_KEY` variable is used instead, and `clam install` seeds the key lines from those variables. Ollama requests carry no key. The Ollama entries point at `http://localhost:11434/api/chat`; change that with `clam config set endpoint <url>`.

| Key | Default | Required | Purpose |
| --- | --- | --- | --- |
| `provider` | `openai` | No | `openai`, `anthropic`, `groq`, or `ollama`. Selects the request format and which key is sent |
| `model` | `gpt-4o` | No | Model name sent in every request |
| `endpoint` | `https://api.openai.com/v1/chat/completions` | No | URL that receives every request |
| `openai_api_key` | value of `OPENAI_API_KEY` | For `openai` | Sent as a bearer token |
| `anthropic_api_key` | value of `ANTHROPIC_API_KEY` | For `anthropic` | Sent in the `x-api-key` header |
| `groq_api_key` | value of `GROQ_API_KEY` | For `groq` | Sent as a bearer token |
| `temperature` | `0.0` | No | Sampling temperature for suggestions and `fep`. Harm checks always use `0.0` |
| `api_prompt_cost`, `api_completion_cost` | `0.000005`, `0.000015` | No | Dollars per token used by `clam usage`. `clam model` overwrites them |
| `max_history_commands` | `20` | No | History entries included in the suggestion prompt |
| `max_recent_files` | `20` | No | Files from the current directory listed in the prompt |
| `cache_dir` | `~/.clam/cache` | No | Suggestion cache. The oldest entries go once it holds more than `cache_size` |
| `cache_size` | `10` | No | Maximum cached suggestion sets. `0` turns the cache off |
| `log_file` | `~/.clam/clam.log` | No | CSV of suggestion requests: timestamp, input hash, prompt tokens, completion tokens, cost |
| `harm_detection_enabled` | `true` | No | Safeguards on or off. Read from the file on every check, so changes apply at once |
| `harm_cache_dir` | `~/.clam/harm_cache` | No | Verdict cache. Nothing is ever evicted from it |
| `harm_timeout` | `3` | No | Seconds a harm check may take before the command is allowed through |
| `timeout` | `30` for suggestions, `60` for `fep` | No | Request timeout in seconds. Not in the default file; add the line to set it |

## Development

The whole tool is `clam.sh`, and the installed `clam` is a symlink to a copy of it, so after editing run `bash install.sh` again and open a new shell. The file is organised top to bottom as: the model table (`CLAM_MODELS`, one JSON entry per provider and model with its per-token prices and endpoint), the prompt builders, the per-provider payload builders, the API call with its retry loop, the completion and Ctrl+Space widget, config loading, the menus and spinner, the safeguard wrappers, one `cmd_*` function per subcommand, and the `case` on `$1` at the bottom that dispatches them. `CLAM_VERSION` at the top is what `clam` prints when run with no arguments.

Run the tests from the repo root:

```bash
chmod +x tests/*.sh
bash run_tests.sh
```

`run_tests.sh` installs `bats` through `apt-get`, `brew`, `dnf`, `yum`, or `pacman` if it is missing, runs `bats tests/`, then runs the four shell scripts in `tests/` by path, which is why they need the executable bit the repository does not store. Every test file calls the live API:

- `test_clam.bats` runs `install.sh` and sources `~/.bashrc` in its setup, so it rewrites your real `~/.bashrc` and `~/.clam`, exits unless an OpenAI key is reachable through the config file or `OPENAI_API_KEY`, and resets the model to `openai gpt-4o` in teardown.
- The four `.sh` scripts call the harm check directly and print their results rather than failing; only `test_rm.sh` exits non-zero. Three of them use `timeout` from GNU coreutils. `test_harm_basic.sh` runs `chmod 777 /etc/passwd`, and the `timeout` in front of it executes the real binary rather than the safeguard wrapper, so run the suite as an unprivileged user.

`USAGE.md` is a numbered checklist for exercising each command by hand. There is no linter, build step, or CI configuration.

## License

MIT, see [LICENSE](./LICENSE). It carries two copyright lines, IC Hack 2026 and ClosedLoop Technologies 2024, because CLAM is derived from autocomplete.sh.
