# Components Reference

## Deck

Root wrapper that creates and manages the Reveal.js instance.

```tsx
import { Deck, Slide } from '@revealjs/react';

<Deck
  config={{ hash: true, transition: 'slide' }}
  plugins={[RevealHighlight]}
  onReady={(deck) => console.log('Ready')}
  onSlideChange={(e) => console.log(e.indexh, e.indexv)}
  deckRef={myRef}
>
  <Slide>Content</Slide>
</Deck>
```

### Deck Props

| Prop | Type | Description |
|------|------|-------------|
| `config` | `RevealOptions` | Reveal.js configuration (shallow-compared) |
| `plugins` | `Plugin[]` | Reveal plugins (initialization-only, captured on mount) |
| `deckRef` | `RefObject<RevealApi>` | External ref to access Reveal instance |
| `onReady` | `(deck: RevealApi) => void` | Fires after `reveal.initialize()` resolves |
| `onSync` | `() => void` | Fires when deck syncs after slide structure change |
| `onSlideChange` | `(event: SlideEvent) => void` | Fires on horizontal/vertical slide change |
| `onSlideChanged` | `(event: SlideEvent) => void` | Fires after slide change completes |
| `onFragmentShown` | `(event: FragmentEvent) => void` | Fires when a fragment is shown |
| `onFragmentHidden` | `(event: FragmentEvent) => void` | Fires when a fragment is hidden |
| `onAutoSlidePaused` | `() => void` | Fires when auto-sliding pauses |
| `onAutoSlideResumed` | `() => void` | Fires when auto-sliding resumes |
| `onResize` | `(event: ResizeEvent) => void` | Fires on resize |

### Deck Lifecycle

- Creates one Reveal instance on mount, destroys on unmount
- Safe under React `StrictMode` (no double initialization)
- `config` is shallow-compared; only calls `configure()` when values change
- `plugins` captured once on mount, ignored on subsequent renders
- Event props are wired with `deck.on()` and cleaned up with `deck.off()`

---

## Slide

Individual slide, renders a `<section>` element.

```tsx
<Slide
  background="#1a1a2e"
  backgroundImage="url(bg.jpg)"
  backgroundColor="rgb(0,0,0)"
  backgroundVideo="video.mp4"
  backgroundIframe="https://example.com"
  backgroundInteractive={true}
  backgroundSize="cover"
  backgroundPosition="center"
  backgroundRepeat="no-repeat"
  transition="fade"
  transitionSpeed="fast"
  autoAnimate={true}
  visibility="hidden"
  notes="Speaker notes here"
  autoSlide={5000}
  preload={true}
>
  <h1>Slide Content</h1>
</Slide>
```

### Slide Props

| Prop | Type | Description |
|------|------|-------------|
| `background` | `string` | CSS color for background |
| `backgroundImage` | `string` | Background image URL |
| `backgroundColor` | `string` | Background color |
| `backgroundVideo` | `string` | Background video URL(s) |
| `backgroundIframe` | `string` | Background iframe URL |
| `backgroundInteractive` | `boolean` | Allow iframe interaction |
| `backgroundSize` | `string` | CSS background-size |
| `backgroundPosition` | `string` | CSS background-position |
| `backgroundRepeat` | `string` | CSS background-repeat |
| `backgroundOpacity` | `number` | Background opacity (0-1) |
| `transition` | `string` | Per-slide transition override |
| `transitionSpeed` | `string` | Transition speed |
| `autoAnimate` | `boolean` | Enable auto-animate for this slide |
| `visibility` | `string` | Slide visibility (`"hidden"` or `"visible"`) |
| `notes` | `string` | Speaker notes text |
| `autoSlide` | `number` | Auto-advance after N ms |
| `preload` | `boolean` | Preload media |
| `id` | `string` | Slide ID |
| `className` | `string` | Additional CSS classes |

Any `data-*` attribute is passed through to the rendered `<section>`.

---

## Stack

Groups slides into a vertical column (nested navigation).

```tsx
<Stack>
  <Slide>Vertical 1</Slide>
  <Slide>Vertical 2</Slide>
  <Slide>Vertical 3</Slide>
</Stack>
```

Navigation: `↓` to go deeper, `↑` to go back up.

---

## Fragment

Reveals content incrementally within a slide.

```tsx
import { Fragment } from '@revealjs/react';

<Fragment animation="fade-up" as="p">
  First point
</Fragment>

<Fragment animation="fade-up" asChild>
  <div className="custom">Second point</div>
</Fragment>

<Fragment animation="fade-up" index={2}>
  Appears at step 2
</Fragment>
```

### Fragment Props

