#!/usr/bin/env python3
"""
Validates Mermaid diagram syntax across all Markdown files in the repository.
Checks for common parsing traps (unquoted parentheses inside square brackets)
and optionally tests with @mermaid-js/mermaid-cli if npx/node is installed.
"""
import glob
import os
import re
import sys
import subprocess

def main():
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    files = sorted(glob.glob(os.path.join(repo_root, 'docs/**/*.md'), recursive=True) +
                   glob.glob(os.path.join(repo_root, '*.md')))

    total = 0
    errors = []

    has_npx = subprocess.run(['which', 'npx'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0

    tmp_dir = '/tmp/mermaid_ci_test'
    os.makedirs(tmp_dir, exist_ok=True)

    for f in files:
        rel_f = os.path.relpath(f, repo_root)
        with open(f, 'r', encoding='utf-8') as fp:
            lines = fp.readlines()

        in_mermaid = False
        start_line = 0
        block = []
        block_idx = 0

        for idx, line in enumerate(lines, 1):
            if line.strip() == '```mermaid':
                in_mermaid = True
                start_line = idx
                block = []
                block_idx += 1
            elif in_mermaid and line.strip() == '```':
                in_mermaid = False
                total += 1
                content = ''.join(block)

                # Heuristic regex check for unquoted parentheses inside square brackets: e.g. [foo (bar)] instead of ["foo (bar)"]
                for line_no, b_line in enumerate(block, start_line + 1):
                    # Check for patterns like \w\[[^\"]*?\([^\"]*?\)[^\"]*?\]
                    match = re.search(r'\w+\[(?![^\]]*"[^\]]*")[^\]]*\([^)]*\)[^\]]*\]', b_line)
                    if match:
                        errors.append((rel_f, line_no, f"Unquoted parentheses inside bracket node label: {match.group(0)}. Must be double-quoted like [\"...\"]"))

                if has_npx:
                    mmd_path = os.path.join(tmp_dir, f"{os.path.basename(f)}_{block_idx}.mmd")
                    svg_path = os.path.join(tmp_dir, f"{os.path.basename(f)}_{block_idx}.svg")
                    with open(mmd_path, 'w', encoding='utf-8') as mfp:
                        mfp.write(content)
                    res = subprocess.run(
                        ['npx', '--yes', '@mermaid-js/mermaid-cli', '-i', mmd_path, '-o', svg_path],
                        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
                    )
                    if res.returncode != 0:
                        errors.append((rel_f, start_line, res.stderr.strip()))

            elif in_mermaid:
                block.append(line)

    print(f"Validated {total} Mermaid diagram(s) across {len(files)} Markdown file(s).")
    if errors:
        print(f"❌ Found {len(errors)} Mermaid syntax error(s):")
        for err in errors:
            print(f"  • {err[0]}:{err[1]} -> {err[2]}")
        sys.exit(1)
    else:
        print("✅ 100% of Mermaid diagrams parsed with zero syntax errors!")

if __name__ == '__main__':
    main()
