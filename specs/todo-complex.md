## Test Case
1. Navigate to https://demo.playwright.dev/todomvc/
2. Create a 'grocery shopping' todo
3. Validate a 'grocery shopping' todo was created successfully
4. Create a 'wash dishes' todo
5. Validate a 'wash dishes' todo was created successfully
6. Create a 'laundry' todo
7. Validate a 'laundry' todo was created successfully
8. Mark all of three todo items as complete
8. Delete all three todo items

## Cached
playwright-cli open https://demo.playwright.dev/todomvc/
playwright-cli fill "css=input.new-todo" "grocery shopping" --submit
playwright-cli eval "[...document.querySelectorAll('.todo-list li label')].some(e => e.innerText.includes('grocery shopping'))"
playwright-cli fill "css=input.new-todo" "wash dishes" --submit
playwright-cli eval "[...document.querySelectorAll('.todo-list li label')].some(e => e.innerText.includes('wash dishes'))"
playwright-cli fill "css=input.new-todo" "laundry" --submit
playwright-cli eval "[...document.querySelectorAll('.todo-list li label')].some(e => e.innerText.includes('laundry'))"
playwright-cli eval "document.querySelectorAll('.todo-list li').length"
playwright-cli click "css=.todo-list li:nth-child(1) .toggle"
playwright-cli click "css=.todo-list li:nth-child(2) .toggle"
playwright-cli click "css=.todo-list li:nth-child(3) .toggle"
playwright-cli eval "[...document.querySelectorAll('.todo-list li.completed')].length"
playwright-cli eval "(() => { const btns = Array.from(document.querySelectorAll('.todo-list li .destroy')); btns.forEach(b => b.click()); return btns.length; })()"
playwright-cli eval "document.querySelectorAll('.todo-list li').length"
playwright-cli close
