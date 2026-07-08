# Auto-Animate

Automatically animate matching elements between adjacent slides.

## Basic Usage

```tsx
<Slide autoAnimate>
  <h1>Hello</h1>
</Slide>
<Slide autoAnimate>
  <h1 style={{ color: 'red', marginTop: '100px' }}>Hello</h1>
</Slide>
```

Reveal automatically matches elements by:
1. `data-id` attribute (highest priority)
2. Text content + node type
3. `src` attribute for images/videos/iframes
4. DOM order

## Element Matching with data-id

When automatic matching isn't feasible, use matching `data-id`:

```tsx
<Slide autoAnimate>
  <div data-id="box" style={{ height: 50, background: 'salmon' }} />
</Slide>
<Slide autoAnimate>
  <div data-id="box" style={{ height: 200, background: 'blue' }} />
</Slide>
```

## Animation Settings

### Per-Slide Attributes

| Attribute | Default | Description |
|-----------|---------|-------------|
| `data-auto-animate-easing` | `ease` | CSS easing function |
| `data-auto-animate-duration` | `1.0` | Duration in seconds |
| `data-auto-animate-delay` | `0` | Delay in seconds (element only) |
| `data-auto-animate-unmatched` | `true` | Fade in unmatched elements |
| `data-auto-animate-id` | - | Group ID for multi-group animations |
| `data-auto-animate-restart` | - | Break auto-animate chain |

### Global Defaults (via config)

```tsx
<Deck config={{
  autoAnimateEasing: 'ease-out',
  autoAnimateDuration: 0.8,
  autoAnimateUnmatched: false,
}}>
```

### Per-Slide in React

```tsx
<Slide
  autoAnimate
  data-auto-animate-easing="ease-in-out"
  data-auto-animate-duration="0.5"
>
```

## Auto-Animate Groups

Use `data-auto-animate-id` to create separate animation groups:

```tsx
<Slide autoAnimate><h1>Group A</h1></Slide>
<Slide autoAnimate><h1 style={{ color: '#3B82F6' }}>Group A</h1></Slide>

<Slide autoAnimate data-auto-animate-id="two"><h1>Group B</h1></Slide>
<Slide autoAnimate data-auto-animate-id="two"><h1 style={{ color: '#10B981' }}>Group B</h1></Slide>
```

## Breaking the Chain

Use `data-auto-animate-restart` to break animation between adjacent slides:

```tsx
<Slide autoAnimate><h1>Animates</h1></Slide>
<Slide autoAnimate data-auto-animate-restart><h1>Does NOT animate from previous</h1></Slide>
<Slide autoAnimate><h1>Animates from restart</h1></Slide>
```

## Animating Code Blocks

```tsx
<Slide autoAnimate>
  <pre data-id="code"><code className="typescript" data-line-numbers>
    {`let planets = [
  { name: 'mars', diameter: 6779 },
]`}
  </code></pre>
</Slide>
<Slide autoAnimate>
  <pre data-id="code"><code className="typescript" data-line-numbers>
    {`let planets = [
  { name: 'mars', diameter: 6779 },
  { name: 'earth', diameter: 12742 },
  { name: 'jupiter', diameter: 139820 },
]`}
  </code></pre>
</Slide>
```

## Animating Lists

Lists are matched individually - items can be added/removed:

```tsx
<Slide autoAnimate>
  <ul>
    <li>Mercury</li>
    <li>Jupiter</li>
    <li>Mars</li>
  </ul>
</Slide>
<Slide autoAnimate>
  <ul>
    <li>Mercury</li>
    <li>Earth</li>
    <li>Jupiter</li>
    <li>Saturn</li>
    <li>Mars</li>
  </ul>
</Slide>
```

## Animatable CSS Properties

Default animatable properties:
- `opacity`
- `color`
- `background-color`
- `padding`
- `font-size`
- `line-height`
- `letter-spacing`
- `border-width`
- `border-color`
- `border-radius`
- `outline`
- `outline-offset`

Position and scale are matched separately via transforms.

## Custom Animatable Properties

Override the global list via config:

```tsx
<Deck config={{
  autoAnimateStyles: ['opacity', 'color', 'transform', 'filter'],
}}>
```

## Disable Auto-Animate Globally

```tsx
<Deck config={{ autoAnimate: false }}>
```

## Events

```tsx
<Deck onAutoAnimate={(event) => {
  // event.fromSlide - source slide
  // event.toSlide - target slide
}}>
```
