#!/usr/bin/env python3
"""Memory context hook (SessionStart).

This hook demonstrates the PROJECT SCOPING pattern: automatically detecting
which project you're working in and injecting project-specific context.

The key pattern here is get_project_slug() — it derives a project identifier
from your current working directory, which you can use to scope memory,
context, or any project-specific behavior.

Customize PROJECT_MAP below with your own project directories.

Hook type: SessionStart
Configure in settings.json under hooks.SessionStart
"""

import os


# Customize this map with your own projects.
# Keys are substrings matched against the current working directory.
# Values are short slugs used for scoping (e.g., memory tags, log prefixes).
PROJECT_MAP = {
    "my-saas-app": "saas",
    "client-website": "client-site",
    "personal-blog": "blog",
    # Add your projects here:
    # "project-folder-name": "short-slug",
}


def get_project_slug():
    """Derive project slug from CWD for scoped context.

    This is the core pattern: match CWD against known projects,
    fall back to a sanitized directory name for unknown projects.
    """
    cwd = os.getcwd()
    for pattern, slug in PROJECT_MAP.items():
        if pattern in cwd:
            return slug
    # Fall back to sanitized basename
    base = os.path.basename(cwd).lower().replace(" ", "-")
    return base if base else "unknown"


def build_reminder():
    """Build a context reminder string for the session.

    Customize this to inject whatever context your workflow needs:
    - Memory system instructions
    - Project-specific rules
    - Active sprint context
    - Team conventions
    """
    slug = get_project_slug()
    tag = f"project-{slug}"
    return (
        f"=== PROJECT CONTEXT ===\n"
        f"Current project: {slug}\n"
        f"Scope tag: {tag}\n"
        f"Use this tag to scope any project-specific data or memory.\n"
        f"=== END PROJECT CONTEXT ==="
    )


def main():
    print(build_reminder())


if __name__ == "__main__":
    main()
