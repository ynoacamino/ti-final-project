# Themes & Transitions

## Themes

Reveal.js ships with built-in CSS themes. Import one after `reveal.css`:

```tsx
import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';
```

### Built-in Themes

| Theme | Style |
|-------|-------|
| `black` | Dark background, white text (default) |
| `white` | Light background, dark text |
| `league` | Gray background, white text |
| `beige` | Beige background, dark text |
| `night` | Dark blue background, white text |
| `serif` | Serif fonts, light background |
| `simple` | Minimal, light background |
| `solarized` | Solarized colors |
| `moon` | Dark with blue accents |
| `dracula` | Dracula color scheme |

### Using a Theme

```tsx
import 'reveal.js/reveal.css';
import 'reveal.js/theme/dracula.css';

<Deck config={{ theme: 'dracula' }}>
```

### Custom Theme

Create a CSS file following Reveal's theme structure:

```css
/* custom-theme.css */
:root {
  --r-background-color: #0a0a0a;
  --r-main-font: 'Inter', sans-serif;
  --r-main-color: #e0e0e0;
  --r-heading-font: 'Inter', sans-serif;
  --r-heading-color: white;
  --r-heading1-size: 2.5em;
  --r-heading2-size: 1.8em;
  --r-heading3-size: 1.4em;
  --r-link-color: #58a6ff;
  --r-link-color-hover: #79c0ff;
  --r-selection-background-color: #264f78;
}
```

```tsx
import './custom-theme.css';
```

### CSS Variables Reference

| Variable | Description |
|----------|-------------|
| `--r-background-color` | Slide background |
| `--r-main-font` | Body font |
| `--r-main-color` | Body text color |
| `--r-heading-font` | Heading font |
| `--r-heading-color` | Heading text color |
| `--r-heading1-size` | h1 size |
| `--r-heading2-size` | h2 size |
| `--r-heading3-size` | h3 size |
| `--r-heading4-size` | h4 size |
| `--r-heading-text-transform` | Heading text transform |
| `--r-link-color` | Link color |
| `--r-link-color-hover` | Link hover color |
| `--r-selection-background-color` | Text selection color |
| `--r-code-font` | Code font |
| `--r-code-color` | Code text color |
| `--r-main-font-size` | Base font size |
| `--r-block-margin` | Default block margin |

## Slide Transitions

### Global Transition

```tsx
<Deck config={{ transition: 'slide' }}>
```

### Per-Slide Transition

```tsx
<Slide transition="zoom">
  <h1>Zoom transition</h1>
</Slide>

<Slide transition="fade" transitionSpeed="fast">
  <h1>Fast fade</h1>
</Slide>
```

### Available Transitions

| Transition | Effect |
|------------|--------|
| `none` | No transition |
| `fade` | Crossfade |
| `slide` | Slide horizontally |
| `convex` | 3D convex slide |
| `concave` | 3D concave slide |
| `zoom` | Zoom in/out |

### Transition Speed

| Speed | Duration |
|-------|----------|
| `default` | Normal speed |
| `fast` | Faster |
| `slow` | Slower |

```tsx
<Deck config={{
  transition: 'slide',
  transitionSpeed: 'fast',
}}>
```

## Background Transitions

Separate transition for slide backgrounds:

```tsx
<Deck config={{
  transition: 'slide',
  backgroundTransition: 'zoom',
}}>
```

Per-slide override:

```tsx
<Slide
  background="#111827"
  data-background-transition="zoom"
>
```

## Custom Transition with CSS

```css
/* Custom transition */
.reveal .slides section.my-transition {
  transition: transform 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}
```

```tsx
<Slide transition="my-transition" className="my-transition">
```

## Markdown Transition Attributes

```tsx
<Markdown>
  {`
    <!-- .slide: data-transition="zoom" -->
    <!-- .slide: data-transition-speed="fast" -->
    <!-- .slide: data-background-transition="fade" -->
    ## Zoom In
  `}
</Markdown>
```

## Layout Classes

Use Reveal's built-in layout helpers:

```tsx
<Slide>
  <h2 r-fit-text>Auto-sized heading</h2>
  <img r-stretch src="image.png" />
  <p>Below the stretched image</p>
</Slide>
```

| Class | Effect |
|-------|--------|
| `r-fit-text` | Auto-size text to fit container |
| `r-stretch` | Scale media to fill remaining space |
| `r-hstack` | Horizontal flex layout |
| `r-vstack` | Vertical flex layout |
| `r-fit-text` | Auto-size text |
| `r-frame` | Styled frame/border |

### Flex Layout

```tsx
<Slide>
  <div className="r-hstack" style={{ gap: '40px' }}>
    <div>Left</div>
    <div>Center</div>
    <div>Right</div>
  </div>
</Slide>
```

## Slide Numbers

```tsx
<Deck config={{
  slideNumber: 'h.v',    // "1.2" format
  // slideNumber: 'c/t',  // "3/10" format
  // slideNumber: true,    // default format
  showSlideNumber: 'all', // 'all', 'print', 'speaker'
}}>
```

## Custom Slide Number Format

```tsx
<Deck config={{
  slideNumber: (slide) => {
    // Custom format function
    const h = slide.getAttribute('data-slide-number');
    return `${h}`;
  },
}}>
```
