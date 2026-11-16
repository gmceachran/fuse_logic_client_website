# Fuselagic client website

The public site for Fuselagic LLC, live at **https://fuselagic.com**. It's a
static brochure site that people visit after meeting Chase Proctor
(co-founder, sales). Its job is to make the company look credible and get the
visitor to book a call with Chase or email him.

The layout, page flow and tone follow the *GC Aviation Site Rebuild — Handoff*
PDF, with a warm red and amber palette in place of GC's navy.

## Layout

| Path | What it is |
|---|---|
| `bin/build.rb` | Generates every HTML page: header, nav, footer, call to action, page copy, photo choices |
| `*.html`, `services/*.html` | Generated output (9 pages). Committed because GitHub Pages serves them as-is |
| `css/site.css` | All styles. Colors and fonts are tokens at the top in `:root` |
| `js/site.js` | Mobile menu and the scroll-in animations |
| `images/` | Stock photos (Unsplash, free license), Chase's photo, logo, favicon |
| `sitemap.xml`, `robots.txt` | Search engine files, edited by hand |
| `CNAME` | Tells GitHub Pages which domain to serve |

## Working on the site

Requires Ruby (any recent version) and Python 3 for the preview server.

1. Change copy or structure in `bin/build.rb`, or styles in `css/site.css`
   and behavior in `js/site.js`.
2. Rebuild the pages:

   ```bash
   ruby bin/build.rb
   ```

   Each build stamps a new `?v=` number on the CSS and JS links so visitors
   get fresh files on a normal refresh.
3. Preview at http://localhost:4180:

   ```bash
   python3 -m http.server 4180
   ```

   Open it through the server, not as a file. The home header loads its photo
   from an absolute `/images/...` path.
4. If you add or remove a page, update `sitemap.xml` too.

## Deploying

Pushing to `main` publishes the site. GitHub Pages runs a "pages build and
deployment" action and the change is live in about a minute.

```bash
gh run watch --repo gmceachran/fuse_logic_client_website
```

## Hosting, domain and email

- **Hosting:** GitHub Pages from the public repo
  `gmceachran/fuse_logic_client_website`, branch `main`, root folder. HTTPS is
  on and enforced.
- **Domain:** fuselagic.com, registered at Namecheap. DNS is
  managed in Namecheap under Advanced DNS.
- **Email:** chaseproctor@fuselagic.com runs on Google Workspace.

DNS records for fuselagic.com:

| Type | Host | Value | Purpose |
|---|---|---|---|
| A | `@` | `185.199.108.153` | GitHub Pages |
| A | `@` | `185.199.109.153` | GitHub Pages |
| A | `@` | `185.199.110.153` | GitHub Pages |
| A | `@` | `185.199.111.153` | GitHub Pages |
| CNAME | `www` | `gmceachran.github.io.` | GitHub Pages |
| MX | `@` | `smtp.google.com`, priority 1 | Google Workspace mail |
| TXT | `@` | `v=spf1 include:_spf.google.com ~all` | Lets Google send as @fuselagic.com |
| TXT | `@` | `google-site-verification=…` | Google Workspace ownership |

In Namecheap, MX records live under **Mail Settings** (set to Custom MX), not
in the main Host Records list.

### Moving to another domain

To serve the site on a new domain (for example fuselogic.aero), whoever holds
that domain adds the four A records and the `www` CNAME above at their
registrar. Then:

1. Change `CNAME` to the new domain, and change the domain in `robots.txt` and
   `sitemap.xml`.
2. Push, then wait for GitHub to issue the HTTPS certificate (15–60 minutes)
   and confirm "Enforce HTTPS" is on in the repo's Settings → Pages.
3. Keep fuselagic.com registered and pointing at the new domain, because Chase's
   email address and Calendly link use it.

## Other domains

roswellaero.com is the old company site, served from the `airplane_landing_site`
repo. The plan was to turn off its auto-renew in Namecheap, point it at the new site until it expires on April 20, 2027, and then
turn off GitHub Pages on that repo.
