---
name: Markdown Test Runner
description: Run markdown tests cases using the playwright-cli tool.
---

# Running Markdown Test Files Using playwright-cli

## Available Skills to Read
Please reference the `lib/skills/playwright-cli.md` skill for playwright-cli related tasks. Prefer this to using `playwright-cli --help` always.

## Quick Start

There is a markdown file that contains a test case. The goal is to read:

1. Read the test case to gather an understanding of the test steps
2. Define the playwright-cli commands needed to execute the test case
3. Execute the defined playwright-cli commands
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

After a markdown test case is run for the first time and passed successfully, cache the playwright-cli test commands in the markdown file.

The command should be appended to the end of the file.

Simple example markdown test file with caching:
```markdown
## Test Case
1. Navigate to https://demo.playwright.dev/todomvc/
2. Create a 'grocery shopping' todo
3. Validate a 'grocery shopping' todo was created successfully

## Cached
playwright-cli open https://demo.playwright.dev/todomvc/
playwright-cli fill "css=input.new-todo" "grocery shopping" --submit
playwright-cli eval "[...document.querySelectorAll('[data-testid="todo-title"]')].some(e => e.innerText.includes('grocery shopping'))"
playwright-cli close

```

Caching Rules:

1. If `## Cached` does not exist on a markdown test case file ensure to append it after execution.
2. If `## Cached` section exists within a markdown test case file always prefer to use them to execute the test case.
3. If a command fails, attempt to "heal" it by finding and defining a successful command.
4. When "healing" tests esure a high integrity standard and do not just add a command that evaluates to true to get the test to pass .
5. Ensure to replace any failed commands with the new successful commands in the `## Cached section` after the test run.

## General Rules to Follow

1. Always prefer to use `playwright-cli` commands for better caching and readability.
2. Only use `playwright-cli --raw run-code` if absolutely necessary. Use `--raw run-code` as a last resort for complex logic that can't be easily expressed with standard commands.
3. For validations make the page.eval as succint and simple as possible. Avoid complex logic in the eval and prefer to use playwright-cli's built-in assertions and checks when possible for better reliability and clearer error messages.
4. Assume you will not always have a snapshot reference when running these tests in the future, prefer Playwright locators (getByTestId, getByRole, etc) and css selectors over snapshot references for more robust and maintainable tests.
5. Always close the browser at the end of the test run to ensure a clean slate for the next run, even if errors occur.
6. Keep the test run summary concise and simple (reference the format in the given example above)