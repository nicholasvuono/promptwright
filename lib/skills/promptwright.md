---
name: Markdown Test Runner
description: Run markdown tests cases using the playwright-cli tool.
---

# Running Markdown Test Files Using playwright-cli

## Available Skills to Read
Please reference the `lib/skills/playwright-cli.md` skill for playwright-cli related tasks. Prefer this to using `playwright-cli --help` always.

## Quick Start

There is a markdown file that contains a test case. The goal is to read:

1. Read the test case and check whether it already has a `## Cached` section
2. If `## Cached` exists, execute those cached playwright-cli commands first
3. If `## Cached` does not exist, define the playwright-cli commands needed to execute the test case
4. Provide a summary of the test run

Simple example markdown test file:
```markdown
## Test Case
1. Navigate to https://demo.playwright.dev/todomvc/
2. Create a 'grocery shopping' todo
3. Validate a 'grocery shopping' todo was created successfully
```

Simple example playwright-cli commands that may be used to run the test cases:
```bash
playwright-cli open https://demo.playwright.dev/todomvc/
playwright-cli fill "css=input.new-todo" "grocery shopping" --submit
playwright-cli eval "[...document.querySelectorAll('[data-testid="todo-title"]')].some(e => e.innerText.includes('grocery shopping'))"
playwright-cli close
```

Simple example summary fo the test run
```
Test Run Summary: PASSED
- ✅ open https://demo.playwright.dev/todomvc/
- ✅ fill "css=input.new-todo" "grocery shopping" --submit
- ✅ eval ... 
- ✅ close
```

## Caching Test Steps for Future Runs

After a markdown test case is run and passed successfully, cache the playwright-cli test commands in the markdown file only when the cache is missing or needs to change.

The command should be appended to the end of the file. Use -s={filename} in the command to ensure unique sessions per test

Simple example markdown test file with caching:
```markdown
## Test Case
1. Navigate to https://demo.playwright.dev/todomvc/
2. Create a 'grocery shopping' todo
3. Validate a 'grocery shopping' todo was created successfully

## Cached
playwright-cli -s=todo open https://demo.playwright.dev/todomvc/
playwright-cli -s=todo fill "css=input.new-todo" "grocery shopping" --submit
playwright-cli -s=todo eval "[...document.querySelectorAll('[data-testid="todo-title"]')].some(e => e.innerText.includes('grocery shopping'))"
playwright-cli -s=todo close

```

Caching Rules:

1. Always read the markdown test file before running commands.
2. If `## Cached` exists, run the cached commands exactly as written before deriving any new commands.
3. If all cached commands pass and still represent the test case, do not update the file.
4. If `## Cached` does not exist, append it after a successful run with the commands that were actually executed.
5. If a cached command fails, attempt to "heal" it by finding and defining a successful replacement command.
6. When "healing" tests ensure a high integrity standard and do not just add a command that evaluates to true to get the test to pass.
7. Update the `## Cached` section only when at least one command was healed, missing, or wildly different from the commands that needed to be run successfully.
8. Do not rewrite cached commands for minor formatting differences, equivalent selectors, equivalent quoting, or because the commands were already successful.
9. Ensure any cache update contains only successful playwright-cli commands that were actually needed for the test run.

## General Rules to Follow

1. Always prefer `playwright-cli` commands.
2. Only use `playwright-cli --raw run-code` if absolutely necessary. Use `--raw run-code` as a last resort for complex logic.
3. Use concise, simple, and succint page.eval commands for validations. Avoid complex logic.
4. Assume you will not snapshots to reference. Prefer Playwright locators (getByTestId, getByRole, etc) and css selectors over snapshot references.
5. Always close the browser at test end.
6. Use following format for end of test run summary:
```
Test Run Summary: PASSED
- ✅ open https://demo.playwright.dev/todomvc/
- ✅ fill "css=input.new-todo" "grocery shopping" --submit
- ✅ eval ... 
- ✅ close
```