| Prop | Type | Description |
|------|------|-------------|
| `animation` | `string` | Fragment animation style |
| `index` | `number` | Fragment order index |
| `as` | `string` | HTML element tag to render |
| `asChild` | `boolean` | Merge props onto child element |

### Animation Styles

| Style | Effect |
|-------|--------|
| `fade-in` | Default. Fade in |
| `fade-out` | Start visible, fade out |
| `fade-up` | Slide up while fading in |
| `fade-down` | Slide down while fading in |
| `fade-left` | Slide left while fading in |
| `fade-right` | Slide right while fading in |
| `fade-in-then-out` | Fades in, then out on next step |
| `fade-in-then-semi-out` | Fades in, then to 50% |
| `grow` | Scale up |
| `shrink` | Scale down |
| `semi-fade-out` | Fade out to 50% |
| `strike` | Strike through |
| `highlight-red` | Turn text red |
| `highlight-green` | Turn text green |
| `highlight-blue` | Turn text blue |
| `highlight-current-red` | Red, then back on next step |
| `highlight-current-green` | Green, then back on next step |
| `highlight-current-blue` | Blue, then back on next step |

---

## Code

Syntax-highlighted code block using the Reveal Highlight plugin.

```tsx
import { Code } from '@revealjs/react';
import RevealHighlight from 'reveal.js/plugin/highlight';
import 'reveal.js/plugin/highlight/monokai.css';

<Deck plugins={[RevealHighlight]}>
  <Slide>
    <Code
      language="typescript"
      lineNumbers
      highlightLines="1,3-5"
      trim
      noescape
      dataLineNumbers="1|3-5|all"
    >
      {`function greet(name: string) {
  console.log('Hello, ' + name);
  return name.toUpperCase();
}

greet('World');`}
    </Code>
  </Slide>
</Deck>
```

### Code Props

| Prop | Type | Description |
|------|------|-------------|
| `language` | `string` | Language for syntax highlighting |
| `lineNumbers` | `boolean` | Show line numbers |
| `highlightLines` | `string` | Lines to highlight (e.g., `"1,3-5"`) |
| `trim` | `boolean` | Trim whitespace |
| `noescape` | `boolean` | Disable HTML escaping |
| `dataLineNumbers` | `string` | Click-based line highlighting (e.g., `"1\|3-5\|all"`) |
| `children` | `string` | Code content |

---

## Markdown

Renders Reveal-compatible markdown slides.

```tsx
import { Markdown } from '@revealjs/react';

<Markdown
  separator="^\n---\n$"
  verticalSeparator="^\n--\n$"
  notesSeparator="^notes:"
  elementAttributesSeparator="^\\.element:"
  slideAttributesSeparator="^\\.slide:"
  options={{ smartypants: true, animateLists: true }}
  src="./slides.md"  // optional: load from file
>
  {`
    ## Slide 1
    - Item one <!-- .element: class="fragment" -->
    - Item two <!-- .element: class="fragment" -->
    --
    ## Vertical Slide
    Notes:
    These become speaker notes.
    ---
    <!-- .slide: data-background="#111827" -->
    ## Slide 2
  `}
</Markdown>
```

### Markdown Props

| Prop | Type | Description |
|------|------|-------------|
| `children` | `string` | Markdown content (string) |
| `markdown` | `string` | Alternative prop for markdown content |
| `src` | `string` | URL to external markdown file |
| `separator` | `string` | Horizontal slide separator regex |
| `verticalSeparator` | `string` | Vertical slide separator regex |
| `notesSeparator` | `string` | Notes separator regex |
| `elementAttributesSeparator` | `string` | Element attributes regex |
| `slideAttributesSeparator` | `string` | Slide attributes regex |
| `options` | `MarkdownOptions` | Additional Marked options |

### Markdown Comment Attributes

```md
<!-- .slide: data-background="#111827" -->
<!-- .slide: data-transition="zoom" -->
<!-- .element: class="fragment fade-up" -->
<!-- .element: style="color: red;" -->
```

---

## useReveal()

Hook to access the Reveal API from any component within `<Deck>`.

```tsx
import { useReveal } from '@revealjs/react';

function NavigationControls() {
  const deck = useReveal();

  return (
    <div>
      <button onClick={() => deck?.prev()}>←</button>
      <button onClick={() => deck?.next()}>→</button>
      <button onClick={() => deck?.slide(2, 1)}>Go to 2.1</button>
      <button onClick={() => deck?.toggleOverview()}>Overview</button>
    </div>
  );
}
```

Returns `RevealApi | null` (null before initialization).

---

## RevealContext

Direct context access for advanced patterns.

```tsx
import { useContext } from 'react';
import { RevealContext } from '@revealjs/react';

function MyComponent() {
  const deck = useContext(RevealContext);
  // deck is RevealApi | null
}
```
