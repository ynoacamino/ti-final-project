# Plugins Reference

Plugins extend Reveal.js with additional functionality. Register them via the `plugins` prop on `<Deck>`.

```tsx
import { Deck, Slide } from '@revealjs/react';
import RevealHighlight from 'reveal.js/plugin/highlight';
import RevealNotes from 'reveal.js/plugin/notes';
import RevealMath from 'reveal.js/plugin/math';
import RevealZoom from 'reveal.js/plugin/zoom';
import RevealSearch from 'reveal.js/plugin/search';

<Deck plugins={[RevealHighlight, RevealNotes, RevealMath, RevealZoom, RevealSearch]}>
  <Slide>Content</Slide>
</Deck>
```

**Important**: Plugins are initialization-only. The `plugins` prop is captured on first mount and ignored on subsequent renders.

---

## RevealHighlight

Syntax highlighting for code blocks. Works with both the `<Code>` component and raw `<pre><code>` blocks.

```tsx
import RevealHighlight from 'reveal.js/plugin/highlight';
import 'reveal.js/plugin/highlight/monokai.css';

<Deck plugins={[RevealHighlight]}>
  <Slide>
    <Code language="typescript" lineNumbers>
      {`const x: number = 42;
console.log(x);`}
    </Code>
  </Slide>
</Deck>
```

### Line Highlighting

```tsx
// Static highlighting
<Code language="js" highlightLines="1,3-5">
  {codeString}
</Code>

// Click-based highlighting (step through lines)
<Code language="js" dataLineNumbers="1|3-5|all">
  {codeString}
</Code>
```

### Available Themes

```tsx
import 'reveal.js/plugin/highlight/monokai.css';
// Or use any highlight.js theme
```

---

## RevealNotes

Speaker notes in a separate window. Press `S` to open.

```tsx
import RevealNotes from 'reveal.js/plugin/notes';

<Deck plugins={[RevealNotes]}>
  <Slide notes="These are speaker notes visible only to the presenter.">
    <h1>Slide Content</h1>
  </Slide>
</Deck>
```

### Notes via Markdown

```tsx
<Markdown>
  {`
    ## Slide Title
    Content here

    Notes:
    These notes are only visible in speaker view.
  `}
</Markdown>
```

### Notes via Slide Prop

```tsx
<Slide notes="Point 1: Explain the concept. Point 2: Show demo.">
  <h1>Content</h1>
</Slide>
```

---

## RevealMath

Render mathematical equations using KaTeX or MathJax.

```tsx
import RevealMath from 'reveal.js/plugin/math/math';

<Deck plugins={[RevealMath]}>
  <Slide>
    <h2>Euler's Identity</h2>
    <p>\( e^{i\pi} + 1 = 0 \)</p>
    <p>\[ \int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi} \]</p>
  </Slide>
</Deck>
```

### KaTeX (faster rendering)

```tsx
import RevealMath from 'reveal.js/plugin/math/katex';
import 'reveal.js/plugin/math/katex.css';
```

### MathJax (broader LaTeX support)

```tsx
import RevealMath from 'reveal.js/plugin/math/math';
```

### Math Syntax

| Syntax | Rendering |
|--------|-----------|
| `\( inline \)` | Inline math |
| `\[ block \]` | Block math (centered) |
| `$inline$` | Inline (if configured) |
| `$$block$$` | Block (if configured) |

---

## RevealZoom

Alt+click to zoom into any element. Click again to zoom out.

```tsx
import RevealZoom from 'reveal.js/plugin/zoom';

<Deck plugins={[RevealZoom]}>
  <Slide>
    <img src="diagram.png" alt="Click to zoom" />
  </Slide>
</Deck>
```

---

## RevealSearch

Full-text search across all slides. Press `Ctrl+Shift+F`.

```tsx
import RevealSearch from 'reveal.js/plugin/search';

<Deck plugins={[RevealSearch]}>
  <Slide>Content to search</Slide>
</Deck>
```

---

## Combining Plugins

```tsx
import { Deck, Slide, Code } from '@revealjs/react';
import RevealHighlight from 'reveal.js/plugin/highlight';
import RevealNotes from 'reveal.js/plugin/notes';
import RevealMath from 'reveal.js/plugin/math/katex';
import RevealZoom from 'reveal.js/plugin/zoom';
import RevealSearch from 'reveal.js/plugin/search';

import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';
import 'reveal.js/plugin/highlight/monokai.css';
import 'reveal.js/plugin/math/katex.css';

export default function FullDeck() {
  return (
    <Deck
      config={{ hash: true, controls: true, progress: true }}
      plugins={[RevealHighlight, RevealNotes, RevealMath, RevealZoom, RevealSearch]}
    >
      <Slide notes="Welcome slide">
        <h1>My Talk</h1>
      </Slide>
      <Slide>
        <Code language="python">{`print("Hello!")`}</Code>
      </Slide>
      <Slide>
        <p>\( E = mc^2 \)</p>
      </Slide>
    </Deck>
  );
}
```

---

## Plugin API

Access registered plugins via the Reveal instance:

```tsx
function PluginInfo() {
  const deck = useReveal();

  useEffect(() => {
    if (deck) {
      deck.hasPlugin('highlight'); // true
      deck.getPlugin('highlight'); // { id: 'highlight', init: ... }
      deck.getPlugins();           // { highlight: ..., notes: ..., ... }
    }
  }, [deck]);
}
```

---

## Custom Plugins

Create custom plugins following Reveal's plugin interface:

```tsx
const MyPlugin = {
  id: 'my-plugin',
  init: (deck) => {
    // deck is the Reveal API instance
    deck.on('slidechanged', (event) => {
      console.log('Custom plugin: slide changed', event);
    });
    return new Promise((resolve) => resolve());
  },
};

<Deck plugins={[MyPlugin]}>
```

---

## Third-Party Plugins

Community plugins available at the [Reveal.js wiki](https://github.com/hakimel/reveal.js/wiki/Plugins,-Tools-and-Hardware).

Common third-party plugins:
- `reveal.js-menu` - Slide menu/navigation
- `reveal.js-chalkboard` - Drawing/chalkboard
- `reveal.js-elapsed-time-bar` - Time progress bar
