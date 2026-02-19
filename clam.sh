#!/bin/bash
# Clam.sh - LLM Powered Bash Completion
# MIT License - ClosedLoop Technologies, Inc.
# Sean Kruzel 2024-2025

export CLAM_VERSION=0.5.0

# === Output Helpers ===

error_exit() {
    echo -e "\e[31mClam.sh - $1\e[0m" >&2
    return 1
}

echo_error() {
    echo -e "\e[31mClam.sh - $1\e[0m" >&2
}

echo_green() {
    echo -e "\e[32m$1\e[0m"
}

# === Model Definitions ===

unset CLAM_MODELS
declare -A CLAM_MODELS

CLAM_MODELS['openai:	gpt-4o']='{ "completion_cost":0.0000100, "prompt_cost":0.00000250, "endpoint": "https://api.openai.com/v1/chat/completions", "model": "gpt-4o", "provider": "openai" }'
CLAM_MODELS['openai:	gpt-4o-mini']='{ "completion_cost":0.0000060, "prompt_cost":0.00000015, "endpoint": "https://api.openai.com/v1/chat/completions", "model": "gpt-4o-mini", "provider": "openai" }'
CLAM_MODELS['openai:	o1']='{ "completion_cost":0.0000600, "prompt_cost":0.00001500, "endpoint": "https://api.openai.com/v1/chat/completions", "model": "o1", "provider": "openai" }'
CLAM_MODELS['openai:	o1-mini']='{ "completion_cost":0.0000440, "prompt_cost":0.00001100, "endpoint": "https://api.openai.com/v1/chat/completions", "model": "o1-mini", "provider": "openai" }'
CLAM_MODELS['openai:	o3-mini']='{ "completion_cost":0.0000440, "prompt_cost":0.00001100, "endpoint": "https://api.openai.com/v1/chat/completions", "model": "o3-mini", "provider": "openai" }'

CLAM_MODELS['anthropic:	claude-3-7-sonnet-20250219']='{ "completion_cost":0.0000150, "prompt_cost":0.0000030, "endpoint": "https://api.anthropic.com/v1/messages", "model": "claude-3-7-sonnet-20240219", "provider": "anthropic" }'
CLAM_MODELS['anthropic:	claude-3-5-sonnet-20241022']='{ "completion_cost":0.0000150, "prompt_cost":0.0000030, "endpoint": "https://api.anthropic.com/v1/messages", "model": "claude-3-5-sonnet-20241022", "provider": "anthropic" }'
CLAM_MODELS['anthropic:	claude-3-5-haiku-20241022']='{ "completion_cost":0.0000040, "prompt_cost":0.0000008, "endpoint": "https://api.anthropic.com/v1/messages", "model": "claude-3-5-haiku-20241022", "provider": "anthropic" }'

CLAM_MODELS['groq:		llama3-8b-8192']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama3-8b-8192", "provider": "groq" }'
CLAM_MODELS['groq:		llama3-70b-8192']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama3-70b-8192", "provider": "groq" }'
CLAM_MODELS['groq:		llama-3.3-70b-versatile']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama-3.3-70b-versatile", "provider": "groq" }'
CLAM_MODELS['groq:		llama-3.1-8b-instant']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama-3.1-8b-instant", "provider": "groq" }'
CLAM_MODELS['groq:		llama-guard-3-8b']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama-guard-3-8b", "provider": "groq" }'
CLAM_MODELS['groq:		mixtral-8x7b-32768']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "mixtral-8x7b-32768", "provider": "groq" }'
CLAM_MODELS['groq:		gemma2-9b-it']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "gemma2-9b-it", "provider": "groq" }'
CLAM_MODELS['groq:		mistral-saba-24b']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "mistral-saba-24b", "provider": "groq" }'
CLAM_MODELS['groq:		qwen-2.5-coder-32b']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "qwen-2.5-coder-32b", "provider": "groq" }'
CLAM_MODELS['groq:		deepseek-r1-distill-qwen-32b']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "deepseek-r1-distill-qwen-32b", "provider": "groq" }'
CLAM_MODELS['groq:		deepseek-r1-distill-llama-70b-specdec']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "deepseek-r1-distill-llama-70b-specdec", "provider": "groq" }'
CLAM_MODELS['groq:		llama-3.3-70b-specdec']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama-3.3-70b-specdec", "provider": "groq" }'
CLAM_MODELS['groq:		llama-3.2-1b-preview']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama-3.2-1b-preview", "provider": "groq" }'
CLAM_MODELS['groq:		llama-3.2-3b-preview']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "https://api.groq.com/openai/v1/chat/completions", "model": "llama-3.2-3b-preview", "provider": "groq" }'

CLAM_MODELS['ollama:	codellama']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "http://localhost:11434/api/chat", "model": "codellama", "provider": "ollama" }'
CLAM_MODELS['ollama:	qwen2.5-coder:7b-instruct']='{ "completion_cost":0.0000000, "prompt_cost":0.0000000, "endpoint": "http://localhost:11434/api/chat", "model": "qwen2.5-coder:7b-instruct", "provider": "ollama" }'

# === FEP (Fix Error Please) Context ===

export CLAM_LAST_COMMAND="${CLAM_LAST_COMMAND:-}"
export CLAM_LAST_EXIT_CODE="${CLAM_LAST_EXIT_CODE:-}"
export CLAM_LAST_OUTPUT_FILE="${CLAM_LAST_OUTPUT_FILE:-$HOME/.clam/last_output.txt}"

capture_command_result() {
    export CLAM_LAST_EXIT_CODE="$?"
    export CLAM_LAST_COMMAND="$(fc -ln -1 2>/dev/null | sed 's/^[[:space:]]*//')"
}

# === System Information ===

get_terminal_info() {
    cat <<EOF
 * User name: \$USER=$USER
 * Current directory: \$PWD=$PWD
 * Previous directory: \$OLDPWD=$OLDPWD
 * Home directory: \$HOME=$HOME
 * Operating system: \$OSTYPE=$OSTYPE
 * Shell: \$BASH=$BASH
 * Terminal type: \$TERM=$TERM
 * Hostname: \$HOSTNAME
EOF
}

get_machine_signature() {
    echo "$(uname -a)|$$USER" | md5sum | cut -d ' ' -f 1
}

show_system_info() {
    echo "# System Information"
    echo
    uname -a
    echo "SIGNATURE: $(get_machine_signature)"
    echo
    echo "BASH_VERSION: $BASH_VERSION"
    echo "BASH_COMPLETION_VERSINFO: ${BASH_COMPLETION_VERSINFO}"
    echo
    echo "## Terminal Information"
    get_terminal_info
}

show_completion_vars() {
    echo "BASH_COMPLETION_VERSINFO: ${BASH_COMPLETION_VERSINFO}"
    echo "COMP_CWORD: ${COMP_CWORD}"
    echo "COMP_KEY: ${COMP_KEY}"
    echo "COMP_LINE: ${COMP_LINE}"
    echo "COMP_POINT: ${COMP_POINT}"
    echo "COMP_TYPE: ${COMP_TYPE}"
    echo "COMP_WORDBREAKS: ${COMP_WORDBREAKS}"
    echo "COMP_WORDS: ${COMP_WORDS[*]}"
}

# === Prompt Building ===

get_system_prompt() {
    echo "You are a helpful bash_completion script. Generate relevant and concise auto-complete suggestions for the given user command in the context of the current directory, operating system, command history, and environment variables. For each suggestion, provide both the command and a brief one-line explanation of what it does. The output must be a list of two to five possible completions or rewritten commands. Each must be a valid command or chain of commands. Do not include backticks or quotes in the commands."
}

get_output_instructions() {
    echo "Provide a list of suggested completions or commands that could be run in the terminal. YOU MUST provide a list of two to five possible completions or rewritten commands. For each command, include a brief one-line explanation (max 60 characters) of what it does. DO NOT wrap the commands in backticks or quotes. Each must be a valid command or chain of commands. Focus on the user's intent, recent commands, and the current environment. RETURN A JSON OBJECT WITH THE COMPLETIONS AND THEIR EXPLANATIONS."
}

get_command_history() {
    local history_limit=${CLAM_MAX_HISTORY_COMMANDS:-20}
    history | tail -n "$history_limit"
}

get_sanitized_history() {
    local history_output
    history_output=$(get_command_history)
    history_output=$(echo "$history_output" | sed -E 's/\b[[:xdigit:]]{32,40}\b/REDACTED_HASH/g')
    history_output=$(echo "$history_output" | sed -E 's/\b[0-9a-fA-F-]{36}\b/REDACTED_UUID/g')
    history_output=$(echo "$history_output" | sed -E 's/\b[A-Za-z0-9]{16,40}\b/REDACTED_APIKEY/g')
    echo "$history_output"
}

