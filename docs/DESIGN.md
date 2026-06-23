---
name: Kura & Craft
colors:
  surface: '#fbf9f4'
  surface-dim: '#dbdad5'
  surface-bright: '#fbf9f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3ee'
  surface-container: '#f0eee9'
  surface-container-high: '#eae8e3'
  surface-container-highest: '#e4e2dd'
  on-surface: '#1b1c19'
  on-surface-variant: '#45464d'
  inverse-surface: '#30312e'
  inverse-on-surface: '#f2f1ec'
  outline: '#76777e'
  outline-variant: '#c6c6ce'
  surface-tint: '#555e78'
  primary: '#040d23'
  on-primary: '#ffffff'
  primary-container: '#1a233a'
  on-primary-container: '#818aa6'
  inverse-primary: '#bdc6e4'
  secondary: '#7c5730'
  on-secondary: '#ffffff'
  secondary-container: '#fdcb9b'
  on-secondary-container: '#79542d'
  tertiary: '#230400'
  on-tertiary: '#ffffff'
  tertiary-container: '#490e00'
  on-tertiary-container: '#e86038'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2ff'
  primary-fixed-dim: '#bdc6e4'
  on-primary-fixed: '#121b31'
  on-primary-fixed-variant: '#3d465f'
  secondary-fixed: '#ffdcbd'
  secondary-fixed-dim: '#eebd8e'
  on-secondary-fixed: '#2c1600'
  on-secondary-fixed-variant: '#61401b'
  tertiary-fixed: '#ffdbd1'
  tertiary-fixed-dim: '#ffb5a0'
  on-tertiary-fixed: '#3b0900'
  on-tertiary-fixed-variant: '#872100'
  background: '#fbf9f4'
  on-background: '#1b1c19'
  surface-variant: '#e4e2dd'
typography:
  display:
    fontFamily: Manrope
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  gutter: 16px
  margin: 20px
---

## Brand & Style

The design system draws inspiration from the *Kura* (traditional Japanese storehouse) aesthetic—balancing the rugged, artisanal nature of sake production with a modern, high-end retail experience. The brand personality is professional yet inviting, emphasizing craftsmanship, heritage, and the tactile quality of natural materials.

The design style is **Modern Minimalist with Tactile Accents**. It utilizes expansive whitespace (negative space) to evoke the stillness of a brewery, while using color and subtle shadows to create a sense of physical depth. The interface should feel like a premium lifestyle magazine: intentional, legible, and calm.

## Colors

The palette is rooted in the traditional elements of sake making:
- **Deep Indigo (#1A233A):** Represents the craftsmans' aprons and the night sky over rice fields. Used for primary branding and high-contrast text.
- **Warm Cedar (#A67C52):** Inspired by *Sugidama* (cedar balls) and sake casks. Used for secondary accents and subtle decorative elements.
- **Washi Paper (#F9F7F2):** The foundation of the UI. A soft, warm off-white that reduces eye strain and provides a premium, non-clinical feel.
- **Persimmon (#E05A33):** A vibrant, high-energy accent used sparingly for calls-to-action and critical notifications, reminiscent of autumn fruit and traditional lacquerware.

## Typography

The system uses a pairing of two modern sans-serifs to maintain a contemporary edge while respecting artisanal proportions.

- **Headlines:** Manrope provides a refined, slightly geometric structure that feels balanced and premium. Large display sizes should use tighter letter spacing for a "designed" editorial look.
- **Body & Labels:** Hanken Grotesk offers exceptional readability at smaller sizes. Labels utilize uppercase styling and increased tracking to create a sense of organized, professional categorization.
- **Hierarchy:** Maintain a strict contrast between weights. Use Semibold (600) for headers to anchor the page, and Regular (400) for long-form content to ensure a comfortable reading experience.

## Layout & Spacing

This design system follows a **Fluid Grid** model optimized for mobile-first consumption.

- **Base Unit:** A 4px baseline grid ensures consistent vertical rhythm.
- **Grid System:** A 4-column grid for mobile with 16px gutters and 20px side margins.
- **Whitespace:** Emphasize the "art of the void" (*Ma*). Use generous `xl` (40px) spacing between major content sections to allow the user's eyes to rest.
- **Alignment:** All text elements should be left-aligned to mimic traditional vertical reading patterns adapted for modern horizontal screens.

## Elevation & Depth

Visual hierarchy is achieved through a mix of **Tonal Layering** and **Ambient Shadows**.

- **Surfaces:** The primary background is the Washi Paper color. Cards and floating elements use pure white (#FFFFFF) to "lift" off the page.
- **Shadows:** Use extremely soft, low-opacity shadows with a slight Deep Indigo tint. This prevents the "muddy" look of pure black shadows. Shadows should feel like light passing through shoji screens—diffused and gentle.
- **Layering:** Avoid high-stacking. Use a maximum of two elevation levels (Background > Card). For modals, use a backdrop blur (12px) with a 20% opacity Indigo overlay to maintain focus.

## Shapes

The shape language is **Rounded**, reflecting the soft curves of ceramic sake cups (*Choko*) and wooden barrels.

- **Primary Radius:** 0.5rem (8px) for standard components like buttons and input fields.
- **Large Radius:** 1rem (16px) for cards and container sections to create a softer, more approachable container for imagery.
- **Pills:** Used exclusively for tags and status indicators to differentiate them from interactive buttons.

## Components

### Buttons
- **Primary:** Deep Indigo background with White text. 0.5rem roundedness. High-contrast and bold.
- **Secondary:** Warm Cedar outline (1.5px) with Cedar text. Used for less critical actions.
- **Tertiary (CTA):** Persimmon background for "Add to Cart" or "Buy Now."

### Cards
- Pure white background with a subtle 1px border in a 10% opacity Indigo.
- Content should have 20px of internal padding.
- Imagery within cards should always have the top corners rounded to 16px.

### Input Fields
- Washi Paper background with a bottom-only border (2px) in Indigo for a "minimalist stationery" feel.
- Labels are positioned above the field in `label-lg` style.

### Chips & Tags
- Used for flavor profiles (e.g., "Dry," "Fruity").
- Small, pill-shaped with 4% Deep Indigo tint background and Deep Indigo text.

### Selection Controls
- **Checkboxes/Radio:** Deep Indigo when active. Use a custom "ink brush" checkmark icon for an artisanal touch.
- **Lists:** Separated by thin, 0.5px horizontal lines in Cedar (20% opacity) to provide structure without clutter.