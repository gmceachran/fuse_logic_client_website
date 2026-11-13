const toggle = document.querySelector(".menu-toggle")
const nav = document.querySelector(".nav")

const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches

const settleAfterReveal = (target, className) => {
  target.addEventListener("transitionend", function settle(event) {
    if (event.target !== target || event.propertyName !== "transform") return
    if (!target.classList.contains("is-revealed")) return
    target.classList.remove(className, "is-revealed")
    target.style.transitionDelay = ""
    target.removeEventListener("transitionend", settle)
  })
}

if ("IntersectionObserver" in window && !reduceMotion) {
  const targetsBySection = new Map()

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return
        targetsBySection.get(entry.target).forEach((target) => target.classList.add("is-revealed"))
        observer.unobserve(entry.target)
      })
    },
    { rootMargin: "0px 0px -25% 0px" }
  )

  document.querySelectorAll(".split--reverse > :last-child").forEach((target) => {
    const section = target.closest("section") || target.parentElement
    target.classList.add("reveal-right")
    settleAfterReveal(target, "reveal-right")
    if (!targetsBySection.has(section)) {
      targetsBySection.set(section, [])
      observer.observe(section)
    }
    targetsBySection.get(section).push(target)
  })
}

if (!reduceMotion) {
  const rows = []

  const pageTop = (el) => Math.round(el.getBoundingClientRect().top + window.scrollY)

  document.querySelectorAll(".band").forEach((band) => {
    const heading = [...band.querySelectorAll("h2, .lede")]
    if (heading.length) rows.push({ top: pageTop(heading[0]), cards: heading, className: "reveal-rise", done: false })

    const byTop = new Map()
    band.querySelectorAll(".card").forEach((card) => {
      const top = pageTop(card)
      if (!byTop.has(top)) byTop.set(top, [])
      byTop.get(top).push(card)
    })
    byTop.forEach((cards, top) => rows.push({ top, cards, className: "reveal-up", done: false }))
  })

  rows.sort((a, b) => a.top - b.top)
  rows.forEach((row) =>
    row.cards.forEach((el) => {
      el.classList.add(row.className)
      settleAfterReveal(el, row.className)
    })
  )

  const revealRows = () => {
    const line = window.scrollY + window.innerHeight * 0.9
    let stagger = 0
    rows.forEach((row) => {
      if (row.done || row.top > line) return
      row.done = true
      row.cards.forEach((card) => {
        card.style.transitionDelay = `${stagger * 0.15}s`
        card.classList.add("is-revealed")
      })
      stagger += 1
    })
    if (rows.every((row) => row.done)) window.removeEventListener("scroll", revealRows)
  }

  if (rows.length) {
    window.addEventListener("scroll", revealRows, { passive: true })
    revealRows()
  }
}

if (toggle && nav) {
  toggle.addEventListener("click", () => {
    const open = nav.classList.toggle("is-open")
    toggle.setAttribute("aria-expanded", String(open))
  })
}
