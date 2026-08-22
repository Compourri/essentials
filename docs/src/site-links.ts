// Shared external links, so astro.config.mjs and Header.astro can't drift out of sync.
export const siteLinks = {
	store: { label: 'Store', href: 'https://github.com/Compourri/essentials/releases' },
	forums: { label: 'Forums', href: 'https://github.com/Compourri/essentials/discussions' },
} as const;
