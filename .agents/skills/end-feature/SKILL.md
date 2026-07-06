---
name: Check if all the requirements are met when a feature is ended
description: Deploys context-free agents to strictly validate codebase standards, testing, version control, and documentation before marking a feature as complete.
---

**Execution Instructions:**

Deploy independent agents, isolated from the current session's context, to rigorously validate the project state against the following checklist:

- [ ] **Testing:** Were the test suites executed, and did they pass successfully in both the `mobile` and `backend` projects?
- [ ] **Version Control:** Have the current changes been securely committed, and were the branches managed strictly following Git Flow conventions?
- [ ] **Code Quality:** Are the LSP, linters, and formatters clear of any warnings or errors? Were they explicitly executed right before finalizing the code?
- [ ] **Project Rules:** Did the implementation strictly follow the architectural rules and guidelines specified in the `README.md` of each respective project (`backend` and `mobile`)?
- [ ] **Code Cleanup:** Has all dead, experimental, or garbage code that is no longer in use been completely removed from the working directories?
- [ ] **Documentation:** Is the code properly documented, and has the `README.md` been updated with everything another developer needs to know to continue development?
- [ ] **Final Verification:** Are you absolutely certain that you have complied with everything you were originally instructed to do?

**Validation Output Requirement:**
The agents must evaluate each item and return a strict `[PASS]` or `[FAIL]`. Any `[FAIL]` status must include a direct technical explanation of the deficit. Feature closure must be blocked until all checklist items are confirmed as `[PASS]`.
