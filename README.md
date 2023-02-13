# Editio
LaTeX editing tools, templates, and workflows using Nix

## Repository structure

```bash
.
├── README.md
│  
├── flake.nix       # global flake
├── default.nix     # editio derivation
│  
├── templates       # flake templates
│   ├── vanilla     #  - vanilla LaTeX template
│   ├── base        #  - base template with some packages
│   ├── ieee        #  - IEEEtran compatible template
│   └── minted      #  - template with minted package
│  
└── testing         # flake for testing locally
```

