## Test Case
1. Navigate to https://demo.playwright.dev/todomvc/
2. Create a 'grocery shopping' todo
3. Validate a 'grocery shopping' todo was created successfully

## Cached
playwright-cli -s=todo1 open https://demo.playwright.dev/todomvc/
playwright-cli -s=todo1 fill "css=input.new-todo" "grocery shopping" --submit
playwright-cli -s=todo1 eval "[...document.querySelectorAll('[data-testid="todo-title"]')].some(e => e.innerText.includes('grocery shopping'))"
playwright-cli -s=todo1 close
