# Setup & Installation

## Install Dependencies

```bash
npm i @revealjs/react reveal.js react react-dom
# or
yarn add @revealjs/react reveal.js react react-dom
```

Peer dependencies: `react`, `react-dom`, `reveal.js`.

## Basic Project Structure

```
my-presentation/
├── src/
│   ├── App.tsx           # Main presentation component
│   ├── main.tsx          # Entry point
│   └── slides/           # Individual slide components (optional)
│       ├── TitleSlide.tsx
│       └── ContentSlide.tsx
├── index.html
├── package.json
├── tsconfig.json
└── vite.config.ts
```

## Vite Configuration

```ts
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
});
```

## Entry Point

```tsx
// src/main.tsx
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import Presentation from './App';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <Presentation />
  </StrictMode>
);
```

## HTML Template

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Presentation</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

## Required CSS Imports

Always import Reveal CSS and a theme:

```tsx
import 'reveal.js/reveal.css';
import 'reveal.js/theme/black.css';  // or white.css, league.css, etc.
```

Plugin CSS when using plugins:

```tsx
import 'reveal.js/plugin/highlight/monokai.css';  // for Code component
```

## Next.js / SSR Considerations

`@revealjs/react` accesses `window` and `document`. If using Next.js or any SSR framework, wrap the presentation in a dynamic import with SSR disabled:

```tsx
import dynamic from 'next/dynamic';

const Presentation = dynamic(() => import('./components/MyDeck'), {
  ssr: false,
});
```

## Verify Installation

```bash
npm run dev
# Open http://localhost:5173 (or Vite's port)
# Should show a blank presentation with theme applied
```
