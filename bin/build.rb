require "fileutils"
ASSET_VERSION = Time.now.to_i

OUT = File.expand_path("..", __dir__)

def c(text) = %(<mark class="confirm">[CONFIRM: #{text}]</mark>)

IMG = {
  "widebody aircraft in a hangar at night" => ["takeoff-night", "Airliner seen through open hangar doors"],
  "aircraft records spread across a hangar workbench" => ["engine", "Turbofan engine on a widebody aircraft"],
  "technician reviewing records binders in a hangar office" => ["binders-office", "Shelves of records binders"],
  "organized records shelves and labeled binders" => ["binders-shelves", "Organized shelves of labeled binders"],
  "stacks of paper aircraft records and task cards" => ["paper-stacks", "Stacks of paper records and folders"],
  "document scanner with aviation records" => ["scanner", "Documents being scanned"],
  "engineer inspecting landing gear" => ["landing-gear", "Aircraft nose landing gear on the apron"],
  "close-up of a stamped release certificate" => ["reviewing-dark", "Reviewing documents at a desk"],
  "records specialist working through aircraft documents" => ["reviewing-dark", "Reviewing documents at a desk"],
  "sample organized records index, anonymized" => ["reviewing-pen", "Annotating a document"],
  "widebody aircraft parked on the apron" => ["widebody", "Widebody aircraft parked on the apron"],
  "lessor and operator reviewing documents at a table" => ["meeting", "Two people reviewing documents at a table"],
  "bound technical records packages on a desk" => ["tabbed-papers", "Stack of tabbed documents"],
  "printed delivery bible with section tabs" => ["folders", "Stack of bound folders"],
  "commercial aircraft on final approach" => ["approach", "Airliner on final approach over runway lights"],
  "hangar with aircraft under maintenance" => ["maintenance", "Technician working under an aircraft wing"],
  "aircraft fuselage in a hangar" => ["takeoff-night", "Airliner taking off at dusk"],
  "hangar interior with aircraft nose" => ["hangar", "Airliner seen through open hangar doors"],
  "services band" => ["engine", ""],
  "portrait of Chase (real photo)" => ["chase", "Chase, co-founder of FuseLogic"]
}.freeze

def photo(label, extra = "")
  if (img = IMG[label])
    %(<div class="photo #{extra}"><img src="#{$root}images/#{img[0]}.jpg" alt="#{img[1]}" loading="lazy"></div>)
  else
    %(<div class="photo #{extra}"><span class="photo-label">Photo needed: #{label}</span></div>)
  end
end

def bg(label)
  img = IMG.fetch(label)
  %( style="background-image: var(--overlay), url('#{$root}images/#{img[0]}.jpg')")
end

SERVICES = [
  {
    slug: "document-organization",
    name: "Document Organization",
    blurb: "Records sorted into the IATA structure, with a report of what is missing or contradictory.",
    hero_photo: "technician reviewing records binders in a hangar office",
    h2: "Records you can find, in the structure your counterparty expects",
    body: [
      "Aircraft records arrive the way they were kept: boxes, shared drives, unnamed scans, and decades of operator conventions layered on top of each other. We sort every document into the IATA records structure that lessors, lessees and buyers already work from, so the package reads the same way to everyone at the table.",
      "Every document is indexed into our database as it is sorted. That is how we find what is missing or contradictory quickly, and why every organized package comes back with a report of those gaps."
    ],
    side_photo: "organized records shelves and labeled binders",
    checklist: [
      "Sort records into the IATA lettered structure, section by section",
      "Name and index every document consistently",
      "Report missing, duplicated and contradictory records",
      "Return the organized package in the format and medium you need"
    ]
  },
  {
    slug: "document-digitization",
    name: "Document Digitization",
    blurb: "Physical records scanned, made searchable and indexed alongside your digital files.",
    hero_photo: "stacks of paper aircraft records and task cards",
    h2: "Paper records, brought into the digital package",
    body: [
      "Many records still exist only on paper: binders of task cards, shop visit reports, and release certificates covered in stamps and handwriting. We digitize physical records so they can be organized, searched and transferred with the rest of the aircraft's documentation.",
      "We work with records in whatever form they exist, on any platform or medium, and handle each package according to your requirements for transfer, storage and return."
    ],
    side_photo: "document scanner with aviation records",
    checklist: [
      "Scan physical records to clean, legible digital files",
      "Make scanned documents text-searchable where the source allows",
      "Index digitized records alongside existing digital files",
      "Handle originals according to your custody requirements"
    ]
  },
  {
    slug: "records-review",
    name: "Records Review",
    blurb: "Back-to-birth traceability, LLP reconciliation and release certificates checked against the parts.",
    hero_photo: "engineer inspecting landing gear",
    h2: "Know what the paperwork proves before the transaction does",
    body: [
      "A records review answers the questions a buyer, lessor or auditor will ask. Is the back-to-birth trace complete? Do the life-limited part figures reconcile? Is every controlled part backed by its release certificate?",
      "We report what the records establish and what they do not. A gap is reported as a gap in the documentation, together with the documents that would close it, never as a guess about the part."
    ],
    side_photo: "close-up of a stamped release certificate",
    checklist: [
      "Trace life-limited parts back to birth",
      "Reconcile CSN and TSN figures across sources",
      "Check authorised release certificates against installed parts",
      "Flag missing or contradictory records, with the documents needed to resolve them"
    ]
  },
  {
    slug: "lease-return-review",
    name: "Lease Return Review",
    blurb: "Records reviewed against the lease's return conditions, and the redelivery package assembled.",
    hero_photo: "widebody aircraft parked on the apron",
    h2: "Redelivery packages that meet the return conditions",
    body: [
      "End of lease is where records gaps become expensive. The return conditions spell out the documentation the lessor expects, and every missing page can hold up redelivery.",
      "We review the aircraft's records against the documentation requirements in the lease, assemble the redelivery package, and identify what is still outstanding while there is time to resolve it. We do the same for incoming aircraft at the start of a lease."
    ],
    side_photo: "lessor and operator reviewing documents at a table",
    checklist: [
      "Review records against the lease's documentation return conditions",
      "Assemble the redelivery records package",
      "Identify outstanding items early, with the documents required",
      "Prepare records packages for aircraft entering a new lease"
    ]
  },
  {
    slug: "document-production",
    name: "Document Production",
    blurb: "Delivery bibles and technical packages, produced from organized records with every documentation gap recorded.",
    hero_photo: "bound technical records packages on a desk",
    h2: "The packages your transaction asks for",
    body: [
      "Sales, leases and audits each call for documentation in a particular form: a delivery bible for the receiving party, or a technical package for prospective buyers.",
      "We produce those packages from organized records, so what you send to a counterparty is complete, consistent and ready to review. Anything missing or contradictory in the documentation is recorded, so there are no surprises across the table."
    ],
    side_photo: "printed delivery bible with section tabs",
    checklist: [
      "Produce delivery bibles and technical records packages",
      "Record missing or contradictory documentation in a findings report",
      "Compile status summaries for life-limited parts and airworthiness directives",
      "Format packages to the receiving party's requirements"
    ]
  }
].freeze


def header(root, active)
  services_menu = SERVICES.map do |s|
    current = active == s[:slug] ? %( aria-current="page") : ""
    %(<a href="#{root}services/#{s[:slug]}.html"#{current}>#{s[:name]}</a>)
  end.join("\n            ")
  cur = ->(key) { active == key ? %( aria-current="page") : "" }

  <<~HTML
    <div class="topbar">
      <div class="container">
        <a href="mailto:chaseproctor@fuselagic.com">chaseproctor@fuselagic.com</a>
        <a href="tel:+15096550252">(509) 655-0252</a>
        <a href="#{root}contact.html">Book a call</a>
      </div>
    </div>
    <header class="site-header">
      <div class="container">
        <a class="logo" href="#{root}index.html"><img src="#{root}images/logo.png" alt="FuseLogic, aircraft technical record services" width="900" height="243"></a>
        <button class="menu-toggle" aria-expanded="false" aria-controls="site-nav">Menu</button>
        <nav class="nav" id="site-nav">
          <a href="#{root}index.html"#{cur.("home")}>Home</a>
          <div class="nav-item">
            <a href="#{root}services/index.html"#{cur.("services")}>Services</a>
            <div class="menu">
            #{services_menu}
            </div>
          </div>
          <a href="#{root}about.html"#{cur.("about")}>About</a>
          <a class="button" href="#{root}contact.html"#{cur.("contact")}>Contact Us</a>
        </nav>
      </div>
    </header>
  HTML
end

def footer(root)
  links = SERVICES.map { |s| %(<li><a href="#{root}services/#{s[:slug]}.html">#{s[:name]}</a></li>) }.join("\n          ")
  <<~HTML
    <footer class="site-footer">
      <div class="container">
        <div class="footer-grid">
          <div>
            <a class="footer-logo" href="#{root}index.html"><img src="#{root}images/logo-icon.png" alt="" width="256" height="256"><span>Fuse<span>Logic</span></span></a>
            <p style="margin-top: 16px">Aircraft records, organized at speed. Discreet, accurate documentation work for lessors, operators and MROs.</p>
          </div>
          <div>
            <h3>Services</h3>
            <ul>
          #{links}
            </ul>
          </div>
          <div>
            <h3>Company</h3>
            <ul>
              <li><a href="#{root}about.html">About</a></li>
              <li><a href="#{root}contact.html">Contact</a></li>
            </ul>
          </div>
          <div>
            <h3>Contact</h3>
            <ul>
              <li><a href="mailto:chaseproctor@fuselagic.com">chaseproctor@fuselagic.com</a></li>
              <li><a href="tel:+15096550252">(509) 655-0252</a></li>
              <li><a href="#{root}contact.html">Book a call with Chase</a></li>
            </ul>
          </div>
        </div>
        <div class="footer-base">&copy; 2026 FuseLogic LLC</div>
      </div>
    </footer>
  HTML
end

def cta(root)
  <<~HTML
    <section class="cta">
      <div class="container">
        <h2>Ready to talk about your records?</h2>
        <p>Our client work is confidential, so we don't publish results. Chase can walk you through relevant past work and how we would approach your aircraft.</p>
        <a class="button" href="#{root}contact.html">Contact Us</a>
      </div>
    </section>
  HTML
end

def page(path, title:, description:, active:, body:, show_cta: true)
  depth = path.count("/")
  root = "../" * depth
  $root = root
  html = <<~HTML
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>#{title}</title>
      <meta name="description" content="#{description}">
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Libre+Franklin:wght@600;700;800&family=Source+Sans+3:wght@400;600&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="#{root}css/site.css?v=#{ASSET_VERSION}">
      <link rel="icon" type="image/png" href="#{root}images/favicon.png">
      <link rel="apple-touch-icon" href="#{root}images/apple-touch-icon.png">
    </head>
    <body>
    #{header(root, active)}
    <main>
    #{body.call(root)}
    </main>
    #{show_cta ? cta(root) : ""}
    #{footer(root)}
    <script src="#{root}js/site.js?v=#{ASSET_VERSION}"></script>
    </body>
    </html>
  HTML
  file = File.join(OUT, path)
  FileUtils.mkdir_p(File.dirname(file))
  File.write(file, html)
end

def hero(title, sub, photo_label, button_href, button_text, eyebrow: nil)
  <<~HTML
    <section class="hero"#{bg(photo_label)}>
      <div class="container">
        #{eyebrow ? %(<p class="eyebrow">#{eyebrow}</p>) : ""}
        <h1>#{title}</h1>
        <p>#{sub}</p>
        <a class="button" href="#{button_href}">#{button_text}</a>
      </div>
    </section>
  HTML
end

page("index.html",
  title: "FuseLogic | Aircraft Records Services",
  description: "FuseLogic organizes, digitizes, reviews and produces aircraft records for lessors, operators and MROs, with fast turnaround and full discretion.",
  active: "home",
  body: ->(root) {
    cards = SERVICES.map do |s|
      <<~HTML
        <a class="card" href="#{root}services/#{s[:slug]}.html">
          #{photo(s[:side_photo])}
          <div class="card-body">
            <h3>#{s[:name]}</h3>
            <p>#{s[:blurb]}</p>
          </div>
          <span class="card-more">Learn more &rarr;</span>
        </a>
      HTML
    end.join
    <<~HTML
      <section class="hero hero--home hero--motion" style="--hero-img: url('/images/#{IMG.fetch("widebody aircraft in a hangar at night")[0]}.jpg')">
        <div class="container">
          <p class="eyebrow">Aircraft records services</p>
          <h1>FuseLogic</h1>
          <p>Aircraft records, organized at speed. We sort, digitize, review and produce the documentation behind every purchase, sale, lease and return, so your transaction isn't waiting on paperwork.</p>
          <div class="button-row">
            <a class="button" href="#services">Our Services</a>
            <a class="button button--light" href="#{root}contact.html">Book a call</a>
          </div>
        </div>
      </section>

      <section class="section">
        <div class="container split split--reverse">
          #{photo("records specialist working through aircraft documents")}
          <div class="split-copy">
            <p class="eyebrow">Who we are</p>
            <h2>Where aviation meets technology</h2>
            <p>Every aircraft transaction depends on proving what the aircraft is made of and where each controlled part came from. That proof is still largely assembled by hand, at enormous cost in time.</p>
            <p>That's the work we take off your plate. You send us your records as they are, and we send them back organized, reviewed and ready for your transaction.</p>
            <p>FuseLogic brings together aviation industry relationships and a team experienced in building software and data systems. Our methods were developed on real-world records packages provided through industry partners.</p>
            <a class="button" href="#{root}about.html">About FuseLogic</a>
          </div>
        </div>
      </section>

      <section class="band" id="services"#{bg("services band")}>
        <div class="container">
          <h2>Our Services</h2>
          <p class="lede">Five services that cover the records side of an aircraft transaction, from a box of paper to a finished delivery bible.</p>
          <div class="cards">
            #{cards}
          </div>
        </div>
      </section>

      <section class="section section--cream">
        <div class="container">
          <div class="pillars">
            <div class="pillar">
              <h3>Competitive turnaround</h3>
              <p>Speed is the core of what we offer. Records work that usually holds up a transaction for weeks moves at a pace that keeps your schedule intact. Our results are confidential, but Chase can walk you through them on a call.</p>
            </div>
            <div class="pillar">
              <h3>Discretion as standard</h3>
              <p>Aircraft records reviews are confidential by nature. We don't publish client names or results, and we tailor file handling to each client's requirements.</p>
            </div>
            <div class="pillar">
              <h3>Any format, any medium</h3>
              <p>Paper binders, scans, spreadsheets and legacy systems. We take records in whatever form they exist and return them in the form you need.</p>
            </div>
          </div>
        </div>
      </section>
    HTML
  })

page("services/index.html",
  title: "Services | FuseLogic",
  description: "Document organization, digitization, records review, lease return review and document production for commercial aircraft.",
  active: "services",
  body: ->(root) {
    rows = SERVICES.map do |s|
      <<~HTML
        <div class="service-row">
          <h3>#{s[:name]}</h3>
          <p>#{s[:blurb]}</p>
          <a class="button" href="#{root}services/#{s[:slug]}.html">Learn more</a>
        </div>
      HTML
    end.join
    <<~HTML
      #{hero("Our Services", "Everything the records side of an aircraft transaction needs, delivered quickly and confidentially.", "aircraft records spread across a hangar workbench", "#{root}contact.html", "Contact Us")}
      <section class="section section--cream">
        <div class="container">
          <div class="services-list">
            #{rows}
          </div>
        </div>
      </section>
    HTML
  })

SERVICES.each do |s|
  page("services/#{s[:slug]}.html",
    title: "#{s[:name]} | FuseLogic",
    description: s[:blurb],
    active: s[:slug],
    body: ->(root) {
      items = s[:checklist].map { |i| "<li>#{i}</li>" }.join("\n            ")
      paras = s[:body].map { |p| "<p>#{p}</p>" }.join("\n          ")
      <<~HTML
        #{hero(s[:name], s[:blurb], s[:hero_photo], "#{root}contact.html", "Contact Us")}
        <section class="section">
          <div class="container split">
            <div class="split-copy">
              <h2>#{s[:h2]}</h2>
              #{paras}
              <a class="button" href="#{root}contact.html">Contact Us</a>
            </div>
            #{photo(s[:side_photo])}
          </div>
        </section>
        <section class="section section--cream checklist-section">
          <div class="container split split--reverse">
            #{photo("sample organized records index, anonymized")}
            <div>
              <h2>FuseLogic can:</h2>
              <ul class="checklist">
            #{items}
              </ul>
            </div>
          </div>
        </section>
      HTML
    })
end

page("about.html",
  title: "About | FuseLogic",
  description: "FuseLogic brings aviation industry relationships and technology experience together on aircraft records work.",
  active: "about",
  body: ->(root) {
    <<~HTML
      #{hero("About FuseLogic", "Aviation records, approached as a data problem.", "commercial aircraft on final approach", "#{root}contact.html", "Contact Us")}
      <section class="section">
        <div class="container split">
          <div class="split-copy">
            <h2>Bringing two industries together</h2>
            <p>FuseLogic was founded to bring the aviation and technology sectors together on one of the industry's most manual jobs: assembling and reviewing aircraft records. Every purchase, sale, lease and return requires proving what an aircraft is made of, and that proof is still largely assembled page by page.</p>
            <p>Our team pairs aviation industry relationships with experience building software and data systems. Our methods were developed on real-world records packages provided through industry partners, including the landing gear records of an Airbus A330.</p>
          </div>
          #{photo("hangar with aircraft under maintenance")}
        </div>
      </section>

      <section class="section section--cream">
        <div class="container split split--reverse">
          #{photo("portrait of Chase (real photo)", "photo--portrait")}
          <div class="split-copy">
            <p class="eyebrow">Our story</p>
            <h2>Meet Chase</h2>
            <p>Chase Proctor, co-founder, leads client relationships at FuseLogic and brings a background in international sales.</p>
            <blockquote class="quote">
              <p>&ldquo;Growing up in a family of Boeing engineers, my grandparents would tell me stories about the design challenges they faced. My grandma created the program to introduce software into the fault-finding networks between engineering and manufacturing. She showed me how much impact one person can have on a company's workflow by finding simple solutions to complex problems. That is, more or less, the same thing we have done here at FuseLogic.&rdquo;</p>
            </blockquote>
            <p>If you're reading this, you have probably already spoken with Chase, and he's the best person to talk to about your next records project.</p>
            <a class="button" href="#{root}contact.html">Book a call with Chase</a>
          </div>
        </div>
      </section>

      <section class="section section--cream">
        <div class="container">
          <div class="pillars">
            <div class="pillar">
              <h3>Confidential by default</h3>
              <p>We don't publish client names or results, and every records package is handled with discretion. Our legal team handles any and all agreements on discretion and non-disclosure.</p>
            </div>
            <div class="pillar">
              <h3>Handled your way</h3>
              <p>File handling is tailored to each client's requirements for transfer, storage and return, across any platform or medium.</p>
            </div>
            <div class="pillar">
              <h3>Built on real records</h3>
              <p>Our process was developed on real-world aircraft documentation, not sample files, so it is ready for the packages you actually have.</p>
            </div>
          </div>
        </div>
      </section>
    HTML
  })

page("contact.html",
  title: "Contact Us | FuseLogic",
  description: "Book a call with Chase at FuseLogic to talk about your aircraft records.",
  active: "contact",
  show_cta: false,
  body: ->(root) {
    <<~HTML
      #{hero("Contact Us", "Book a call with Chase to talk through your aircraft, your records and your timeline.", "aircraft fuselage in a hangar", "#booking", "Book a call")}
      <section class="section section--cream">
        <div class="container">
          <div class="contact-grid">
            <div class="contact-booking" id="booking">
              <h2>Book a call with Chase</h2>
              <p>Pick a time that works for you. You'll get a calendar invite right away, and Chase will come prepared to talk about your records.</p>
              <div class="calendly-inline-widget booking-widget" data-url="https://calendly.com/chaseproctor-fuselagic/30min?hide_gdpr_banner=1&amp;primary_color=9b2c1f"></div>
              <p class="booking-fallback">Calendar not loading? <a href="https://calendly.com/chaseproctor-fuselagic/30min" target="_blank" rel="noopener">Book directly on Calendly</a>.</p>
              <script src="https://assets.calendly.com/assets/external/widget.js" async></script>
            </div>
            <aside class="contact-panel">
              <h2>Prefer email?</h2>
              <div class="contact-line">
                <strong>Email</strong>
                <a href="mailto:chaseproctor@fuselagic.com">chaseproctor@fuselagic.com</a>
              </div>
              <div class="contact-line">
                <strong>Phone</strong>
                <a href="tel:+15096550252">(509) 655-0252</a>
              </div>
              <div class="contact-line">
                <strong>Confidentiality</strong>
                <span>Every engagement is confidential. Our legal team handles any agreements on discretion and non-disclosure, and file handling is tailored to your requirements.</span>
              </div>
              #{photo("hangar interior with aircraft nose")}
            </aside>
          </div>
        </div>
      </section>
    HTML
  })

puts Dir.glob("#{OUT}/**/*.html").sort
