# The Art Exchange - Branding Guidelines

## Logo Specifications

### Official Logo
- **File**: `app/assets/images/logo/the_art_exchange.svg`
- **Format**: SVG (scalable vector graphics)
- **Dimensions**: 840.17 × 213.57 viewBox
- **Usage**: Primary brand identifier across all interfaces

### Logo Colors
The official logo contains four primary colors that define our brand identity:

| Color | Hex Code | CSS Class | Usage |
|-------|----------|-----------|-------|
| **Primary Dark** | `#231f20` | `.cls-1` | Main text elements, primary typography |
| **Gray** | `#a7a9ac` | `.cls-2` | Subtle accents, secondary elements |
| **Brand Red** | `#c10230` | `.cls-3` | Primary brand color, CTAs, highlights |
| **White** | `#ffffff` | `.cls-4` | Contrast text, backgrounds |

## Color Scheme Migration

### From Orange to Red Brand Identity
We've migrated from an orange-based color scheme to align with our official logo's red branding.

#### Color Mapping
| Old (Orange) | New (Red) | Tailwind Classes |
|--------------|-----------|------------------|
| `#f97316` (orange-500) | `#dc2626` (red-600) | Primary buttons, CTAs |
| `#fb923c` (orange-400) | `#ef4444` (red-500) | Lighter accents |
| `#ea580c` (orange-600) | `#b91c1c` (red-700) | Hover states, darker elements |
| Gradients: `from-orange-400 to-orange-600` | `from-red-500 to-red-600` | Brand gradients |

#### Focus and Interactive States
- **Focus rings**: `focus:ring-orange-500` → `focus:ring-red-500`
- **Hover states**: `hover:bg-orange-600` → `hover:bg-red-700`
- **Border colors**: `border-orange-500` → `border-red-500`

## Component Standards

### Navigation Bar
- **Logo**: Official SVG logo optimized for h-16 navbar height
- **Primary brand elements**: Use brand red for CTAs and interactive elements
- **Text**: Maintain stone-600/900 for navigation links

### Buttons
- **Primary**: Red background (`bg-red-600`) with red-700 hover
- **Secondary**: White background with red border and text
- **Danger**: Keep existing red (different shade for distinction)
- **Success**: Maintain emerald green (no change)

### Forms and Inputs
- **Focus states**: Red focus rings (`focus:ring-red-500`)
- **Error states**: Use red-600 for error messaging
- **Success states**: Keep emerald for positive feedback

### Search Interface
- **Filter badges**: Red background for active selections
- **Sort controls**: Red accents for interactive elements
- **Search button**: Primary red styling

## Accessibility Requirements

### Contrast Ratios
All color combinations must meet WCAG 2.1 AA standards:
- **Normal text**: Minimum 4.5:1 contrast ratio
- **Large text**: Minimum 3:1 contrast ratio
- **Interactive elements**: Clear focus indicators with sufficient contrast

### Testing
- Test all color combinations with accessibility tools
- Verify readability across different screen conditions
- Ensure color is not the only means of conveying information

## Usage Guidelines

### Logo Usage
- **Minimum size**: 120px width for readability
- **Clear space**: Maintain adequate whitespace around logo
- **Background**: Ensure sufficient contrast with background colors
- **Scaling**: Use SVG format for crisp rendering at all sizes

### Color Application
- **Primary red**: Use sparingly for maximum impact on CTAs and highlights
- **Gray accents**: Use for subtle elements that don't require attention
- **Dark text**: Primary color for main content and headers
- **White**: For contrast and breathing room

### Don'ts
- Don't modify the logo colors or proportions
- Don't use the old orange colors in new components
- Don't combine red with competing warm colors
- Don't forget to test accessibility when implementing new color combinations

## Implementation Notes

### Asset Management
- Logo stored in: `app/assets/images/logo/the_art_exchange.svg`
- Use Rails asset helpers: `image_tag("logo/the_art_exchange.svg")`
- Consider creating different logo variants if needed (mark-only, etc.)

### CSS Variables (Future Enhancement)
Consider implementing CSS custom properties for brand colors:
```css
:root {
  --brand-red: #c10230;
  --brand-dark: #231f20;
  --brand-gray: #a7a9ac;
  --brand-white: #ffffff;
}
```

### Browser Compatibility
- SVG logos are supported in all modern browsers
- Fallback considerations for older browsers if needed
- Test rendering across different devices and screen densities

## Brand Evolution

This color scheme migration represents Phase 1 of our brand consistency initiative. Future considerations may include:
- Typography enhancements to match logo styling
- Additional brand assets (favicons, social media assets)
- Expanded color palette for seasonal or special features
- Brand voice and messaging guidelines

---

**Last Updated**: 2025-06-25  
**Version**: 1.0  
**Maintainer**: Development Team