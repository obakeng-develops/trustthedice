import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    skipRestore: Boolean
  }

  connect() {
    this.storeScroll = this.storeScroll.bind(this)
    this.restoreScroll = this.restoreScroll.bind(this)

    document.addEventListener("turbo:submit-start", this.storeScroll)
    document.addEventListener("turbo:render", this.restoreScroll)
  }

  disconnect() {
    document.removeEventListener("turbo:submit-start", this.storeScroll)
    document.removeEventListener("turbo:render", this.restoreScroll)
  }

  storeScroll() {
    if (this.skipRestoreValue) return
    this.lastScrollY = window.scrollY
  }

  restoreScroll() {
    if (this.skipRestoreValue) return
    if (typeof this.lastScrollY !== "number") return
    window.scrollTo(0, this.lastScrollY)
  }

  disableRestore() {
    this.skipRestoreValue = true
  }

  enableRestore() {
    this.skipRestoreValue = false
  }
}
