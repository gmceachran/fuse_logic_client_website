# AGENTS.md

Read `README.md` for the layout, build, preview, deploy and DNS details.

## What the site is for

- Visitors arrive after meeting Chase Proctor. The site's job is credibility,
  and its only call to action is to contact Chase: book a call through the
  Calendly widget on `contact.html`, or email him.
- FuseLogic sells a **service**: clients send records as they are and get them
  back organized, reviewed and ready for their transaction. Talking about
  bringing aviation and technology together is fine. Never present the
  software, databases or hosting as something the client buys or uses.
- Layout, page flow and tone follow the GC Aviation handoff PDF. Keep new
  pages consistent with that structure.

## Copy rules

- Spell the name **FuseLogic**, capital "L". The legal
  name is **FuseLogic LLC**.
- Never invent facts: no made-up staff, AI-generated faces, clients,
  testimonials, certifications, years in business or performance numbers. If
  copy needs a fact nobody has given you, mark it
  `[CONFIRM: what's needed]` with `c("...")` in `bin/build.rb` and ask.
- Turnaround is described as competitive. Results are confidential, so never
  publish numbers; point people to Chase for specifics.
- Don't mention NDAs. Confidentiality copy says the legal team handles any
  agreements on discretion and non-disclosure.
- FuseLogic doesn't certify documents. It organizes them and records missing
  or contradictory documentation.
- There is no parts business or parts link.
- Photos are free-license stock (Unsplash) without airline logos. Any photo of
  a real person must be a real photo of that person.

## Structure rules

- Nav is Home, Services (dropdown of the five service pages), About, and a
  Contact Us button. Contact always goes to the dedicated `contact.html` page,
  never a scroll to the bottom of a page.
- Every page except Contact ends with the shared call to action linking to
  `contact.html`.
- Animations must respect `prefers-reduced-motion`.

## Working rules

- Never hand-edit the generated `*.html` files. Change `bin/build.rb`, then run
  `ruby bin/build.rb`. Edit `css/site.css`, `js/site.js`, `sitemap.xml` and
  `robots.txt` directly.
- Colors and fonts come from the tokens in `:root` in `css/site.css`; don't
  hard-code new ones.
- Check changes in the browser at http://localhost:4180 before reporting them
  done.
- Pushing to `main` deploys to the live site, so push only when the user says
  so. After a push, confirm the deploy passed and the live page shows the
  change.
- Don't change `CNAME` or DNS-related files unless the task is a domain change.
