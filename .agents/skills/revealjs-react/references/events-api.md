# Events & API Reference

## Deck Event Props

Subscribe to Reveal.js events via props on `<Deck>`:

```tsx
<Deck
  onReady={(deck) => { /* Reveal initialized */ }}
  onSync={() => { /* Deck synced */ }}
  onSlideChange={(event) => { /* Slide changed */ }}
  onSlideChanged={(event) => { /* Slide change complete */ }}
  onFragmentShown={(event) => { /* Fragment shown */ }}
  onFragmentHidden={(event) => { /* Fragment hidden */ }}
  onAutoSlidePaused={() => { /* Auto-slide paused */ }}
  onAutoSlideResumed={() => { /* Auto-slide resumed */ }}
  onResize={(event) => { /* Window resized */ }}
  onOverviewShown={() => { /* Overview opened */ }}
  onOverviewHidden={() => { /* Overview closed */ }}
  onPaused={() => { /* Presentation paused */ }}
  onResumed={() => { /* Presentation resumed */ }}
>
```

### Event Types

```tsx
interface SlideEvent {
  indexh: number;    // Horizontal slide index
  indexv: number;    // Vertical slide index
  previousSlide: Element;
  currentSlide: Element;
  origin: Element;
}

interface FragmentEvent {
  fragment: Element;
}

interface ResizeEvent {
  scale: number;
  oldScale: number;
  size: { width: number; height: number };
}
```

## useReveal() Hook

Access the Reveal API from any component within `<Deck>`:

```tsx
import { useReveal } from '@revealjs/react';

function SlideCounter() {
  const deck = useReveal();
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (!deck) return;
    const handler = (e: SlideEvent) => setCurrent(e.indexh);
    deck.on('slidechanged', handler);
    return () => deck.off('slidechanged', handler);
  }, [deck]);

  return <span>Slide {current + 1}</span>;
}
```

### Common API Methods

```tsx
const deck = useReveal();

// Navigation
deck?.next();           // Next slide/fragment
deck?.prev();           // Previous slide/fragment
deck?.nextFragment();   // Next fragment only
deck?.prevFragment();   // Previous fragment only
deck?.slide(2, 1);      // Go to horizontal 2, vertical 1

// State
deck?.isFirstSlide();   // boolean
deck?.isLastSlide();    // boolean
deck?.isOverview();     // boolean
deck?.isPaused();       // boolean
deck?.isAutoSliding();  // boolean

// Indices
deck?.getIndices();     // { h, v, f }
deck?.getProgress();    // 0-1
deck?.getTotalSlides(); // number

// Features
deck?.toggleOverview();
deck?.togglePause();
deck?.toggleAutoSlide();
deck?.configure({ transition: 'zoom' });
deck?.layout();
deck?.sync();
deck?.syncSlide(slideElement);

// Events
deck?.on('eventname', handler);
deck?.off('eventname', handler);

// Plugins
deck?.hasPlugin('highlight');
deck?.getPlugin('highlight');
deck?.getPlugins();

// Print / Export
deck?.isPrintingPDF(); // boolean
```

## deckRef

Access the Reveal instance outside the component tree:

```tsx
import { useRef } from 'react';
import { Deck, Slide } from '@revealjs/react';
import type { RevealApi } from 'reveal.js';

function App() {
  const deckRef = useRef<RevealApi | null>(null);

  const handleExport = () => {
    if (deckRef.current) {
      // Access deck outside of React tree
      console.log('Total slides:', deckRef.current.getTotalSlides());
    }
  };

  return (
    <>
      <button onClick={handleExport}>Export Info</button>
      <Deck deckRef={deckRef}>
        <Slide>Hello</Slide>
      </Deck>
    </>
  );
}
```

## RevealContext

Direct context access for advanced patterns:

```tsx
import { useContext } from 'react';
import { RevealContext } from '@revealjs/react';

function AdvancedControls() {
  const deck = useContext(RevealContext);

  if (!deck) return null;

  return (
    <div>
      <button onClick={() => deck.slide(0, 0)}>First</button>
      <button onClick={() => deck.slide(deck.getTotalSlides() - 1)}>Last</button>
      <button onClick={() => deck.toggleOverview()}>Overview</button>
    </div>
  );
}
```

## All Reveal.js Events

| Event | Description |
|-------|-------------|
| `ready` | Reveal.js loaded and ready |
| `slidechanged` | Slide changed (horizontal or vertical) |
| `slidetransitionend` | Slide transition ended |
| `autoslidepaused` | Auto-slide paused |
| `autoslideresumed` | Auto-slide resumed |
| `fragmentshown` | Fragment shown |
| `fragmenthidden` | Fragment hidden |
| `overviewshown` | Overview mode opened |
| `overviewhidden` | Overview mode closed |
| `paused` | Presentation paused |
| `resumed` | Presentation resumed |
| `resize` | Window resized |
| `prefers-color-scheme` | Color scheme changed |
| `autoanimate` | Auto-animate triggered |
| `pdf-ready` | PDF export ready |

## Custom Events

Dispatch and listen to custom events:

```tsx
const deck = useReveal();

// Listen
deck?.on('myCustomEvent', (data) => {
  console.log(data);
});

// Dispatch (from any code with access to deck)
deck?.dispatchEvent({
  type: 'myCustomEvent',
  data: { message: 'Hello' },
});
```
