#!/usr/bin/env python3
"""Prompt classification hook (UserPromptSubmit).

This is a SKELETON showing the UserPromptSubmit hook pattern.
It reads the user's prompt from stdin, classifies it, and returns
additionalContext that Claude sees before responding.

Hook type: UserPromptSubmit
Input: JSON on stdin with the user's prompt
Output: JSON on stdout with optional additionalContext

Customize the classification logic for your own workflow.
"""

import json
import sys
import re


def classify_prompt(text):
    """Classify a user prompt as CONVERSATIONAL or TASK.

    Returns a classification string that gets injected as context.
    Customize these patterns for your workflow.
    """
    text_lower = text.lower().strip()

    # Conversational signals: questions about concepts, not actions
    conversational_patterns = [
        r"^(what|how|why|does|is|can|will|are|tell me|explain|show me)\b",
        r"^(who|where|when)\b",
    ]

    # Task signals: action words indicating implementation work
    task_patterns = [
        r"\b(build|create|fix|add|change|set up|write|implement)\b",
        r"\b(update|generate|deploy|run|modify|configure|make)\b",
        r"\b(improve|optimize|refactor|launch|push|send)\b",
    ]

    for pattern in conversational_patterns:
        if re.search(pattern, text_lower):
            return "CONVERSATIONAL"

    for pattern in task_patterns:
        if re.search(pattern, text_lower):
            return "TASK"

    return "AMBIGUOUS"


def main():
    """Read prompt from stdin, classify, return context."""
    try:
        input_data = json.load(sys.stdin)
    except (json.JSONDecodeError, EOFError):
        # If no valid input, exit silently
        json.dump({}, sys.stdout)
        return

    prompt = input_data.get("prompt", "")
    if not prompt:
        json.dump({}, sys.stdout)
        return

    classification = classify_prompt(prompt)

    # Return additionalContext that Claude will see
    result = {
        "additionalContext": f"PROMPT TYPE: {classification}"
    }

    json.dump(result, sys.stdout)


if __name__ == "__main__":
    main()
