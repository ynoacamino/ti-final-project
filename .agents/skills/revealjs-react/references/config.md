# Configuration Reference

Pass any option via the `config` prop on `<Deck>`. All values are optional.

```tsx
<Deck
  config={{
    width: 1280,
    height: 720,
    hash: true,
    controls: true,
    transition: 'slide',
  }}
>
```

## Display

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `width` | `number` | `960` | Presentation width in pixels |
| `height` | `number` | `700` | Presentation height in pixels |
| `disableLayout` | `boolean` | `false` | Disable default scaling/centering |
| `center` | `boolean` | `true` | Vertically center slides |
| `display` | `string` | `'block'` | CSS display mode |
| `embedded` | `boolean` | `false` | Embedded in limited screen area |

## Navigation

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `controls` | `boolean \| 'speaker'` | `true` | Show navigation arrows |
| `controlsTutorial` | `boolean` | `true` | Bounce arrow on first vertical slide |
| `controlsLayout` | `string` | `'bottom-right'` | `'edges'` or `'bottom-right'` |
| `controlsBackArrows` | `string` | `'faded'` | `'faded'`, `'hidden'`, or `'visible'` |
| `progress` | `boolean` | `true` | Show progress bar |
| `slideNumber` | `boolean \| string` | `false` | Slide number format |
| `showSlideNumber` | `string` | `'all'` | `'all'`, `'print'`, or `'speaker'` |
| `hash` | `boolean` | `false` | Add slide number to URL hash |
| `hashOneBasedIndex` | `boolean` | `false` | 1-based indexing for hash |
| `respondToHashChanges` | `boolean` | `true` | Monitor hash for changes |
| `history` | `boolean` | `false` | Push changes to browser history |
| `jumpToSlide` | `boolean` | `true` | Enable jump-to-slide shortcuts |
| `keyboard` | `boolean` | `true` | Enable keyboard shortcuts |
| `keyboardCondition` | `string \| null` | `null` | `'focused'` for embedded decks |
| `overview` | `boolean` | `true` | Enable overview mode |
| `touch` | `boolean` | `true` | Enable touch navigation |
| `loop` | `boolean` | `false` | Loop presentation |
| `rtl` | `boolean` | `false` | Right-to-left direction |
| `navigationMode` | `string` | `'default'` | `'default'`, `'linear'`, or `'grid'` |
| `shuffle` | `boolean` | `false` | Randomize slide order |
| `mouseWheel` | `boolean` | `false` | Navigate via mouse wheel |
| `hideInactiveCursor` | `boolean` | `true` | Hide cursor when inactive |
| `hideCursorTime` | `number` | `5000` | Time before hiding cursor (ms) |

## Fragments

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `fragments` | `boolean` | `true` | Enable/disable fragments globally |
| `fragmentInURL` | `boolean` | `true` | Include fragment in URL hash |

## Transitions

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `transition` | `string` | `'slide'` | `'none'`, `'fade'`, `'slide'`, `'convex'`, `'concave'`, `'zoom'` |
| `transitionSpeed` | `string` | `'default'` | `'default'`, `'fast'`, `'slow'` |
| `backgroundTransition` | `string` | `'fade'` | Background transition style |

## Auto-Animate

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `autoAnimate` | `boolean` | `true` | Enable auto-animate globally |
| `autoAnimateMatcher` | `function` | `null` | Custom element matcher |
| `autoAnimateEasing` | `string` | `'ease'` | CSS easing function |
| `autoAnimateDuration` | `number` | `1.0` | Animation duration (seconds) |
| `autoAnimateUnmatched` | `boolean` | `true` | Fade in unmatched elements |
| `autoAnimateStyles` | `string[]` | `['opacity', 'color', ...]` | CSS properties to animate |

## Auto-Slide

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `autoSlide` | `number` | `0` | Auto-advance interval (ms). 0 = only if attribute present |
| `autoSlideStoppable` | `boolean` | `true` | Stop auto-slide on user input |
| `autoSlideMethod` | `function` | `null` | Custom navigation method |
| `defaultTiming` | `number` | `null` | Average seconds per slide (speaker view pacing) |

## Media

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `autoPlayMedia` | `boolean \| null` | `null` | Global autoplay override |
| `preloadIframes` | `boolean \| null` | `null` | Preload iframes with data-src |
| `preventIframeAutoFocus` | `boolean` | `true` | Prevent iframe focus stealing |

## PDF Export

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `pdfMaxPagesPerSlide` | `number` | `Infinity` | Max pages per slide in PDF |
| `pdfSeparateFragments` | `boolean` | `true` | Print each fragment on separate slide |
| `pdfPageHeightOffset` | `number` | `-1` | Height offset for PDF export |

## Advanced

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `viewDistance` | `number` | `3` | Visible slides around current |
| `mobileViewDistance` | `number` | `2` | Visible slides on mobile |
| `help` | `boolean` | `true` | Show help overlay on `?` |
| `pause` | `boolean` | `true` | Allow pause (blackout) |
| `showNotes` | `boolean` | `false` | Show notes to all viewers |
| `previewLinks` | `boolean` | `false` | Open links in iframe overlay |
| `postMessage` | `boolean` | `true` | Expose API via postMessage |
| `postMessageEvents` | `boolean` | `false` | Dispatch events via postMessage |
| `focusBodyOnPageVisibilityChange` | `boolean` | `true` | Focus body on visibility change |

## Runtime Reconfiguration

```tsx
// The config prop is shallow-compared.
// Changing a value calls reveal.configure() automatically.
function MyDeck({ showControls }) {
  return (
    <Deck config={{ controls: showControls }}>
      <Slide>Content</Slide>
    </Deck>
  );
}
```

## Common Configurations

### Minimal / Clean

```tsx
<Deck config={{
  controls: false,
  progress: false,
  slideNumber: false,
  transition: 'fade',
  transitionSpeed: 'fast',
}}>
```

### Conference Talk

```tsx
<Deck config={{
  hash: true,
  controls: true,
  progress: true,
  slideNumber: 'h.v',
  transition: 'slide',
  width: 1920,
  height: 1080,
}}>
```

### Workshop / Tutorial

```tsx
<Deck config={{
  hash: true,
  controls: true,
  progress: true,
  slideNumber: 'c/t',
  overview: true,
  touch: true,
  loop: false,
}}>
```
