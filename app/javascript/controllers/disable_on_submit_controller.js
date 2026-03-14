import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  disable(event) {
    const button = event.currentTarget
    if (!button) return

    button.disabled = true
    button.textContent = button.dataset.disabledLabel || "Buzzed"
  }
}
