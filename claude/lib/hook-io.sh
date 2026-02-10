#!/usr/bin/env bash
#
# Shared I/O utilities for Claude Code hooks.
#
# Source this file in hooks that need to read JSON from stdin.

# Reads JSON from stdin incrementally, returning as soon as valid JSON is found.
# Claude keeps the pipe open during cancels/timeouts, so we can't wait for EOF.
#
# Outputs:
#   Complete JSON object to stdout, or "{}" if no valid JSON found.
read_hook_input() {
  local buffer="" char depth=0 in_string=false escape=false

  # Read character by character to detect complete JSON objects.
  while IFS= read -r -N 1 char; do
    buffer+="${char}"

    # Track JSON structure to know when we have a complete object.
    if [[ ${escape} == true ]]; then
      escape=false
    elif [[ ${char} == $'\\' && ${in_string} == true ]]; then
      escape=true
    elif [[ ${char} == '"' ]]; then
      in_string=$([[ ${in_string} == true ]] && echo false || echo true)
    elif [[ ${in_string} == false ]]; then
      case "${char}" in
      '{') ((++depth)) ;;
      '}')
        ((depth--))
        if ((depth == 0)); then
          echo "${buffer}"
          return 0
        fi
        ;;
      esac
    fi
  done

  # EOF reached; return whatever we have if it's valid JSON.
  if [[ -n ${buffer} ]] && echo "${buffer}" | jq -e . >/dev/null 2>&1; then
    echo "${buffer}"
    return 0
  fi
  echo "{}"
}

# Outputs a hook denial response with the given reason.
#
# Arguments:
#   $1 - The reason for denying the tool use.
deny_tool() {
  local reason="${1}"
  jq -cn --arg reason "${reason}" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
}
