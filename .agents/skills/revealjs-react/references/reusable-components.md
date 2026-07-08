# Reusable Components

Composable React components for building slide decks with consistent patterns.

## SlideLayouts

A set of layout components for common slide structures.

```tsx
import { Slide, Fragment, Code } from '@revealjs/react';

// ---- Title Slide ----
export function TitleSlide({
  title,
  subtitle,
  author,
  date,
  background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
}: {
  title: string;
  subtitle?: string;
  author?: string;
  date?: string;
  background?: string;
}) {
  return (
    <Slide background={background}>
      <h1 style={{ fontSize: '2.5em', color: 'white', marginBottom: '0.2em' }}>
        {title}
      </h1>
      {subtitle && <p style={{ color: 'rgba(255,255,255,0.8)', fontSize: '1.2em' }}>{subtitle}</p>}
      {(author || date) && (
        <p style={{ color: 'rgba(255,255,255,0.6)', marginTop: '2em' }}>
          {author}{author && date && ' · '}{date}
        </p>
      )}
    </Slide>
  );
}

// ---- Section Divider ----
export function SectionSlide({
  title,
  subtitle,
  background = '#1a1a2e',
  titleColor = '#58a6ff',
}: {
  title: string;
  subtitle?: string;
  background?: string;
  titleColor?: string;
}) {
  return (
    <Slide background={background}>
      <h1 style={{ color: titleColor, fontSize: '2.5em' }}>{title}</h1>
      {subtitle && <p style={{ color: '#8b949e' }}>{subtitle}</p>}
    </Slide>
  );
}

// ---- Content Slide ----
export function ContentSlide({
  title,
  children,
  maxWidth = '80%',
}: {
  title: string;
  children: React.ReactNode;
  maxWidth?: string;
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <div style={{ textAlign: 'left', maxWidth, margin: '0 auto' }}>
        {children}
      </div>
    </Slide>
  );
}

// ---- Two Columns ----
export function TwoColumnSlide({
  title,
  left,
  right,
  gap = '40px',
}: {
  title: string;
  left: React.ReactNode;
  right: React.ReactNode;
  gap?: string;
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <div style={{ display: 'flex', gap, marginTop: '1em' }}>
        <div style={{ flex: 1, textAlign: 'left' }}>{left}</div>
        <div style={{ flex: 1, textAlign: 'left' }}>{right}</div>
      </div>
    </Slide>
  );
}

// ---- Code Demo ----
export function CodeDemoSlide({
  title,
  code,
  language = 'typescript',
  highlights,
  showLineNumbers = true,
}: {
  title: string;
  code: string;
  language?: string;
  highlights?: string;
  showLineNumbers?: boolean;
}) {
  return (
    <Slide background="#1e1e1e">
      <h2 style={{ color: '#58a6ff' }}>{title}</h2>
      <Code language={language} lineNumbers={showLineNumbers} highlightLines={highlights}>
        {code}
      </Code>
    </Slide>
  );
}

// ---- Image Slide ----
export function ImageSlide({
  title,
  src,
  caption,
}: {
  title: string;
  src: string;
  caption?: string;
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <img r-stretch src={src} alt={title} style={{ maxHeight: '60vh' }} />
      {caption && <p style={{ color: '#8b949e', fontSize: '0.8em' }}>{caption}</p>}
    </Slide>
  );
}

// ---- Image + Text ----
export function ImageTextSlide({
  title,
  src,
  children,
  imagePosition = 'right',
}: {
  title: string;
  src: string;
  children: React.ReactNode;
  imagePosition?: 'left' | 'right';
}) {
  const textBlock = <div style={{ flex: 1, textAlign: 'left' }}>{children}</div>;
  const imageBlock = (
    <div style={{ flex: 1 }}>
      <img src={src} alt={title} style={{ maxWidth: '100%', borderRadius: '8px' }} />
    </div>
  );

  return (
    <Slide>
      <h2>{title}</h2>
      <div style={{ display: 'flex', gap: '40px', marginTop: '1em', alignItems: 'center' }}>
        {imagePosition === 'left' ? <>{imageBlock}{textBlock}</> : <>{textBlock}{imageBlock}</>}
      </div>
    </Slide>
  );
}

// ---- Quote ----
export function QuoteSlide({
  quote,
  author,
  background = '#f0f0f0',
}: {
  quote: string;
  author: string;
  background?: string;
}) {
  return (
    <Slide background={background}>
      <blockquote style={{
        fontSize: '1.8em',
        fontStyle: 'italic',
        borderLeft: '4px solid #667eea',
        paddingLeft: '1em',
        maxWidth: '80%',
        margin: '0 auto',
      }}>
        "{quote}"
      </blockquote>
      <p style={{ marginTop: '1em', color: '#666' }}>— {author}</p>
    </Slide>
  );
}

// ---- Stats / KPI ----
export function StatsSlide({
  title,
  stats,
}: {
  title: string;
  stats: { label: string; value: string; color?: string }[];
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <div style={{ display: 'flex', gap: '40px', justifyContent: 'center', marginTop: '2em' }}>
        {stats.map((stat, i) => (
          <div key={i} style={{ textAlign: 'center' }}>
            <div style={{ fontSize: '2.5em', fontWeight: 'bold', color: stat.color || '#58a6ff' }}>
              {stat.value}
            </div>
            <div style={{ color: '#8b949e' }}>{stat.label}</div>
          </div>
        ))}
      </div>
    </Slide>
  );
}

// ---- List with Fragments ----
export function ListSlide({
  title,
  items,
  animation = 'fade-up',
}: {
  title: string;
  items: string[];
  animation?: string;
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <ul style={{ textAlign: 'left', maxWidth: '80%', margin: '0 auto' }}>
        {items.map((item, i) => (
          <li key={i}>
            <Fragment animation={animation}>{item}</Fragment>
          </li>
        ))}
      </ul>
    </Slide>
  );
}

// ---- End Slide ----
export function EndSlide({
  message = 'Thank You!',
  subtitle = 'Questions?',
  background = 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)',
}: {
  message?: string;
  subtitle?: string;
  background?: string;
}) {
  return (
    <Slide background={background}>
      <h1 style={{ fontSize: '3em', color: 'white' }}>{message}</h1>
      <p style={{ color: 'rgba(255,255,255,0.6)', marginTop: '1em' }}>{subtitle}</p>
    </Slide>
  );
}
```