get_recent_files() {
    local file_limit=${CLAM_MAX_RECENT_FILES:-20}
    find . -maxdepth 1 -type f -exec ls -ld {} + | sort -r | head -n "$file_limit"
}

get_command_help() {
    local command_name help_output
    command_name=$(echo "$1" | awk '{print $1}')
    help_output=""
    {
        set +e
        help_output=$($command_name --help 2>&1 || true)
        set -e
    } || help_output="'$command_name --help' not available"
    echo "$help_output"
}

build_prompt() {
    local user_input="$*"
    local command_history=$(get_sanitized_history)
    local terminal_context=$(get_terminal_info)
    local help_message=$(get_command_help "$user_input")
    local recent_files=$(get_recent_files)
    local output_instructions=$(get_output_instructions)
    local env_vars=$(env | grep '=' | grep -v 'CLAM_' | awk -F= '{print $1}' | grep -v 'PWD\|OSTYPE\|BASH\|USER\|HOME\|TERM\|OLDPWD\|HOSTNAME')

    cat <<EOF
User command: \`$user_input\`

# Terminal Context
## Environment variables
$terminal_context

Other defined environment variables
\`\`\`
$env_vars
\`\`\`

## History
Recently run commands (some information redacted):
\`\`\`
$command_history
\`\`\`

## File system
Most recently modified files:
\`\`\`
$recent_files
\`\`\`

## Help Information
$help_message

# Instructions
$output_instructions
EOF
}

build_fep_prompt() {
    local user_context="$1"
    local last_cmd="${CLAM_LAST_COMMAND:-$(fc -ln -1 2>/dev/null | sed 's/^[[:space:]]*//')}"
    local last_exit="${CLAM_LAST_EXIT_CODE:-$?}"
    local last_output=""

    [[ -f "$CLAM_LAST_OUTPUT_FILE" ]] && last_output="$(tail -100 "$CLAM_LAST_OUTPUT_FILE")"

    cat <<EOF
# Error Recovery Request

## Failed Command
\`\`\`bash
$last_cmd
\`\`\`

## Exit Code
$last_exit

## Command Output/Error
\`\`\`
${last_output:-"(No captured output - please describe the error)"}
\`\`\`

## Additional Context from User
${user_context:-"(None provided)"}

## Environment
$(get_terminal_info)

## Current Directory Contents
$(ls -la 2>/dev/null | head -20)

## Recent Command History
$(fc -ln -10 2>/dev/null)

# Instructions
Analyze the failed command and error. Provide:
1. **Recommended Command**: A corrected or alternative command that fixes the issue
2. **Explanation**: Brief explanation of what went wrong and why the fix works

Respond in this exact JSON format:
{
    "recommended_command": "the fixed command here",
    "explanation": "brief explanation of the fix"
}
EOF
}

# === Payload Building ===

build_base_payload() {
    jq -n --arg model "$model" \
          --arg temperature "$temperature" \
          --arg system_prompt "$system_prompt" \
          --arg prompt_content "$prompt_content" \
          '{
             model: $model,
             messages: [
               {role: "system", content: $system_prompt},
               {role: "user", content: $prompt_content}
             ],
             temperature: ($temperature | tonumber)
          }'
}

build_completion_payload() {
    local user_input="$1"
    local model="${CLAM_MODEL:-gpt-4o}"
    local temperature="${CLAM_TEMPERATURE:-0.0}"
    local prompt=$(build_prompt "$@")
    local system_prompt=$(get_system_prompt)
    local prompt_content="$prompt"
    local full_prompt="# SYSTEM PROMPT
$system_prompt
# USER MESSAGE
$prompt"
    export CLAM_PROMPT="$full_prompt"

    local payload_base=$(build_base_payload)

    case "${CLAM_PROVIDER^^}" in
        "ANTHROPIC")
            echo "$payload_base" | jq '. + {
                system: .messages[0].content,
                messages: [{role:"user", content: .messages[1].content}],
                max_tokens: 1024,
                tool_choice: {type: "tool", name: "bash_completions"},
                tools: [{
                    name: "bash_completions",
                    description: "syntactically correct command-line suggestions with explanations",
                    input_schema: {
                        type: "object",
                        properties: {
                            suggestions: {
                                type: "array",
                                items: {
                                    type: "object",
                                    properties: {
                                        command: {type: "string", description: "The suggested command"},
                                        explanation: {type: "string", description: "Brief explanation of what the command does"}
                                    },
                                    required: ["command", "explanation"]
                                }
                            }
                        },
                        required: ["suggestions"]
                    }
                }]
            }'
            ;;
        "GROQ")
            echo "$payload_base" | jq '. + {response_format: {type: "json_object"}}'
            ;;
        "OLLAMA")
            echo "$payload_base" | jq '. + {
                format: "json",
                stream: false,
                options: {temperature: (.temperature | tonumber)}
            }'
            ;;
        *)
            echo "$payload_base" | jq '. + {
                response_format: {type: "json_object"},
                tool_choice: {
                    type: "function",
                    function: {
                        name: "bash_completions",
                        description: "syntactically correct command-line suggestions with explanations",
                        parameters: {
                            type: "object",
                            properties: {
                                suggestions: {
                                    type: "array",
                                    items: {
                                        type: "object",
                                        properties: {
                                            command: {type: "string", description: "The suggested command"},
                                            explanation: {type: "string", description: "Brief explanation of what the command does"}
                                        },
                                        required: ["command", "explanation"]
                                    }
                                }
                            },
                            required: ["suggestions"]
                        }
                    }
                },
                tools: [{
                    type: "function",
                    function: {
                        name: "bash_completions",
                        description: "syntactically correct command-line suggestions with explanations",
                        parameters: {
                            type: "object",
                            properties: {
                                suggestions: {
                                    type: "array",
                                    items: {
                                        type: "object",
                                        properties: {
                                            command: {type: "string", description: "The suggested command"},
                                            explanation: {type: "string", description: "Brief explanation of what the command does"}
                                        },
                                        required: ["command", "explanation"]
                                    }
                                }
                            },
                            required: ["suggestions"]
                        }
                    }
                }]
            }'
            ;;
    esac
}

build_fep_payload() {
    local prompt="$1"
    local model="${CLAM_MODEL:-gpt-4o}"
    local temperature="${CLAM_TEMPERATURE:-0.0}"
    local system_prompt="You are an expert command-line debugger. Analyze errors and provide fixes. Respond only with valid JSON in this exact format: {\"recommended_command\": \"the fixed command\", \"explanation\": \"brief explanation\"}."

    local payload_base=$(jq -n --arg model "$model" \
        --arg temperature "$temperature" \
        --arg system_prompt "$system_prompt" \
        --arg prompt "$prompt" \
        '{
            model: $model,
            messages: [
                {role: "system", content: $system_prompt},
                {role: "user", content: $prompt}
            ],
            temperature: ($temperature | tonumber)
        }')

    case "${CLAM_PROVIDER^^}" in
        "ANTHROPIC")
            echo "$payload_base" | jq '. + {max_tokens: 1024}'
            ;;
        "GROQ")
            echo "$payload_base" | jq '. + {response_format: {type: "json_object"}}'
            ;;
        "OLLAMA")
            echo "$payload_base" | jq '. + {format: "json", stream: false}'
            ;;
        *)
            echo "$payload_base" | jq '. + {response_format: {type: "json_object"}}'
            ;;
    esac
}

build_harm_detection_payload() {
    local command="$1"
    local model="${CLAM_MODEL:-gpt-4o}"
    local temperature="0.0"
    local system_prompt="You are a bash command security analyzer. Your role is to identify potentially harmful bash commands that could cause data loss, system damage, security risks, or unintended consequences. Analyze commands for: destructive file operations, system modifications, permission changes, network security risks, resource consumption attacks, and dangerous command chaining."
    local prompt_content="Analyze this bash command for potential harm:

Command: $command

Classify this command and respond with ONLY a JSON object in this exact format:
{
  \"is_harmful\": true or false,
  \"explanation\": \"Brief explanation of why this command is harmful or safe (max 100 chars)\"
}"

    local payload_base=$(jq -n --arg model "$model" \
                         --arg temperature "$temperature" \
                         --arg system_prompt "$system_prompt" \
                         --arg prompt_content "$prompt_content" \
                         '{
                            model: $model,
                            messages: [
                              {role: "system", content: $system_prompt},
                              {role: "user", content: $prompt_content}
                            ],
                            temperature: ($temperature | tonumber)
                          }')

    case "${CLAM_PROVIDER^^}" in
        "ANTHROPIC")
            echo "$payload_base" | jq '. + {
                system: .messages[0].content,
                messages: [{role:"user", content: .messages[1].content}],
                max_tokens: 512,
                tool_choice: {type: "tool", name: "harm_assessment"},
                tools: [{
                    name: "harm_assessment",
                    description: "Assess if a bash command is potentially harmful",
                    input_schema: {
                        type: "object",
                        properties: {
                            is_harmful: {type: "boolean", description: "Whether the command is harmful"},
                            explanation: {type: "string", description: "Brief explanation of the assessment"}
                        },
                        required: ["is_harmful", "explanation"]
                    }
                }]
            }'
            ;;
        "GROQ")
            echo "$payload_base" | jq '. + {response_format: {type: "json_object"}}'
            ;;
        "OLLAMA")
            echo "$payload_base" | jq '. + {
                format: "json",
                stream: false,
                options: {temperature: 0.0}
            }'
            ;;
        *)
            echo "$payload_base" | jq '. + {
                tools: [{
                    type: "function",
                    function: {
                        name: "harm_assessment",
                        description: "Assess if a bash command is potentially harmful",
                        parameters: {
                            type: "object",
                            properties: {
                                is_harmful: {type: "boolean", description: "Whether the command is harmful"},
                                explanation: {type: "string", description: "Brief explanation"}
                            },
                            required: ["is_harmful", "explanation"]
                        }
                    }
                }],
                tool_choice: {type: "function", function: {name: "harm_assessment"}}
            }'
            ;;
    esac
}

# === API Communication ===

log_api_request() {
    local user_input="$1"
    local response_body="$2"
    local input_hash=$(echo -n "$user_input" | md5sum | cut -d ' ' -f 1)
    local prompt_tokens completion_tokens created api_cost

    if [[ "${CLAM_PROVIDER^^}" == "ANTHROPIC" ]]; then
        prompt_tokens=$(echo "$response_body" | jq -r '.usage.input_tokens')
        completion_tokens=$(echo "$response_body" | jq -r '.usage.output_tokens')
    else
        prompt_tokens=$(echo "$response_body" | jq -r '.usage.prompt_tokens')
        completion_tokens=$(echo "$response_body" | jq -r '.usage.completion_tokens')
    fi

    prompt_tokens=$((prompt_tokens))
    completion_tokens=$((completion_tokens))
    created=$(date +%s)
    created=$(echo "$response_body" | jq -r ".created // $created")
    api_cost=$(echo "$prompt_tokens * $CLAM_API_PROMPT_COST + $completion_tokens * $CLAM_API_COMPLETION_COST" | bc)

    local log_file=${CLAM_LOG_FILE:-"$HOME/.clam/clam.log"}
    echo "$created,$input_hash,$prompt_tokens,$completion_tokens,$api_cost" >> "$log_file"
}

call_api() {
    local endpoint="$1"
    local payload="$2"
    local api_key="$3"
    local timeout="$4"

    if [[ "${CLAM_PROVIDER^^}" == "ANTHROPIC" ]]; then
        command curl -s -m "$timeout" -w "\n%{http_code}" "$endpoint" \
            -H "content-type: application/json" \
            -H "anthropic-version: 2023-06-01" \
            -H "x-api-key: $api_key" \
            --data "$payload"
    elif [[ "${CLAM_PROVIDER^^}" == "OLLAMA" ]]; then
        command curl -s -m "$timeout" -w "\n%{http_code}" "$endpoint" --data "$payload"
    else
        command curl -s -m "$timeout" -w "\n%{http_code}" "$endpoint" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $api_key" \
            -d "$payload"
    fi
}

get_completion() {
    local endpoint=${CLAM_ENDPOINT:-"https://api.openai.com/v1/chat/completions"}
    local timeout=${CLAM_TIMEOUT:-30}
    local default_input="Write two to six most likely commands given the provided information"
    local user_input=${*:-$default_input}

    if [[ -z "$CLAM_ACTIVE_API_KEY" && ${CLAM_PROVIDER^^} != "OLLAMA" ]]; then
        echo_error "CLAM_ACTIVE_API_KEY not set. Please set it with: export ${CLAM_PROVIDER^^}_API_KEY=<your-api-key>"
        return
    fi

    local api_key="$CLAM_ACTIVE_API_KEY"
    local payload=$(build_completion_payload "$user_input")
    local max_attempts=2
    local attempt=1
    local response status_code response_body

    while [ $attempt -le $max_attempts ]; do
        response=$(call_api "$endpoint" "$payload" "$api_key" "$timeout")
        status_code=$(echo "$response" | tail -n1)
        response_body=$(echo "$response" | sed '$d')

        if [[ $status_code -eq 200 ]]; then
            break
        else
            echo_error "API call failed with status $status_code. Retrying... (Attempt $attempt of $max_attempts)"
            sleep 1
            attempt=$((attempt+1))
        fi
    done

    if [[ $status_code -ne 200 ]]; then
        case $status_code in
            400) echo_error "Bad Request: The API request was invalid or malformed." ;;
            401) echo_error "Unauthorized: The provided API key is invalid or missing." ;;
            429) echo_error "Too Many Requests: The API rate limit has been exceeded." ;;
            500) echo_error "Internal Server Error: An unexpected error occurred on the API server." ;;
            *) echo_error "Unknown Error: Unexpected status code $status_code received. Response: $response_body" ;;
        esac
        return
    fi

    local content
    if [[ "${CLAM_PROVIDER^^}" == "ANTHROPIC" ]]; then
        content=$(echo "$response_body" | jq -r '.content[0].input.suggestions')
    elif [[ "${CLAM_PROVIDER^^}" == "GROQ" ]]; then
        content=$(echo "$response_body" | jq -r '.choices[0].message.content')
        content=$(echo "$content" | jq -r '.suggestions // .completions')
    elif [[ "${CLAM_PROVIDER^^}" == "OLLAMA" ]]; then
        content=$(echo "$response_body" | jq -r '.message.content')
        content=$(echo "$content" | jq -r '.suggestions // .completions')
    else
        content=$(echo "$response_body" | jq -r '.choices[0].message.tool_calls[0].function.arguments')
        content=$(echo "$content" | jq -r '.suggestions // .commands')
    fi

    local completions
    if echo "$content" | jq -e 'type == "array"' &>/dev/null; then
        completions=$(echo "$content" | jq -r '.[] | .command + "|||" + .explanation' | grep -v '^$')
    else
        completions=$(echo "$content" | jq -r '.[]' | grep -v '^$' | sed 's/$/|||/')
    fi

    echo -n "$completions"
    log_api_request "$user_input" "$response_body"
}

get_fep_completion() {
    local user_context="$1"
    local prompt=$(build_fep_prompt "$user_context")
    local endpoint="${CLAM_ENDPOINT:-https://api.openai.com/v1/chat/completions}"
    local timeout="${CLAM_TIMEOUT:-60}"
    local api_key="$CLAM_ACTIVE_API_KEY"

    if [[ -z "$api_key" && "${CLAM_PROVIDER^^}" != "OLLAMA" ]]; then
        echo_error "CLAM_ACTIVE_API_KEY not set. Run: clam config (or set OPENAI_API_KEY)"
        return 1
    fi

    local payload=$(build_fep_payload "$prompt")
    local max_attempts=2
    local attempt=1
    local response status_code response_body

    while [[ $attempt -le $max_attempts ]]; do
        response=$(call_api "$endpoint" "$payload" "$api_key" "$timeout")
        status_code=$(echo "$response" | tail -n1)
        response_body=$(echo "$response" | sed '$d')

        if [[ $status_code -eq 200 ]]; then
            break
        fi
        echo_error "API call failed with status $status_code. Retrying... (Attempt $attempt of $max_attempts)" >&2
        sleep 1
        attempt=$((attempt + 1))
    done

    if [[ $status_code -ne 200 ]]; then
        echo_error "FEP request failed. Status: $status_code"
        return 1
    fi

    echo "$response_body"
}

detect_command_harm() {
    local command="$1"
    load_config

    local command_hash=$(echo -n "$command" | md5sum | cut -d ' ' -f 1)
    local cache_dir="${CLAM_HARM_CACHE_DIR:-$HOME/.clam/harm_cache}"
    local cache_file="$cache_dir/harm-$command_hash.json"

    if [[ -d "$cache_dir" && -f "$cache_file" ]]; then
        cat "$cache_file"
        return 0
    fi

    local endpoint=${CLAM_ENDPOINT:-"https://api.openai.com/v1/chat/completions"}
    local timeout=${CLAM_HARM_TIMEOUT:-3}
    local api_key="$CLAM_ACTIVE_API_KEY"
    local payload=$(build_harm_detection_payload "$command")

    local response=$(call_api "$endpoint" "$payload" "$api_key" "$timeout")
    local status_code=$(echo "$response" | tail -n1)
    local response_body=$(echo "$response" | sed '$d')

    if [[ $status_code -ne 200 ]]; then
        echo_error "Harm detection API call failed with status $status_code. Allowing command execution." >&2
        echo '{"is_harmful":false,"explanation":"API unavailable - defaulting to safe"}'
        return 0
    fi

    local harm_data
    if [[ "${CLAM_PROVIDER^^}" == "ANTHROPIC" ]]; then
        harm_data=$(echo "$response_body" | jq -r '.content[0].input')
    elif [[ "${CLAM_PROVIDER^^}" == "GROQ" ]]; then
        harm_data=$(echo "$response_body" | jq -r '.choices[0].message.content')
    elif [[ "${CLAM_PROVIDER^^}" == "OLLAMA" ]]; then
        harm_data=$(echo "$response_body" | jq -r '.message.content')
    else
        local arguments_string=$(echo "$response_body" | jq -r '.choices[0].message.tool_calls[0].function.arguments // .choices[0].message.content')
        harm_data=$(echo "$arguments_string" | jq -c '.')
    fi

    if ! echo "$harm_data" | jq -e 'has("is_harmful")' &>/dev/null; then
        echo_error "Malformed harm detection response. Allowing command execution." >&2
        echo '{"is_harmful":false,"explanation":"Malformed response - defaulting to safe"}'
        return 0
    fi

    mkdir -p "$cache_dir"
    echo "$harm_data" > "$cache_file"
    echo "$harm_data"
}

# === Bash Completion ===

get_default_completion_func() {
    local cmd="$1"
    complete -p "$cmd" 2>/dev/null | awk -F' ' '{ for(i=1;i<=NF;i++) { if ($i ~ /^-F$/) { print $(i+1); exit; } } }'
}

run_default_completion() {
    local current_word="" first_word="" default_func

    if [[ -n "${COMP_WORDS[*]}" ]]; then
        first_word="${COMP_WORDS[0]}"
        if [[ -n "$COMP_CWORD" && "$COMP_CWORD" -lt "${#COMP_WORDS[@]}" ]]; then
            current_word="${COMP_WORDS[COMP_CWORD]}"
        fi
    fi

    default_func=$(get_default_completion_func "$first_word")
    if [[ -n "$default_func" ]]; then
        "$default_func"
    else
        local file_completions
        if [[ -z "$current_word" ]]; then
            file_completions=$(compgen -f -- || true)
        else
            file_completions=$(compgen -f -- "$current_word" || true)
        fi
        if [[ -n "$file_completions" ]]; then
            readarray -t COMPREPLY <<<"$file_completions"
        fi
    fi
}

list_cache() {
    local cache_dir=${CLAM_CACHE_DIR:-"$HOME/.clam/cache"}
    find "$cache_dir" -maxdepth 1 -type f -name "acsh-*" -printf '%T+ %p\n' | sort
}

clam_completion() {
    _init_completion || return
    run_default_completion
}

interactive_clam_widget() {
    local user_input="${READLINE_LINE}"
    local show_explanations=false

    if [[ -z "$user_input" ]]; then
        return
    fi

    if [[ "$user_input" == *"--explain"* ]]; then
        show_explanations=true
        user_input="${user_input%%--explain*}"
        user_input="${user_input%% }"
    fi

    load_config

    if [[ -z "$CLAM_ACTIVE_API_KEY" && ${CLAM_PROVIDER^^} != "OLLAMA" ]]; then
        echo
        echo_error "API key not set. Configure with: clam config"
        return
    fi

    local input_hash=$(echo -n "$user_input" | md5sum | cut -d ' ' -f 1)
    local cache_dir=${CLAM_CACHE_DIR:-"$HOME/.clam/cache"}
    local cache_size=${CLAM_CACHE_SIZE:-100}
    local cache_file="$cache_dir/acsh-$input_hash.txt"
    local completions

    if [[ -d "$cache_dir" && "$cache_size" -gt 0 && -f "$cache_file" ]]; then
        completions=$(cat "$cache_file" || true)
        touch "$cache_file"
    else
        echo
        start_spinner "Generating suggestions..."
        completions=$(get_completion "$user_input" || true)
        stop_spinner

        if [[ -z "$completions" ]]; then
            echo_error "Failed to generate completions"
            return
        fi

        if [[ -d "$cache_dir" && "$cache_size" -gt 0 ]]; then
            echo "$completions" > "$cache_file"
            while [[ $(list_cache | wc -l) -gt "$cache_size" ]]; do
                local oldest=$(list_cache | head -n 1 | cut -d ' ' -f 2-)
                rm "$oldest" || true
            done
        fi
    fi

    if [[ -n "$completions" ]]; then
        show_interactive_menu "$completions" "$show_explanations"
        READLINE_LINE=""
        READLINE_POINT=0
    fi
}

# === Configuration Management ===

is_subshell() {
    [[ "$$" != "$BASHPID" ]]
}

is_being_sourced() {
    [[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

load_config() {
    local config_file="$HOME/.clam/config"

    if [ -f "$config_file" ]; then
        while IFS=':' read -r key value; do
            if [[ $key =~ ^# ]] || [[ -z $key ]]; then
                continue
            fi
            key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            key=$(echo "$key" | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z0-9]/_/g')
            if [[ -n $value ]]; then
                export "CLAM_$key"="$value"
            fi
        done < "$config_file"

        [[ -z "$CLAM_OPENAI_API_KEY" && -n "$OPENAI_API_KEY" ]] && export CLAM_OPENAI_API_KEY="$OPENAI_API_KEY"
        [[ -z "$CLAM_ANTHROPIC_API_KEY" && -n "$ANTHROPIC_API_KEY" ]] && export CLAM_ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
        [[ -z "$CLAM_GROQ_API_KEY" && -n "$GROQ_API_KEY" ]] && export CLAM_GROQ_API_KEY="$GROQ_API_KEY"
        [[ -z "$CLAM_OLLAMA_API_KEY" && -n "$LLM_API_KEY" ]] && export CLAM_OLLAMA_API_KEY="$LLM_API_KEY"
        [[ -z "$CLAM_OLLAMA_API_KEY" && -n "$CLAM_CUSTOM_API_KEY" ]] && export CLAM_OLLAMA_API_KEY="$CLAM_CUSTOM_API_KEY"

        case "${CLAM_PROVIDER:-openai}" in
            "openai") export CLAM_ACTIVE_API_KEY="$CLAM_OPENAI_API_KEY" ;;
            "anthropic") export CLAM_ACTIVE_API_KEY="$CLAM_ANTHROPIC_API_KEY" ;;
            "groq") export CLAM_ACTIVE_API_KEY="$CLAM_GROQ_API_KEY" ;;
            "ollama") export CLAM_ACTIVE_API_KEY="$CLAM_OLLAMA_API_KEY" ;;
            *) echo_error "Unknown provider: $CLAM_PROVIDER" ;;
        esac
    else
        echo "Configuration file not found: $config_file"
    fi
}

create_default_config() {
    local config_file="$HOME/.clam/config"

    if [ ! -f "$config_file" ]; then
        echo "Creating default configuration file at ~/.clam/config"
        cat > "$config_file" <<EOF
# ~/.clam/config

# OpenAI API Key
openai_api_key: $OPENAI_API_KEY

# Anthropic API Key
anthropic_api_key: $ANTHROPIC_API_KEY

# Groq API Key
groq_api_key: $GROQ_API_KEY

# Custom API Key for Ollama
custom_api_key: $LLM_API_KEY

# Model configuration
provider: openai
model: gpt-4o
temperature: 0.0
endpoint: https://api.openai.com/v1/chat/completions
api_prompt_cost: 0.000005
api_completion_cost: 0.000015

# Max history and recent files
max_history_commands: 20
max_recent_files: 20

# Cache settings
cache_dir: $HOME/.clam/cache
cache_size: 10

# Logging settings
log_file: $HOME/.clam/clam.log

# Harm detection settings
harm_detection_enabled: true
harm_cache_dir: $HOME/.clam/harm_cache
harm_cache_size: 100
harm_timeout: 3
EOF
    fi
}

set_config_value() {
    local key="$1"
    local value="$2"
    local config_file="$HOME/.clam/config"

    key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [ -z "$key" ]; then
        echo_error "SyntaxError: expected 'clam config set <key> <value>'"
        return
    fi
    if [ ! -f "$config_file" ]; then
        echo_error "Configuration file not found: $config_file. Run clam install."
        return
    fi
    sed -i "s|^\($key:\).*|\1 $value|" "$config_file"
    load_config
}

# === UI Components ===

spinner_pid=""

start_spinner() {
    local message="${1:-Loading...}"
    tput civis 2>/dev/null || true
    (
        local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local idx=0
        while true; do
            printf "\r\e[90m${spin:$idx:1} %s\e[0m" "$message"
            idx=$(( (idx + 1) % 10 ))
            sleep 0.1
        done
    ) &
    spinner_pid=$!
}

stop_spinner() {
    if [[ -n "$spinner_pid" ]]; then
        kill "$spinner_pid" 2>/dev/null
        wait "$spinner_pid" 2>/dev/null
        spinner_pid=""
    fi
    printf "\r\e[K"
    tput cnorm 2>/dev/null || true
}

show_clam_banner() {
    echo -e "\e[1;36m"
    echo "   ██████╗██╗      █████╗ ███╗   ███╗"
    echo "  ██╔════╝██║     ██╔══██╗████╗ ████║"
    echo "  ██║     ██║     ███████║██╔████╔██║"
    echo "  ██║     ██║     ██╔══██║██║╚██╔╝██║"
    echo "  ╚██████╗███████╗██║  ██║██║ ╚═╝ ██║"
    echo "   ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝"
    echo -e "\e[0m"
}

read_key() {
    IFS= read -rsn1 key 2>/dev/null >&2
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case "$key" in
            [A) echo up ;;
            [B) echo down ;;
            [C) echo right ;;
            [D) echo left ;;
            q) echo q ;;
        esac
    elif [[ $key == "q" ]]; then
        echo q
    elif [[ $key == $'\x7f' || $key == $'\x08' ]]; then
        echo backspace
    else
        echo "$key"
    fi
}

show_interactive_menu() {
    local completions_str="$1"
    local show_explanations="${2:-false}"
    local options=()
    local explanations=()

    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            if [[ "$line" == *"|||"* ]]; then
                options+=("${line%%|||*}")
                explanations+=("${line#*|||}")
            else
                options+=("$line")
                explanations+=("")
            fi
        fi
    done <<< "$completions_str"

    if [[ ${#options[@]} -eq 0 ]]; then
        return 1
    fi

    local selected=0

    echo
    echo -e "\e[1;36m╔════════════════════════════════════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║\e[0m  \e[1;32mClam Suggestions\e[0m                                        \e[1;36m║\e[0m"
    echo -e "\e[1;36m╠════════════════════════════════════════════════════════════════════╣\e[0m"
    echo -e "\e[1;36m║\e[0m  \e[90mUse ↑/↓ to navigate, Enter to execute, Esc to cancel\e[0m          \e[1;36m║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════════════════════════════════════╝\e[0m"
    echo

    render_menu() {
        for idx in "${!options[@]}"; do
            if [[ $idx -eq $selected ]]; then
                echo -e "  \e[1;32m▶ ${options[idx]}\e[0m"
                if [[ "$show_explanations" == "true" && -n "${explanations[idx]}" ]]; then
                    echo -e "    \e[37m${explanations[idx]}\e[0m"
                fi
            else
                echo -e "    \e[32m${options[idx]}\e[0m"
                if [[ "$show_explanations" == "true" && -n "${explanations[idx]}" ]]; then
                    echo -e "    \e[37m${explanations[idx]}\e[0m"
                fi
            fi
            if [[ "$show_explanations" == "true" && $idx -lt $((${#options[@]} - 1)) ]]; then
                echo
            fi
        done
    }

    clear_menu() {
        local line_count=0
        for idx in "${!options[@]}"; do
            ((line_count++))
            if [[ "$show_explanations" == "true" && -n "${explanations[idx]}" ]]; then
                ((line_count++))
            fi
            if [[ "$show_explanations" == "true" && $idx -lt $((${#options[@]} - 1)) ]]; then
                ((line_count++))
            fi
        done
        tput cuu $line_count
        tput ed
    }

    render_menu

    while true; do
        local key=$(read_key)

        case $key in
            up)
                ((selected--))
                ((selected < 0)) && selected=$((${#options[@]} - 1))
                clear_menu
                render_menu
                ;;
            down)
                ((selected++))
                ((selected >= ${#options[@]})) && selected=0
                clear_menu
                render_menu
                ;;
            q|$'\x1b')
                clear_menu
                echo -e "\e[90mCanceled.\e[0m"
                return 1
                ;;
            "")
                clear_menu
                local selected_cmd="${options[selected]}"

                local config_file="$HOME/.clam/config"
                local safeguards_enabled="true"
                if [ -f "$config_file" ]; then
                    safeguards_enabled=$(grep "^harm_detection_enabled:" "$config_file" | awk '{print $2}' | tr -d ' ')
                    [[ -z "$safeguards_enabled" ]] && safeguards_enabled="true"
                fi

                if [[ "$safeguards_enabled" == "true" ]]; then
                    local harm_result=$(detect_command_harm "$selected_cmd")
                    local is_harmful=$(echo "$harm_result" | jq -r '.is_harmful')
                    local explanation=$(echo "$harm_result" | jq -r '.explanation')

                    if [[ "$is_harmful" == "true" ]]; then
                        echo -e "\e[1;33m⚠ WARNING: Potentially harmful command detected!\e[0m"
                        echo -e "\e[1;32m▶ Command:\e[0m $selected_cmd"
                        echo -e "\e[1;90m▶ Reason:\e[0m $explanation"
                        echo
                        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
                        echo
                        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                            echo -e "\e[90mCommand cancelled.\e[0m"
                            return 1
                        fi
                    fi
                fi

                echo -e "\e[1;32m▶ Executing:\e[0m $selected_cmd"
                echo
                history -s "$selected_cmd"
                eval "$selected_cmd"
                return 0
                ;;
        esac
    done
}

show_model_selector() {
    local options=("$@")
    local selected=0

    render_model_menu() {
        echo
        echo "Select a Language Model (Up/Down arrows, Enter to select, 'q' to quit):"
        for idx in "${!options[@]}"; do
            if [[ $idx -eq $selected ]]; then
                echo -e "\e[1;32m> ${options[idx]}\e[0m"
            else
                echo "  ${options[idx]}"
            fi
        done
    }

    tput sc
    while true; do
        tput rc; tput ed
        render_model_menu
        local key=$(read_key)

        case $key in
            up)
                ((selected--))
                ((selected < 0)) && selected=$((${#options[@]} - 1))
                ;;
            down)
                ((selected++))
                ((selected >= ${#options[@]})) && selected=0
                ;;
            q)
                echo "Selection canceled."
                return 1
                ;;
            "")
                break
                ;;
        esac
    done
    clear
    return $selected
}

# === Safeguard System ===

check_command_safety() {
    local cmd_name="$1"
    shift
    local full_cmd="$cmd_name $*"

    local config_file="$HOME/.clam/config"
    local safeguards_enabled="true"
    if [ -f "$config_file" ]; then
        safeguards_enabled=$(grep "^harm_detection_enabled:" "$config_file" | awk '{print $2}' | tr -d ' ')
        [[ -z "$safeguards_enabled" ]] && safeguards_enabled="true"
    fi

    if [[ "$safeguards_enabled" != "true" ]]; then
        return 0
    fi

    if [[ -n "${_CLAM_IN_SAFEGUARD:-}" ]]; then
        return 0
    fi

    export _CLAM_IN_SAFEGUARD=1

    if ! type -t detect_command_harm &>/dev/null; then
        unset _CLAM_IN_SAFEGUARD
        return 0
    fi

    local harm_result=$(detect_command_harm "$full_cmd" 2>/dev/null)
    local is_harmful=$(echo "$harm_result" | jq -r '.is_harmful')
    local explanation=$(echo "$harm_result" | jq -r '.explanation')

    unset _CLAM_IN_SAFEGUARD

    if [[ "$is_harmful" == "true" ]]; then
        echo -e "\e[1;33m⚠ WARNING: Potentially harmful command detected!\e[0m"
        echo -e "\e[1;32m▶ Command:\e[0m $full_cmd"
        echo -e "\e[1;90m▶ Reason:\e[0m $explanation"
        echo
        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "\e[90mCommand cancelled.\e[0m"
            return 1
        fi
    fi
    return 0
}

enable_safeguards() {
    local risky_commands=("rm" "dd" "mkfs" "shutdown" "reboot" "chmod" "chown" "curl" "wget")

    for cmd in "${risky_commands[@]}"; do
        local cmd_path=$(type -p "$cmd" 2>/dev/null)

        if [[ -n "$cmd_path" ]] && ! type -t "_original_$cmd" &>/dev/null; then
            eval "_original_$cmd() { $cmd_path \"\$@\"; }"
            eval "$cmd() {
                if check_command_safety \"$cmd\" \"\$@\"; then
                    _original_$cmd \"\$@\"
                else
                    return 1
                fi
            }"
        fi
    done

    export -f check_command_safety
    export -f detect_command_harm
    export -f load_config
    export -f build_harm_detection_payload
    export -f echo_error

    for cmd in "${risky_commands[@]}"; do
        [[ $(type -t "$cmd") == "function" ]] && export -f "$cmd"
        [[ $(type -t "_original_$cmd") == "function" ]] && export -f "_original_$cmd"
    done
}

disable_safeguards() {
    local risky_commands=("rm" "dd" "mkfs" "shutdown" "reboot" "chmod" "chown" "curl" "wget")

    for cmd in "${risky_commands[@]}"; do
        if type -t "_original_$cmd" &>/dev/null; then
            unset -f "$cmd"
            unset -f "_original_$cmd"
        fi
    done

    [[ $(type -t check_command_safety) == "function" ]] && unset -f check_command_safety
}

is_enabled() {
    local enabled_count=$(complete -p | grep clam_completion | grep -cv clam_cli_completion)
    (( enabled_count > 0 ))
}

# === CLI Commands ===

show_help() {
    echo_green "Clam.sh - LLM Powered Bash Completion"
    echo "Usage: clam [options] command"
    echo "       clam [options] install|remove|config|model|enable|disable|safeguard|clear|usage|system|command|fep|--help"
    echo
    echo "Clam.sh enhances bash completion with LLM capabilities."
    echo
    echo -e "\e[1;32mUsage:\e[0m"
    echo "  - Press Tab twice for suggestions (standard completion)"
    echo "  - Press Ctrl+Space for interactive menu (navigate with ↑/↓, Enter to execute)"
    echo "  - Add '--explain' to your command to show explanations in the interactive menu"
    echo "  - AI-powered safeguards detect harmful commands and require confirmation"
    echo "  - Harm assessments are cached for instant feedback on repeated commands"
    echo
    echo "Commands:"
    echo "  demo                Show feature overview and usage examples"
    echo "  command             Run clam (simulate double Tab)"
    echo "  command --dry-run   Show prompt without executing"
    echo "  fep [context]       Fix error please - analyze last failed command and suggest fix"
    echo "  model               Change language model"
    echo "  usage               Display usage stats"
    echo "  system              Display system information"
    echo "  config              Show or set configuration values"
    echo "    config set <key> <value>  Set a config value"
    echo "    config reset             Reset config to defaults"
    echo "  install             Install clam to .bashrc"
    echo "  remove              Remove installation from .bashrc"
    echo "  enable              Enable clam"
    echo "  disable             Disable clam"
    echo "  safeguard <action>  Manage harmful command detection"
    echo "    enable            Enable safeguards"
    echo "    disable           Disable safeguards"
    echo "    status            Show safeguard status"
    echo "  clear               Clear cache and log files"
    echo "  --help              Show this help message"
}

cmd_show_config() {
    local config_file="$HOME/.clam/config"
    echo_green "Clam.sh - Configuration and Settings - Version $CLAM_VERSION"

    if ! is_being_sourced; then
        echo "  STATUS: Unknown - completion state cannot be checked from a subprocess."
        echo "  Run 'source clam config' to check status in your current shell."
        return
    elif is_subshell; then
        echo "  STATUS: Unknown. Run 'source clam config' to check status."
        return
    elif is_enabled; then
        echo -e "  STATUS: \033[32;5mEnabled\033[0m"
    else
        echo -e "  STATUS: \033[31;5mDisabled\033[0m - Run 'source clam config' to verify."
    fi

    if [ ! -f "$config_file" ]; then
        echo_error "Configuration file not found: $config_file. Run clam install."
        return
    fi

    load_config
    local term_width=$(tput cols)
    local small_table=0
    [[ $term_width -gt 70 ]] && term_width=70 && small_table=0
    [[ $term_width -lt 40 ]] && term_width=70 && small_table=1

    for config_var in $(compgen -v | grep CLAM_); do
        if [[ $config_var == "CLAM_INPUT" || $config_var == "CLAM_PROMPT" || $config_var == "CLAM_RESPONSE" ]]; then
            continue
        fi
        local config_value="${!config_var}"
        if [[ ${config_var: -8} == "_API_KEY" ]]; then
            continue
        fi
        echo -en "  $config_var:\e[90m"
        if [[ $small_table -eq 1 ]]; then
            echo -e "\n  $config_value\e[0m"
        else
            printf '%s%*s' "" $((term_width - ${#config_var} - ${#config_value} - 3)) ''
            echo -e "$config_value\e[0m"
        fi
    done

    echo -e "  ===================================================================="

    for config_var in $(compgen -v | grep CLAM_); do
        if [[ $config_var == "CLAM_INPUT" || $config_var == "CLAM_PROMPT" || $config_var == "CLAM_RESPONSE" ]]; then
            continue
        fi
        if [[ ${config_var: -8} != "_API_KEY" ]]; then
            continue
        fi
        echo -en "  $config_var:\e[90m"
        local config_value
        if [[ -z ${!config_var} ]]; then
            config_value="UNSET"
            echo -en "\e[31m"
        else
            local key_suffix=${!config_var:4}
            config_value="${!config_var:0:4}...${key_suffix: -4}"
            echo -en "\e[32m"
        fi
        if [[ $small_table -eq 1 ]]; then
            echo -e "\n  $config_value\e[0m"
        else
            printf '%s%*s' "" $((term_width - ${#config_var} - ${#config_value} - 3)) ''
            echo -e "$config_value\e[0m"
        fi
    done
}

cmd_config() {
    local subcommand="${*:2}"

    if [ -z "$subcommand" ]; then
        cmd_show_config
        return
    fi

    if [ "$2" == "set" ]; then
        local key="$3"
        local value="$4"
        echo "Setting configuration key '$key' to '$value'"
        set_config_value "$key" "$value"
        echo_green "Configuration updated. Run 'clam config' to view changes."
        return
    fi

    if [[ "$subcommand" == "reset" ]]; then
        echo "Resetting configuration to default values."
        rm "$HOME/.clam/config" || true
        create_default_config
        return
    fi

    echo_error "SyntaxError: expected 'clam config set <key> <value>' or 'clam config reset'"
}

cmd_install() {
    local bashrc_file="$HOME/.bashrc"
    local clam_setup="source clam enable"
    local clam_cli_setup="complete -F clam_cli_completion clam"

    if ! command -v clam &>/dev/null; then
        echo_error "clam.sh not in PATH. Follow install instructions at https://github.com/yashpincha/ichack-26/tree/main"
        return
    fi

    if [[ ! -d "$HOME/.clam" ]]; then
        echo "Creating ~/.clam directory"
        mkdir -p "$HOME/.clam"
    fi

    local cache_dir=${CLAM_CACHE_DIR:-"$HOME/.clam/cache"}
    [[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"

    create_default_config
    load_config

    if ! grep -qF "$clam_setup" "$bashrc_file"; then
        echo -e "# Clam.sh" >> "$bashrc_file"
        echo -e "$clam_setup\n" >> "$bashrc_file"
        echo "Added clam.sh setup to $bashrc_file"
    else
        echo "Clam.sh setup already exists in $bashrc_file"
    fi

    if ! grep -qF "$clam_cli_setup" "$bashrc_file"; then
        echo -e "# Clam.sh CLI" >> "$bashrc_file"
        echo -e "$clam_cli_setup\n" >> "$bashrc_file"
        echo "Added clam CLI completion to $bashrc_file"
    fi

    echo
    echo_green "Clam.sh - Version $CLAM_VERSION installation complete."
    echo -e "Run: source $bashrc_file to enable clam."
    echo -e "Then run: clam model to select a language model."
}

cmd_remove() {
    local config_file="$HOME/.clam/config"
    local cache_dir=${CLAM_CACHE_DIR:-"$HOME/.clam/cache"}
    local log_file=${CLAM_LOG_FILE:-"$HOME/.clam/clam.log"}
    local bashrc_file="$HOME/.bashrc"

    echo_green "Removing Clam.sh installation..."

    [ -f "$config_file" ] && { rm "$config_file"; echo "Removed: $config_file"; }
    [ -d "$cache_dir" ] && { rm -rf "$cache_dir"; echo "Removed: $cache_dir"; }
    [ -f "$log_file" ] && { rm "$log_file"; echo "Removed: $log_file"; }

    if [ -d "$HOME/.clam" ]; then
        if [ -z "$(ls -A "$HOME/.clam")" ]; then
            rmdir "$HOME/.clam"
            echo "Removed: $HOME/.clam"
        else
            echo "Skipped removing $HOME/.clam (not empty)"
        fi
    fi

    if [ -f "$bashrc_file" ]; then
        if grep -qF "source clam enable" "$bashrc_file"; then
            sed -i '/# Clam.sh/d' "$bashrc_file"
            sed -i '/clam/d' "$bashrc_file"
            echo "Removed clam.sh setup from $bashrc_file"
        fi
    fi

    local clam_script=$(command -v clam)
    if [ -n "$clam_script" ]; then
        echo "Clam script is at: $clam_script"
        if [ "$1" == "-y" ]; then
            rm "$clam_script"
            echo "Removed: $clam_script"
        else
            read -r -p "Remove the clam script? (y/n): " confirm
            if [[ $confirm == "y" ]]; then
                rm "$clam_script"
                echo "Removed: $clam_script"
            fi
        fi
    fi

    echo "Uninstallation complete."
}

clam_cli_completion() {
    local current_cmd=""
    local current_word=""

    if [[ -n "${COMP_WORDS[*]}" ]]; then
        current_cmd="${COMP_WORDS[0]}"
        if [[ -n "$COMP_CWORD" && "$COMP_CWORD" -lt "${#COMP_WORDS[@]}" ]]; then
            current_word="${COMP_WORDS[COMP_CWORD]}"
        fi
    fi

    case "$current_word" in
        config)
            readarray -t COMPREPLY <<< "set
reset"
            return
            ;;
        command)
            readarray -t COMPREPLY <<< "command --dry-run"
            return
            ;;
        safeguard)
            readarray -t COMPREPLY <<< "enable
disable
status"
            return
            ;;
    esac

    if [[ -z "$current_word" ]]; then
        readarray -t COMPREPLY <<< "demo
install
remove
config
enable
disable
safeguard
clear
usage
system
command
fep
model
--help"
    fi
}

cmd_enable() {
    is_enabled && cmd_disable
    load_config
    complete -D -E -F clam_completion -o nospace
    bind -x '"\C-@": interactive_clam_widget'

    if [[ "$PROMPT_COMMAND" != *"capture_command_result"* ]]; then
        if [[ -n "$PROMPT_COMMAND" ]]; then
            PROMPT_COMMAND="capture_command_result; $PROMPT_COMMAND"
        else
            PROMPT_COMMAND="capture_command_result"
        fi
        export PROMPT_COMMAND
    fi

    fep() { clam fep "$@"; }
    export -f fep

    enable_safeguards

    show_clam_banner
    echo -e "  \e[1;32mCommand Line Assistance Module\e[0m - v$CLAM_VERSION"
    echo
    echo -e "  \e[32m✓\e[0m Interactive clam enabled!"
    echo -e "  \e[90m• Press \e[0mCtrl+Space\e[90m for AI suggestions\e[0m"
    echo -e "  \e[90m• Add \e[0m--explain\e[90m to see explanations\e[0m"
    echo -e "  \e[90m• Safeguards active for dangerous commands\e[0m"
    echo
}

cmd_disable() {
    is_enabled && complete -F _completion_loader -D

    if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="${PROMPT_COMMAND//capture_command_result/}"
        PROMPT_COMMAND="${PROMPT_COMMAND//;;/;}"
        PROMPT_COMMAND="${PROMPT_COMMAND#;}"
        PROMPT_COMMAND="${PROMPT_COMMAND%;}"
        export PROMPT_COMMAND
    fi

    unset -f fep 2>/dev/null
    disable_safeguards
}

cmd_command() {
    local args=("$@")

    for idx in "${!args[@]}"; do
        if [ "${args[idx]}" == "--dry-run" ]; then
            args[idx]=""
            build_prompt "${args[@]}"
            return
        fi
    done

    get_completion "$@" || true
    echo
}

cmd_clear() {
    local cache_dir=${CLAM_CACHE_DIR:-"$HOME/.clam/cache"}
    local harm_cache_dir=${CLAM_HARM_CACHE_DIR:-"$HOME/.clam/harm_cache"}
    local log_file=${CLAM_LOG_FILE:-"$HOME/.clam/clam.log"}

    echo "This will clear the cache, harm detection cache, and log file."
    echo -e "Completion cache: \e[31m$cache_dir\e[0m"
    echo -e "Harm cache: \e[31m$harm_cache_dir\e[0m"
    echo -e "Log file: \e[31m$log_file\e[0m"
    read -r -p "Are you sure? (y/n): " confirm

    if [[ $confirm != "y" ]]; then
        echo "Aborted."
        return
    fi

    if [ -d "$cache_dir" ]; then
        local cache_files=$(list_cache)
        if [ -n "$cache_files" ]; then
            while read -r line; do
                local file=$(echo "$line" | cut -d ' ' -f 2-)
                rm "$file"
                echo "Removed: $file"
            done <<< "$cache_files"
            echo "Cleared cache in: $cache_dir"
        else
            echo "Cache is empty."
        fi
    fi

    if [ -d "$harm_cache_dir" ]; then
        local harm_cache_count=$(find "$harm_cache_dir" -name "harm-*.json" 2>/dev/null | wc -l)
        if [ "$harm_cache_count" -gt 0 ]; then
            rm "$harm_cache_dir"/harm-*.json 2>/dev/null
            echo "Cleared $harm_cache_count harm detection cache entries from: $harm_cache_dir"
        else
            echo "Harm detection cache is empty."
        fi
    fi

    [ -f "$log_file" ] && { rm "$log_file"; echo "Removed: $log_file"; }
}

cmd_safeguard() {
    local action="$1"
    local config_file="$HOME/.clam/config"

    case "$action" in
        enable)
            if [ -f "$config_file" ]; then
                if ! grep -q "^harm_detection_enabled:" "$config_file"; then
                    echo "" >> "$config_file"
                    echo "# Harm detection settings" >> "$config_file"
                    echo "harm_detection_enabled: true" >> "$config_file"
                else
                    sed -i 's/^harm_detection_enabled:.*/harm_detection_enabled: true/' "$config_file"
                fi
                echo_green "Safeguards enabled!"
                echo -e "\e[90mHarmful commands will now require confirmation before execution.\e[0m"
                echo -e "\e[90mChanges take effect immediately.\e[0m"
            else
                echo_error "Configuration file not found: $config_file"
            fi
            ;;
        disable)
            if [ -f "$config_file" ]; then
                if ! grep -q "^harm_detection_enabled:" "$config_file"; then
                    echo "" >> "$config_file"
                    echo "# Harm detection settings" >> "$config_file"
                    echo "harm_detection_enabled: false" >> "$config_file"
                else
                    sed -i 's/^harm_detection_enabled:.*/harm_detection_enabled: false/' "$config_file"
                fi
                echo_green "Safeguards disabled!"
                echo -e "\e[90mCommands will execute without harm detection checks.\e[0m"
                echo -e "\e[90mChanges take effect immediately.\e[0m"
            else
                echo_error "Configuration file not found: $config_file"
            fi
            ;;
        status)
            local status="true"
            if [ -f "$config_file" ]; then
                status=$(grep "^harm_detection_enabled:" "$config_file" | awk '{print $2}' | tr -d ' ')
                [[ -z "$status" ]] && status="true"
            fi
            if [ "$status" = "true" ]; then
                echo -e "Safeguards: \e[1;32menabled\e[0m"
            else
                echo -e "Safeguards: \e[1;31mdisabled\e[0m"
            fi
            ;;
        *)
            echo "Usage: clam safeguard <enable|disable|status>"
            echo "  enable  - Enable harmful command detection"
            echo "  disable - Disable harmful command detection"
            echo "  status  - Show current safeguard status"
            ;;
    esac
}

cmd_usage() {
    local log_file=${CLAM_LOG_FILE:-"$HOME/.clam/clam.log"}
    local cache_dir=${CLAM_CACHE_DIR:-"$HOME/.clam/cache"}
    local cache_count=$(list_cache | wc -l)

    echo_green "Clam.sh - Usage Information"
    echo
    echo -n "Log file: "; echo -e "\e[90m$log_file\e[0m"

    local line_count api_cost avg_cost
    if [ ! -f "$log_file" ]; then
        line_count=0
        api_cost=0
        avg_cost=0
    else
        line_count=$(wc -l < "$log_file")
        api_cost=$(awk -F, '{sum += $5} END {print sum}' "$log_file")
        avg_cost=$(echo "$api_cost / $line_count" | bc -l)
    fi

    echo
    echo -e "\tUsage count:\t\e[32m$line_count\e[0m"
    echo -e "\tAvg Cost:\t\$$(printf "%.4f" "$avg_cost")"
    echo -e "\tTotal Cost:\t\e[31m\$$(printf "%.4f" "$api_cost")\e[0m"
    echo
    echo -n "Cache Size: $cache_count of ${CLAM_CACHE_SIZE:-10} in "; echo -e "\e[90m$cache_dir\e[0m"
    echo "To clear log and cache, run: clam clear"
}

cmd_model() {
    clear
    local selected_model
    local options=()

    if [[ $# -ne 3 ]]; then
        mapfile -t sorted_keys < <(for key in "${!CLAM_MODELS[@]}"; do echo "$key"; done | sort)
        for key in "${sorted_keys[@]}"; do
            options+=("$key")
        done

        echo -e "\e[1;32mClam.sh - Model Configuration\e[0m"
        show_model_selector "${options[@]}"
        local selected_idx=$?

        if [[ $selected_idx -eq 1 ]]; then
            return
        fi

        selected_model="${options[selected_idx]}"
        local selected_value="${CLAM_MODELS[$selected_model]}"
    else
        local provider="$2"
        local model_name="$3"
        local selected_value="${CLAM_MODELS["$provider:	$model_name"]}"

        if [[ -z "$selected_value" ]]; then
            echo "ERROR: Invalid provider or model name."
            return 1
        fi
    fi

    set_config_value "model" "$(echo "$selected_value" | jq -r '.model')"
    set_config_value "endpoint" "$(echo "$selected_value" | jq -r '.endpoint')"
    set_config_value "provider" "$(echo "$selected_value" | jq -r '.provider')"

    local prompt_cost=$(echo "$selected_value" | jq -r '.prompt_cost' | awk '{printf "%.8f", $1}')
    local completion_cost=$(echo "$selected_value" | jq -r '.completion_cost' | awk '{printf "%.8f", $1}')
    set_config_value "api_prompt_cost" "$prompt_cost"
    set_config_value "api_completion_cost" "$completion_cost"

    load_config

    if [[ -z "$CLAM_ACTIVE_API_KEY" && ${CLAM_PROVIDER^^} != "OLLAMA" ]]; then
        echo -e "\e[34mSet ${CLAM_PROVIDER^^}_API_KEY\e[0m"
        echo "Stored in ~/.clam/config"

        case "${CLAM_PROVIDER^^}" in
            OPENAI) echo "Create a new one: https://platform.openai.com/settings/profile?tab=api-keys" ;;
            ANTHROPIC) echo "Create a new one: https://console.anthropic.com/settings/keys" ;;
            GROQ) echo "Create a new one: https://console.groq.com/keys" ;;
        esac

        echo -n "Enter your ${CLAM_PROVIDER^^} API Key: "
        read -sr user_api_key < /dev/tty
        clear

        echo -e "\e[1;32mClam.sh - Model Configuration\e[0m"
        if [[ -n "$user_api_key" ]]; then
            export CLAM_ACTIVE_API_KEY="$user_api_key"
            set_config_value "${CLAM_PROVIDER,,}_api_key" "$user_api_key"
        fi
    fi

    local model="${CLAM_MODEL:-ERROR}"
    local temperature=$(echo "${CLAM_TEMPERATURE:-0.0}" | awk '{printf "%.3f", $1}')

    echo -e "Provider:\t\e[90m$CLAM_PROVIDER\e[0m"
    echo -e "Model:\t\t\e[90m$model\e[0m"
    echo -e "Temperature:\t\e[90m$temperature\e[0m"
    echo
    echo -e "Cost/token:\t\e[90mprompt: \$$CLAM_API_PROMPT_COST, completion: \$$CLAM_API_COMPLETION_COST\e[0m"
    echo -e "Endpoint:\t\e[90m$CLAM_ENDPOINT\e[0m"
    echo -n "API Key:"

    if [[ -z $CLAM_ACTIVE_API_KEY ]]; then
        if [[ ${CLAM_PROVIDER^^} == "OLLAMA" ]]; then
            echo -e "\t\e[90mNot Used\e[0m"
        else
            echo -e "\t\e[31mUNSET\e[0m"
        fi
    else
        local key_suffix=${CLAM_ACTIVE_API_KEY:4}
        local masked_key="${CLAM_ACTIVE_API_KEY:0:4}...${key_suffix: -4}"
        echo -e "\t\e[32m$masked_key\e[0m"
    fi

    if [[ -z $CLAM_ACTIVE_API_KEY && ${CLAM_PROVIDER^^} != "OLLAMA" ]]; then
        echo "To set the API Key, run:"
        echo -e "\t\e[31mclam config set api_key <your-api-key>\e[0m"
        echo -e "\t\e[31mexport ${CLAM_PROVIDER^^}_API_KEY=<your-api-key>\e[0m"
    fi

    if [[ ${CLAM_PROVIDER^^} == "OLLAMA" ]]; then
        echo "To set a custom endpoint:"
        echo -e "\t\e[34mclam config set endpoint <your-url>\e[0m"
        echo "Other models can be set with:"
        echo -e "\t\e[34mclam config set model <model-name>\e[0m"
    fi

    echo "To change temperature:"
    echo -e "\t\e[90mclam config set temperature <temperature>\e[0m"
    echo
}

cmd_fep() {
    load_config
    local user_context="${*:2}"

    echo
    start_spinner "Analyzing error and generating fix..."
    local response=$(get_fep_completion "$user_context")
    stop_spinner

    if [[ -z "$response" ]]; then
        echo_error "Failed to get response from API. Check config and API key (clam config)."
        return 1
    fi

    local content
    if [[ "${CLAM_PROVIDER^^}" == "ANTHROPIC" ]]; then
        content=$(echo "$response" | jq -r '.content[0].text // empty')
    elif [[ "${CLAM_PROVIDER^^}" == "OLLAMA" ]]; then
        content=$(echo "$response" | jq -r '.message.content // empty')
    else
        content=$(echo "$response" | jq -r '.choices[0].message.content // empty')
    fi

    if [[ -z "$content" ]]; then
        echo_error "Empty response from model"
        return 1
    fi

    local recommended_cmd=$(echo "$content" | jq -r '.recommended_command // empty')
    local explanation=$(echo "$content" | jq -r '.explanation // empty')

    if [[ -z "$recommended_cmd" ]]; then
        echo_error "Could not parse recommendation from response"
        echo "Raw response: $content"
        return 1
    fi

    echo -e "\e[32m━━━ Recommended Command ━━━\e[0m"
    echo -e "\e[1m$recommended_cmd\e[0m"
    echo
    echo -e "\e[32m━━━ Explanation ━━━\e[0m"
    echo "$explanation"
    echo
    echo -e "\e[33mRun this command? [Y/n]\e[0m"
    read -r -n 1 confirm
    echo

    if [[ "$confirm" =~ ^[Yy]$ ]] || [[ -z "$confirm" ]]; then
        echo -e "\e[90mExecuting: $recommended_cmd\e[0m"
        eval "$recommended_cmd"
    else
        echo "Cancelled."
    fi
}

run_with_capture() {
    local cmd="$*"
    export CLAM_LAST_COMMAND="$cmd"
    eval "$cmd" 2>&1 | tee "$CLAM_LAST_OUTPUT_FILE"
    export CLAM_LAST_EXIT_CODE="${PIPESTATUS[0]}"
}

cmd_demo() {
    clear
    show_clam_banner
    echo -e "  \e[1;32mCommand Line Assistance Module\e[0m - v$CLAM_VERSION"
    echo
    echo -e "  \e[90mLLM-powered bash completion & safety for everyone\e[0m"
    echo
    echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo
    echo -e "  \e[1;36m🚀 FEATURE 1: AI-Powered Autocompletion\e[0m"
    echo -e "     Type a command with a \e[1m# comment\e[0m describing what you want,"
    echo -e "     then press \e[1;32mCtrl+Space\e[0m for intelligent suggestions."
    echo
    echo -e "     \e[90mExample:\e[0m \e[1mls # show hidden files sorted by size\e[0m"
    echo -e "     \e[90mExample:\e[0m \e[1mfind # all .py files modified today\e[0m"
    echo -e "     \e[90mExample:\e[0m \e[1mgit # undo my last commit\e[0m"
    echo
    echo -e "  \e[1;36m🛡️  FEATURE 2: Safety Safeguards\e[0m"
    echo -e "     Dangerous commands are detected and require confirmation."
    echo
    echo -e "     \e[90mTry:\e[0m \e[1;31mrm -rf /\e[0m \e[90m(don't worry, we'll stop you!)\e[0m"
    echo
    echo -e "  \e[1;36m🔧 FEATURE 3: Fix Error Please (FEP)\e[0m"
    echo -e "     Made a typo? Run \e[1mclam fep\e[0m to get AI-suggested fixes."
    echo
    echo -e "     \e[90mExample:\e[0m Run \e[1mgit stauts\e[0m then \e[1mclam fep\e[0m"
    echo
    echo -e "\e[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
    echo
    echo -e "  \e[90mSupports: OpenAI, Anthropic, Groq, and local Ollama models\e[0m"
    echo -e "  \e[90mRun \e[0mclam model\e[90m to configure your preferred LLM\e[0m"
    echo
}

# === Entry Point ===

case "$1" in
    "--help") show_help ;;
    system) show_system_info ;;
    install) cmd_install ;;
    remove) cmd_remove "$@" ;;
    clear) cmd_clear ;;
    safeguard) cmd_safeguard "$2" ;;
    usage) cmd_usage ;;
    model) cmd_model "$@" ;;
    config) cmd_config "$@" ;;
    enable) cmd_enable ;;
    disable) cmd_disable ;;
    command) cmd_command "$@" ;;
    fep) cmd_fep "$@" ;;
    demo) cmd_demo ;;
    *)
        if [[ -n "$1" ]]; then
            echo_error "Unknown command $1 - run 'clam --help' for usage or visit https://clam.sh"
        else
            echo_green "Clam.sh - LLM Powered Bash Completion - Version $CLAM_VERSION - https://clam.sh"
        fi
        ;;
esac
