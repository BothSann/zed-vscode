# Glossary

**Boss editor**: The editor whose settings are the truth. When the two editors disagree, the boss is right and the other one gets changed to match. Right now it's Zed.

**Shared setting**: A setting that must have the same value in both editors (font, size, theme, tab size, width, and so on). Settings that only one editor has aren't shared.

**Drift**: When a shared setting has different values in the two editors. Drift is always a bug.

**Fallback style**: The formatting rules used for a file whose project has no rules of its own. A project's own rules always win over the fallback style.

**Standard width**: The longest a line may get before a formatter wraps it. Every formatter and every ruler uses the same number: 120.

**Standard indent**: How far each nesting level is pushed in: 2 spaces, or 4 for PHP. A project's own rules can override it.

**Save-reformat**: When saving a file changes how it looks even though you didn't change the code. Different tools or versions disagreeing causes it. So does a file that was never formatted in the first place. The goal is for it never to happen to a file the AI agent wrote.

**Theme family**: A light theme and a dark theme from the same authors, published officially for both editors. Which one shows follows the system's light/dark mode.