## Navigation Controls

Custom navigation components using `useReveal()`.

```tsx
import { useReveal } from '@revealjs/react';

export function SlideCounter() {
  const deck = useReveal();
  if (!deck) return null;

  const { h } = deck.getIndices();
  const total = deck.getTotalSlides();

  return (
    <div style={{
      position: 'fixed',
      bottom: '20px',
      right: '20px',
      color: '#8b949e',
      fontSize: '0.8em',
    }}>
      {h + 1} / {total}
    </div>
  );
}

export function CustomControls() {
  const deck = useReveal();
  if (!deck) return null;

  return (
    <div style={{
      position: 'fixed',
      bottom: '20px',
      left: '50%',
      transform: 'translateX(-50%)',
      display: 'flex',
      gap: '10px',
    }}>
      <button onClick={() => deck.prev()}>←</button>
      <button onClick={() => deck.toggleOverview()}>Overview</button>
      <button onClick={() => deck.togglePause()}>Pause</button>
      <button onClick={() => deck.next()}>→</button>
    </div>
  );
}

export function ProgressBar() {
  const deck = useReveal();
  if (!deck) return null;

  const progress = deck.getProgress();

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      width: `${progress * 100}%`,
      height: '3px',
      background: '#58a6ff',
      transition: 'width 0.3s',
    }} />
  );
}
```

## useSlideState Hook

Custom hook for tracking slide state.

