---
name: revealjs-react
description: Create and edit interactive presentations using reveal.js with React via @revealjs/react. Use when building slide decks, technical talks, demos, workshops, or any visual presentation with TSX components. Supports Markdown slides, code highlighting, auto-animate, fragments, speaker notes, themes, plugins, and PDF export.
---

# Reveal.js + React (@revealjs/react)

Build interactive HTML presentations as React components using `@revealjs/react`.

## Quick Start

```bash
npm i @revealjs/react reveal.js react react-dom
```

```tsx
import { Deck, Slide } from '@revealjs/react';
import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';

export default function Presentation() {
  return (
    <Deck config={{ hash: true, transition: 'slide' }}>
      <Slide>
        <h1>Hello World</h1>
      </Slide>
    </Deck>
  );
}
```

## Core Components

| Component | Purpose | Reference |
|-----------|---------|-----------|
| `Deck` | Root wrapper, owns Reveal instance lifecycle | [components](references/components.md) |
| `Slide` | Individual slide (`<section>`) | [components](references/components.md) |
| `Stack` | Vertical slide group | [components](references/components.md) |
| `Fragment` | Incremental reveal of content | [components](references/components.md) |
| `Code` | Syntax-highlighted code block | [components](references/components.md) |
| `Markdown` | Markdown-based slides | [components](references/components.md) |
| `useReveal()` | Hook to access Reveal API | [events-api](references/events-api.md) |

## Feature Reference

| Feature | Description | Reference |
|---------|-------------|-----------|
| Setup | Installation, Vite/Webpack config | [setup](references/setup.md) |
| Configuration | All `Deck` config options | [config](references/config.md) |
| Plugins | Highlight, Notes, Math, Zoom, Search | [plugins](references/plugins.md) |
| Auto-Animate | Animate elements across slides | [auto-animate](references/auto-animate.md) |
| Backgrounds | Color, image, video, iframe backgrounds | [backgrounds](references/backgrounds.md) |
| Events & API | Lifecycle events, navigation, deckRef | [events-api](references/events-api.md) |
| Themes & Transitions | CSS themes, slide/background transitions | [themes-transitions](references/themes-transitions.md) |
| Templates | Pre-built slide templates | [templates](references/templates.md) |
| Reusable Components | Composable React slide components | [reusable-components](references/reusable-components.md) |

## Common Patterns

### Create from Scratch

```tsx
import { Deck, Slide, Fragment, Code, Stack } from '@revealjs/react';
import 'reveal.js/reveal.css';
import 'reveal.js/theme/white.css';
import RevealHighlight from 'reveal.js/plugin/highlight';
import 'reveal.js/plugin/highlight/monokai.css';

export default function MyTalk() {
  return (
    <Deck
      config={{ hash: true, controls: true, progress: true }}
      plugins={[RevealHighlight]}
    >
      <Slide background="#1a1a2e">
        <h1>My Talk</h1>
        <p>Subtitle here</p>
      </Slide>
      <Stack>
        <Slide>
          <h2>Point 1</h2>
          <Fragment animation="fade-up"><p>Detail A</p></Fragment>
          <Fragment animation="fade-up"><p>Detail B</p></Fragment>
        </Slide>
        <Slide><h2>Point 1 - Continued</h2></Slide>
      </Stack>
      <Slide>
        <Code language="typescript">{`const x = 42;`}</Code>
      </Slide>
    </Deck>
  );
}
```

### Edit Existing Deck

To modify an existing presentation:
1. Locate the main component file (usually `Presentation.tsx` or `App.tsx`)
2. Find the `<Deck>` wrapper and its `<Slide>` children
3. Add/modify slides, fragments, or config as needed
4. Changes to `config` are shallow-compared and applied automatically
5. Adding/removing slides triggers automatic `reveal.sync()`

### Using Markdown Slides

```tsx
import { Deck, Markdown } from '@revealjs/react';

<Deck>
  <Markdown separator="^\n---\n$" verticalSeparator="^\n--\n$">
    {`
      ## Slide 1
      - Item one <!-- .element: class="fragment" -->
      - Item two <!-- .element: class="fragment" -->
      --
      ## Vertical Slide
      ---
      <!-- .slide: data-background="#111827" -->
      ## Slide 2
    `}
  </Markdown>
</Deck>
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Space` / `→` / `↓` | Next slide/fragment |
| `←` / `↑` | Previous slide/fragment |
| `Esc` | Slide overview |
| `S` | Speaker view |
| `F` | Fullscreen |
| `B` / `.` | Pause (blackout) |
| `O` | Overview mode |

## Validation

After creating or editing a presentation:
- Run `npm run dev` and verify all slides render
- Test navigation (keyboard, touch, controls)
- Check speaker notes with `S` key
- Verify code highlighting if using `Code` component
- Test PDF export: add `?print-pdf` to URL
