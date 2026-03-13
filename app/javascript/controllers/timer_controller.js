import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    startedAt: String,
    seconds: Number
  }

  static targets = ["output"]

  connect() {
    this.tick = this.tick.bind(this)
    this.tick()
    this.interval = setInterval(this.tick, 1000)
  }

  disconnect() {
    if (this.interval) clearInterval(this.interval)
  }

  tick() {
    const total = this.secondsValue || 30
    const startedAt = this.startedAtValue ? new Date(this.startedAtValue) : null

    let remaining = total
    if (startedAt) {
      const elapsed = Math.floor((Date.now() - startedAt.getTime()) / 1000)
      remaining = Math.max(total - elapsed, 0)
    }

    if (this.hasOutputTarget) {
      this.outputTarget.textContent = `${remaining}s`
    }
  }
}
