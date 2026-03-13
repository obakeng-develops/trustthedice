import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    enabled: Boolean
  }

  connect() {
    if (!this.enabledValue) return

    this.element.scrollIntoView({ behavior: "smooth", block: "start" })
    this.element.classList.add("ring-2", "ring-amber-400")

    setTimeout(() => {
      this.element.classList.remove("ring-2", "ring-amber-400")
    }, 1200)
  }
}
