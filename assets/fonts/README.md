# Font Assets

This folder contains custom font files for the app.

## Supported Formats:
- **TTF**: TrueType Font (recommended)
- **OTF**: OpenType Font
- **WOFF**: Web Open Font Format (for web)

## Font Files:
- `Inter-Regular.ttf` - Regular weight
- `Inter-Medium.ttf` - Medium weight
- `Inter-SemiBold.ttf` - Semi-bold weight
- `Inter-Bold.ttf` - Bold weight

## Usage in pubspec.yaml:
```yaml
fonts:
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter-Regular.ttf
      - asset: assets/fonts/Inter-Medium.ttf
        weight: 500
      - asset: assets/fonts/Inter-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/Inter-Bold.ttf
        weight: 700
```

## Font Licensing:
- Ensure you have proper licensing for custom fonts
- Google Fonts are free to use
- Commercial fonts require proper licensing

## Performance Tips:
- Only include font weights you actually use
- Consider using system fonts for better performance
- Test font loading on slower devices
