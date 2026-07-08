# Slide Backgrounds

Set backgrounds per-slide using props on `<Slide>` or markdown comment attributes.

## Solid Color

```tsx
<Slide background="#1a1a2e">
  <h1>Dark blue background</h1>
</Slide>

<Slide background="rgb(0, 200, 100)">
  <h1>Green background</h1>
</Slide>

<Slide background="rgba(0,0,0,0.8)">
  <h1>Semi-transparent black</h1>
</Slide>
```

## Gradient

```tsx
<Slide background="linear-gradient(to bottom right, #667eea, #764ba2)">
  <h1>Gradient background</h1>
</Slide>
```

## Image

```tsx
<Slide
  backgroundImage="url(https://example.com/photo.jpg)"
  backgroundSize="cover"
  backgroundPosition="center"
>
  <h1 style={{ textShadow: '2px 2px 4px rgba(0,0,0,0.8)' }}>
    Text over image
  </h1>
</Slide>
```

### Image Options

| Prop | Description |
|------|-------------|
| `backgroundImage` | Image URL (`url(...)` or direct URL) |
| `backgroundSize` | CSS `background-size` (`cover`, `contain`, `100px`) |
| `backgroundPosition` | CSS `background-position` |
| `backgroundRepeat` | CSS `background-repeat` (`repeat`, `no-repeat`) |
| `backgroundOpacity` | Background opacity (0-1) |

### Tiled Background

```tsx
<Slide
  backgroundImage="url(pattern.png)"
  backgroundRepeat="repeat"
  backgroundSize="100px"
>
```

## Video

```tsx
<Slide backgroundVideo="https://example.com/video.mp4">
  <h1>Video background</h1>
</Slide>

<Slide
  backgroundVideo="video.mp4,video.webm"
  backgroundVideoLoop
  backgroundVideoMuted
>
```

### Video Options

| Prop | Description |
|------|-------------|
| `backgroundVideo` | Video URL(s), comma-separated for fallbacks |
| `backgroundVideoLoop` | Loop the video |
| `backgroundVideoMuted` | Mute the video |

## Iframe

```tsx
<Slide backgroundIframe="https://example.com">
  <h1>Iframe background</h1>
</Slide>

<Slide
  backgroundIframe="https://example.com"
  backgroundInteractive
>
  <h1>Interactive iframe</h1>
</Slide>
```

| Prop | Description |
|------|-------------|
| `backgroundIframe` | URL to embed |
| `backgroundInteractive` | Allow interaction with iframe (default: blocks interaction) |

## Background Transition

Override the background transition per-slide:

```tsx
<Slide
  background="#111827"
  data-background-transition="zoom"
>
```

Global default:

```tsx
<Deck config={{ backgroundTransition: 'zoom' }}>
```

## Parallax Background

```tsx
<Deck config={{
  parallaxBackgroundImage: 'https://example.com/parallax.jpg',
  parallaxBackgroundSize: '2100px 900px',
  parallaxBackgroundHorizontal: 200,
  parallaxBackgroundVertical: 50,
}}>
```

## Markdown Backgrounds

```tsx
<Markdown>
  {`
    <!-- .slide: data-background="#111827" -->
    ## Dark Slide

    <!-- .slide: data-background-image="https://example.com/img.jpg" -->
    <!-- .slide: data-background-size="cover" -->
    ## Image Slide

    <!-- .slide: data-background-video="video.mp4" -->
    ## Video Slide
  `}
</Markdown>
```

## Background Examples

### Section Divider

```tsx
<Slide background="linear-gradient(135deg, #667eea 0%, #764ba2 100%)">
  <h1 style={{ color: 'white', fontSize: '3em' }}>Section Title</h1>
</Slide>
```

### Code with Dark Background

```tsx
<Slide background="#1e1e1e">
  <Code language="typescript">
    {`const hello = 'world';`}
  </Code>
</Slide>
```

### Image with Overlay

```tsx
<Slide background="rgba(0,0,0,0.7)" backgroundImage="url(photo.jpg)">
  <h1 style={{ color: 'white' }}>Overlay Text</h1>
</Slide>
```
