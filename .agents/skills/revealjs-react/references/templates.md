# Slide Templates

Pre-built slide patterns for common presentation needs.

## Title / Cover Slide

```tsx
function TitleSlide() {
  return (
    <Slide background="linear-gradient(135deg, #667eea 0%, #764ba2 100%)">
      <h1 style={{ fontSize: '2.5em', color: 'white', marginBottom: '0.2em' }}>
        Presentation Title
      </h1>
      <p style={{ color: 'rgba(255,255,255,0.8)', fontSize: '1.2em' }}>
        Subtitle or description
      </p>
      <p style={{ color: 'rgba(255,255,255,0.6)', marginTop: '2em' }}>
        Author Name &middot; Date
      </p>
    </Slide>
  );
}
```

## Section Divider

```tsx
function SectionSlide({ title, subtitle }: { title: string; subtitle?: string }) {
  return (
    <Slide background="#1a1a2e">
      <h1 style={{ color: '#58a6ff', fontSize: '2.5em' }}>{title}</h1>
      {subtitle && <p style={{ color: '#8b949e' }}>{subtitle}</p>}
    </Slide>
  );
}
```

## Content Slide

```tsx
function ContentSlide({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <Slide>
      <h2>{title}</h2>
      <div style={{ textAlign: 'left', maxWidth: '80%', margin: '0 auto' }}>
        {children}
      </div>
    </Slide>
  );
}

// Usage
<ContentSlide title="Key Points">
  <ul>
    <li><Fragment>First point</Fragment></li>
    <li><Fragment>Second point</Fragment></li>
    <li><Fragment>Third point</Fragment></li>
  </ul>
</ContentSlide>
```

## Two Column Layout

```tsx
function TwoColumnSlide({
  title,
  left,
  right,
}: {
  title: string;
  left: React.ReactNode;
  right: React.ReactNode;
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <div style={{ display: 'flex', gap: '40px', marginTop: '1em' }}>
        <div style={{ flex: 1, textAlign: 'left' }}>{left}</div>
        <div style={{ flex: 1, textAlign: 'left' }}>{right}</div>
      </div>
    </Slide>
  );
}

// Usage
<TwoColumnSlide
  title="Comparison"
  left={
    <Fragment>
      <h3>Before</h3>
      <ul>
        <li>Old approach</li>
        <li>Slow</li>
      </ul>
    </Fragment>
  }
  right={
    <Fragment>
      <h3>After</h3>
      <ul>
        <li>New approach</li>
        <li>Fast</li>
      </ul>
    </Fragment>
  }
/>
```

## Code Demo Slide

```tsx
function CodeDemoSlide({
  title,
  code,
  language = 'typescript',
  highlights,
}: {
  title: string;
  code: string;
  language?: string;
  highlights?: string;
}) {
  return (
    <Slide background="#1e1e1e">
      <h2 style={{ color: '#58a6ff' }}>{title}</h2>
      <Code language={language} lineNumbers highlightLines={highlights}>
        {code}
      </Code>
    </Slide>
  );
}
```

## Image Slide

```tsx
function ImageSlide({
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
```

## Quote Slide

```tsx
function QuoteSlide({ quote, author }: { quote: string; author: string }) {
  return (
    <Slide background="#f0f0f0">
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
```

## Stats / KPI Slide

```tsx
function StatsSlide({
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
          <Fragment key={i}>
            <div style={{ textAlign: 'center' }}>
              <div style={{ fontSize: '2.5em', fontWeight: 'bold', color: stat.color || '#58a6ff' }}>
                {stat.value}
              </div>
              <div style={{ color: '#8b949e' }}>{stat.label}</div>
            </div>
          </Fragment>
        ))}
      </div>
    </Slide>
  );
}

// Usage
<StatsSlide
  title="Performance Metrics"
  stats={[
    { label: 'Latency', value: '<50ms', color: '#10b981' },
    { label: 'Uptime', value: '99.9%', color: '#3b82f6' },
    { label: 'Users', value: '10K+', color: '#8b5cf6' },
  ]}
/>
```

## List with Fragments Slide

```tsx
function ListSlide({
  title,
  items,
}: {
  title: string;
  items: string[];
}) {
  return (
    <Slide>
      <h2>{title}</h2>
      <ul style={{ textAlign: 'left', maxWidth: '80%', margin: '0 auto' }}>
        {items.map((item, i) => (
          <li key={i}>
            <Fragment animation="fade-up">{item}</Fragment>
          </li>
        ))}
      </ul>
    </Slide>
  );
}
```

## Image + Text Side-by-Side

```tsx
function ImageTextSlide({
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
  const textBlock = (
    <div style={{ flex: 1, textAlign: 'left' }}>{children}</div>
  );
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
```

## Thank You / End Slide

```tsx
function EndSlide({ message = 'Thank You!' }: { message?: string }) {
  return (
    <Slide background="linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)">
      <h1 style={{ fontSize: '3em', color: 'white' }}>{message}</h1>
      <p style={{ color: 'rgba(255,255,255,0.6)', marginTop: '1em' }}>
        Questions?
      </p>
    </Slide>
  );
}
```

## Complete Presentation Template

```tsx
import { Deck, Slide, Fragment, Code, Stack } from '@revealjs/react';
import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';
import RevealHighlight from 'reveal.js/plugin/highlight';
import RevealNotes from 'reveal.js/plugin/notes';
import 'reveal.js/plugin/highlight/monokai.css';

export default function Presentation() {
  return (
    <Deck
      config={{
        hash: true,
        controls: true,
        progress: true,
        slideNumber: 'h.v',
        transition: 'slide',
        width: 1920,
        height: 1080,
      }}
      plugins={[RevealHighlight, RevealNotes]}
    >
      {/* Title */}
      <Slide background="linear-gradient(135deg, #667eea 0%, #764ba2 100%)">
        <h1 style={{ color: 'white' }}>My Presentation</h1>
        <p style={{ color: 'rgba(255,255,255,0.7)' }}>Author &middot; 2025</p>
      </Slide>

      {/* Agenda */}
      <Slide>
        <h2>Agenda</h2>
        <ul>
          <li><Fragment>Introduction</Fragment></li>
          <li><Fragment>Deep Dive</Fragment></li>
          <li><Fragment>Demo</Fragment></li>
          <li><Fragment>Q&A</Fragment></li>
        </ul>
      </Slide>

      {/* Content with vertical slides */}
      <Stack>
        <Slide>
          <h2>Topic 1</h2>
          <Fragment animation="fade-up"><p>Key insight</p></Fragment>
        </Slide>
        <Slide>
          <h2>Topic 1 - Details</h2>
          <Code language="typescript">{`const example = 'code';`}</Code>
        </Slide>
      </Stack>

      {/* End */}
      <Slide background="#1a1a2e">
        <h1 style={{ color: 'white' }}>Thank You!</h1>
      </Slide>
    </Deck>
  );
}
```