```tsx
import { useState, useEffect } from 'react';
import { useReveal } from '@revealjs/react';

export function useSlideState() {
  const deck = useReveal();
  const [state, setState] = useState({
    indexh: 0,
    indexv: 0,
    isFirst: true,
    isLast: false,
    progress: 0,
  });

  useEffect(() => {
    if (!deck) return;

    const update = () => {
      const { h, v } = deck.getIndices();
      setState({
        indexh: h,
        indexv: v,
        isFirst: deck.isFirstSlide(),
        isLast: deck.isLastSlide(),
        progress: deck.getProgress(),
      });
    };

    update();
    deck.on('slidechanged', update);
    return () => deck.off('slidechanged', update);
  }, [deck]);

  return state;
}
```

## Slide Transition Wrapper

Wrap slides with consistent transition settings.

```tsx
import { Slide } from '@revealjs/react';

export function FadeSlide({
  children,
  ...props
}: React.ComponentProps<typeof Slide>) {
  return (
    <Slide transition="fade" transitionSpeed="fast" {...props}>
      {children}
    </Slide>
  );
}

export function ZoomSlide({
  children,
  ...props
}: React.ComponentProps<typeof Slide>) {
  return (
    <Slide transition="zoom" {...props}>
      {children}
    </Slide>
  );
}
```

## Media Helpers

Components for embedding media in slides.

```tsx
export function VideoSlide({
  title,
  src,
  poster,
  autoplay = false,
}: {
  title: string;
  src: string;
  poster?: string;
  autoplay?: boolean;
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <video
        src={src}
        poster={poster}
        autoPlay={autoplay}
        controls
        style={{ maxHeight: '60vh' }}
      />
    </Slide>
  );
}

export function IframeSlide({
  title,
  src,
  interactive = false,
}: {
  title: string;
  src: string;
  interactive?: boolean;
}) {
  return (
    <Slide backgroundIframe={src} backgroundInteractive={interactive}>
      <h2 style={{ background: 'rgba(0,0,0,0.7)', padding: '0.5em' }}>
        {title}
      </h2>
    </Slide>
  );
}
```

## Complete Deck Example

Using the reusable components:

```tsx
import { Deck, Stack } from '@revealjs/react';
import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';
import RevealHighlight from 'reveal.js/plugin/highlight';
import 'reveal.js/plugin/highlight/monokai.css';

import {
  TitleSlide,
  SectionSlide,
  ContentSlide,
  TwoColumnSlide,
  CodeDemoSlide,
  ListSlide,
  StatsSlide,
  EndSlide,
  SlideCounter,
  ProgressBar,
} from './components';

export default function MyPresentation() {
  return (
    <Deck
      config={{ hash: true, controls: true, progress: true }}
      plugins={[RevealHighlight]}
    >
      <TitleSlide
        title="My Talk"
        subtitle="About interesting things"
        author="Speaker Name"
        date="2025"
      />

      <ListSlide
        title="Agenda"
        items={['Introduction', 'Deep Dive', 'Demo', 'Q&A']}
      />

      <SectionSlide title="Part 1" subtitle="The Basics" />

      <ContentSlide title="Overview">
        <ul>
          <li>Key point one</li>
          <li>Key point two</li>
          <li>Key point three</li>
        </ul>
      </ContentSlide>

      <TwoColumnSlide
        title="Comparison"
        left={<><h3>Before</h3><ul><li>Old way</li></ul></>}
        right={<><h3>After</h3><ul><li>New way</li></ul></>}
      />

      <CodeDemoSlide
        title="Implementation"
        language="typescript"
        code={`function greet(name: string) {
  console.log(\`Hello, \${name}!\`);
}`}
        highlights="2"
      />

      <StatsSlide
        title="Results"
        stats={[
          { label: 'Speed', value: '10x', color: '#10b981' },
          { label: 'Size', value: '50%', color: '#3b82f6' },
          { label: 'Users', value: '1K+', color: '#8b5cf6' },
        ]}
      />

      <EndSlide message="Thank You!" subtitle="Questions?" />
    </Deck>
  );
}
```
